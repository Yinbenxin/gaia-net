
#include "grpc_client.h"
#include <chrono>
#define REDIS_BRPOP_TIMEOUT 120

static std::string to_lower(const std::string& input) {
    std::string ret(input);
    std::transform(ret.begin(), ret.end(), ret.begin(), [](unsigned char c) {
        return std::tolower(c);
    });
    return ret;
}

// remote grpc server version
enum class ServiceVersion : int {
    not_inited = -1,
    v1 = 1,
    v2 = 2
};

// recv from redis, data format version
enum class RedisDataVersion : int {
    not_inited = -1,
    v1 = 1,
    v2 = 2
};

enum class RecvThreadStatus : int {
    not_inited = -1,
    started = 1,
    finished = 2,
};

const int config_support_max_version = (int)ServiceVersion::v2;

const std::string_view data_version_magic_string("372b2fc1839a9e161dd972c2964e11a262c419ad");

namespace gaianet {

    RpcClient::RpcClient(const channel& ch, std::shared_ptr<Channel> channel, uint32_t partyid, uint32_t to_party_id, std::string redis_address,
                         bool use_redis /* false */, bool net_debug /* false */)
        : m_ref_channel(ch)
        , m_partyid(partyid)
        , m_to_partyid(to_party_id)
        , m_use_redis(use_redis)
        , m_net_debug(net_debug)
        , m_stub(DataTransferService::NewStub(channel))
        , m_chl(channel)
        , m_use_rpc_version((int)ServiceVersion::not_inited)
        , m_use_redis_data_version((int)RedisDataVersion::not_inited)
        , m_seq(0)
        , m_recv_idx(-1)
        , m_recv_thread_status((int)RecvThreadStatus::not_inited) {

        char* redis_timeout_env;
        redis_timeout_env = getenv("CPP_REDIS_TIMEOUT");
        if (redis_timeout_env) {
            m_redis_timeout = atoi(redis_timeout_env);
            // gaialog_info("set redis timeout to {} from env CPP_REDIS_TIMEOUT", m_redis_timeout);
        } else {
            m_redis_timeout = REDIS_BRPOP_TIMEOUT;
            // gaialog_info("set redis timeout to {} from default value", m_redis_timeout);
        }

        if (m_use_redis) {
            redis_client = new RedisClient(redis_address);
            try {
                redis_client->ping();
                // gaialog_info("redis ping succeed");
            } catch (const Error& err) {
                // gaialog_error("redis ping {} Err: {}", redis_address, err.what());
            }
        }
    }

    RpcClient::~RpcClient() {
        if (m_use_redis) {
            delete redis_client;
        }
    }

    void RpcClient::init_sender() {

        m_context.AddMetadata("object-key", std::to_string(m_to_partyid) + std::to_string(m_partyid));
        m_context.AddMetadata("service", "gaia-tensor");

        m_context.AddMetadata("x-be-host", "edge.tensor.grpc.trustbe.com");

        for (auto const& [k, v] : m_ref_channel.get_meta()) {
            if (k == "net_usage_redis_key") {
                continue;
            }
            auto lower_k = to_lower(k);
            m_context.AddMetadata(std::move(lower_k), v);
        }

        unsigned int client_connection_timeout = 10000;

        std::chrono::system_clock::time_point deadline = std::chrono::system_clock::now() + std::chrono::seconds(client_connection_timeout);
        m_context.set_deadline(deadline);

        if (m_use_rpc_version >= (int)ServiceVersion::v2) {
            m_rw_sender = m_stub->push_v2(&m_context);

            m_recv_thread = std::thread([this] {
                try {
                    m_recv_thread_status = (int)RecvThreadStatus::started;

                    // gaialog_info("recv thread start...");
                    Packet resp;

                    for (;;) {
                        // m_mtx.lock();
                        bool flag = m_rw_sender->Read(&resp);
                        // m_mtx.unlock();
                        if (flag) {
                            // // gaialog_info("get ack:{}", resp.header().ack());
                            auto lk = std::unique_lock(m_mtx);
                            m_cv.wait(lk, [&] {
                                return !m_notack_queue.empty();
                            });
                            lk.unlock();
                            auto& front = m_notack_queue.front();
                            if (front.header().seq() != resp.header().ack()) {
                                // gaialog_error("receive a error data: need:{}, but get:{}", front.header().seq(), resp.header().ack());
                            }
                            // gaialog_assert(front.header().seq() == resp.header().ack());
                            {
                                auto lk = std::unique_lock(m_mtx);
                                m_notack_queue.pop_front();
                            }
                        } else {
                            auto lk = std::unique_lock(m_mtx);
                            if (!m_notack_queue.empty()) {
                                // gaialog_info("recv ack not finished");
                            }
                            break;
                        }
                    }

                } catch (std::exception& e) {
                    // gaialog_info("recv thread get a exception:{}", e.what());
                }
                m_recv_thread_status = (int)RecvThreadStatus::finished;
                // gaialog_info("recv thread finished...");
            });

        } else {
            m_sender = m_stub->push(&m_context, &m_stats);
        }
    }

    void RpcClient::init_rpc_version() {
        // gaialog_assert(m_use_rpc_version == (int)ServiceVersion::not_inited);

        for (int i = 0; i < 20; ++i) {
            ClientContext ctx;
            VersionRequest req;
            VersionResponse resp;

            // init ctx
            ctx.AddMetadata("object-key", std::to_string(m_to_partyid) + std::to_string(m_partyid));
            ctx.AddMetadata("service", "gaia-tensor");
            ctx.AddMetadata("x-be-host", "edge.tensor.grpc.trustbe.com");

            for (auto const& [k, v] : m_ref_channel.get_meta()) {
                if (k == "net_usage_redis_key") {
                    continue;
                }
                auto lower_k = to_lower(k);
                if (i == 0) {
                    // gaialog_info("add meta: {}:{}", lower_k, v);
                }
                ctx.AddMetadata(std::move(lower_k), v);
            }

            // call version
            auto status = m_stub->get_version(&ctx, req, &resp);
            if (status.ok()) {
                m_use_rpc_version = std::min(resp.version(), config_support_max_version);
                // gaialog_info("get remote rpc version:{}, local version:{}", resp.version(), config_support_max_version);
                break;
            } else {
                if (status.error_code() == grpc::StatusCode::UNIMPLEMENTED) {
                    m_use_rpc_version = (int)ServiceVersion::v1;
                    break;
                }
                // gaialog_warn("call version error: code:{}, message:{}, detail:{}", status.error_code(), status.error_message(), status.error_details());
                std::this_thread::sleep_for(std::chrono::seconds(1));
            }
        }

        if (m_use_rpc_version == (int)ServiceVersion::not_inited) {
            // gaialog_error("init_rpc_version failed...");
            throw "init_rpc_version failed...";
        }

        // gaialog_info("init_rpc_version use_rpc_version:{}", m_use_rpc_version);
    }

    void RpcClient::init_redis_data_version(std::string& content_temp) {
        // gaialog_assert(m_use_redis_data_version == (int)RedisDataVersion::not_inited);
        if (content_temp.substr(0, data_version_magic_string.length()) == data_version_magic_string) {
            m_use_redis_data_version = (int)RedisDataVersion::v2;
            content_temp = content_temp.substr(data_version_magic_string.length());
        } else {
            m_use_redis_data_version = (int)RedisDataVersion::v1;
        }
        // gaialog_info("use_redis_data_version:{}", m_use_redis_data_version);
    }

    bool RpcClient::Send(const std::string& taskid, std::string& content) {

        if (m_use_rpc_version == (int)ServiceVersion::not_inited) {
            init_rpc_version();
            init_sender();
        }

        if (m_recv_thread_status == (int)RecvThreadStatus::finished) {
            // gaialog_warn("call send but stream end...");
            return false;
        }
        //         Data we are sending to the server.
        Packet packet;
        packet.mutable_header()->set_taskid(std::move(taskid));
        packet.mutable_header()->set_frompartyid(std::to_string(m_partyid));
        packet.mutable_header()->set_topartyid(std::to_string(m_to_partyid));
        packet.mutable_header()->set_servicetype(TENSOR);
        //        meta.set_tasktype(PSI);
        if (m_net_debug) {
            std::stringstream ss;
            for (size_t j = 0; j < content.length(); j++) {
                uint8_t* tmp_ptr = (uint8_t*)content.data();
                ss << std::setw(2) << std::setfill('0') << (std::hex) << (unsigned int)tmp_ptr[j];
            }
            // gaialog_info("exec Sender debug info {}", ss.str());
        }
        packet.mutable_body()->swap(content);

        bool flag;
        if (m_use_rpc_version >= (int)ServiceVersion::v2) {
            packet.mutable_header()->set_seq(m_seq);
            flag = m_rw_sender->Write(packet);

// TODO : run this in async framework...
#if 0
            if (false) {
                Packet resp;
                flag = m_rw_sender->Read(&resp);

                if (flag && resp.header().ack() == packet.header().seq()) {
                    m_ack = resp.header().ack();
                } else {
                    // gaialog_error("get ack error for : flag:{} seq:{} ack:{}", flag, packet.header().seq(), resp.header().ack());
                    return false;
                }
            }

#endif
            if (flag) {
                m_seq++;
                // // gaialog_info("send succeed...{}", packet.header().seq());
                {
                    auto lg = std::unique_lock(m_mtx);
                    m_notack_queue.emplace_back(std::move(packet));
                }
                m_cv.notify_one();
            } else {
                //
            }

        } else {
            flag = m_sender->Write(packet);
        }

        if (!flag) {
            packet.mutable_body()->swap(content);
            // gaialog_warn("send failed...");
            return false;
        }
        return true;
    }

    bool RpcClient::Recv(const std::string& taskid, std::string& content, bool* need_resend) {
        // gaialog_assert_msg(content.empty(), "channel taskid:{},partyid:{},to_partyid:{} should use a empty string for receive data", m_ref_channel.get_taskid(),
                        //    m_partyid, m_to_partyid);
        if (m_use_redis) {
            for (int i = 1; i <= m_redis_timeout || m_redis_timeout == 0; ++i) {
                try {
                    auto res = redis_client->brpop(std::to_string(m_to_partyid) + std::to_string(m_partyid) + taskid, 1);
                    if (res) {
                        std::string content_temp = std::move(res->second); // todo substr this string but without copy

                        if (m_use_redis_data_version == (int)RedisDataVersion::not_inited) { // not inited
                            init_redis_data_version(content_temp);
                        }

                        if (m_use_redis_data_version >= (int)RedisDataVersion::v2) {
                            int32_t idx;
                            memcpy(&idx, content_temp.data(), sizeof(int32_t));

                            // control cmd generated by local grpc_server...
                            if (content_temp.size() == sizeof(int32_t) && idx < 0) {
                                if (idx == -1) {
                                    // gaialog_warn("remote client to local grpc_server disconnected...");
                                } else {
                                    // gaialog_warn("remote client to local grpc_server unknown cmd:{}...", idx);
                                }
                                continue;
                            }

                            if (idx == m_recv_idx + 1) {
                                content_temp = content_temp.substr(sizeof(int32_t));
                                m_recv_idx = idx;
                            } else if (idx < m_recv_idx + 1) {
                                // gaialog_warn("receive a repeated data:{}/{}, ignore...", idx, m_recv_idx);
                                return Recv(taskid, content, need_resend);
                            } else {
                                // gaialog_error("receive a error data: require :{}, but get:{}", m_recv_idx + 1, idx);
                                return false;
                            }
                        }

                        content = std::move(content_temp);
                        if (m_net_debug) {
                            std::stringstream ss;
                            for (size_t j = 0; j < content.length(); j++) {
                                uint8_t* tmp_ptr = (uint8_t*)content.data();
                                ss << std::setw(2) << std::setfill('0') << (std::hex) << (unsigned int)tmp_ptr[j];
                            }
                            // gaialog_debug("exec Recv  net packet debug info {}", ss.str());
                        }
                        return true;
                    } else {
                        // gaialog_warn("channel taskid:{},partyid:{},to_partyid:{} Receive from redis wait for {}/{}", m_ref_channel.get_taskid(), m_partyid,
                                    //  m_to_partyid, i, m_redis_timeout);

                        if (m_recv_thread_status == (int)RecvThreadStatus::finished && !m_notack_queue.empty() && need_resend != nullptr) {
                            // gaialog_warn("need resend when recv, not ack size is {}", m_notack_queue.size());
                            *need_resend = true;
                            return false;
                        }
                    }

                } catch (const Error& e) {
                    // gaialog_warn("channel taskid:{},partyid:{},to_partyid:{} catch error {}", m_ref_channel.get_taskid(), m_partyid, m_to_partyid, e.what());
                    std::this_thread::sleep_for(std::chrono::seconds(1));
                }
            }
            // gaialog_error("channel taskid:{},partyid:{},to_partyid:{} Receive from redis timeout", m_ref_channel.get_taskid(), m_partyid, m_to_partyid);
            return false;
        } else {

            Metadata meta;
            meta.set_taskid(std::move(taskid));
            meta.set_frompartyid(std::to_string(m_to_partyid));
            meta.set_topartyid(std::to_string(m_partyid));
            meta.set_servicetype(TENSOR);
            //            meta.set_tasktype(PSI);
            Packet packet;
            ClientContext context;
            Status status = m_stub->pull(&context, meta, &packet);

            if (status.ok()) {
                if (packet.header().find()) {
                    content = std::move(*packet.mutable_body());
                    if (m_net_debug) {
                        std::stringstream ss;
                        for (size_t j = 0; j < content.length(); j++) {
                            uint8_t* tmp_ptr = (uint8_t*)content.data();
                            ss << std::setw(2) << std::setfill('0') << (std::hex) << (unsigned int)tmp_ptr[j];
                        }
                        // gaialog_debug("exec receive net packet debug info  {}", ss.str());
                    }
                    return true;
                } else {
                    throw "Recv from redis timeout";
                }
            } else {
                // gaialog_info("{}:{}", status.error_code(), status.error_message());
                throw "Recv from redis failed";
            }
        }
    }

    bool RpcClient::wait_flush(int max_msec, bool* need_resend) {
        int current_interval = 5;
        auto ts_begin = std::chrono::steady_clock::now();
        // wait 10ms 20ms 40ms.....
        for (;;) {
            auto lg = std::unique_lock(m_mtx);
            if (m_notack_queue.empty())
                return true;

            if (m_recv_thread_status == (int)RecvThreadStatus::finished) {
                if (m_notack_queue.empty()) {
                    return true;
                }
                // gaialog_warn("recv thread aleady quit...");
                if (need_resend) {
                    *need_resend = true;
                }
                break;
            }

            grpc_connectivity_state state = m_chl->GetState(false);
            if (state != GRPC_CHANNEL_READY) {
                // gaialog_warn("grpc channel state aleady changed : {}", state);
                if (need_resend) {
                    *need_resend = true;
                }
                break;
            }

            auto ts_now = std::chrono::steady_clock::now();

            auto d = std::chrono::duration_cast<std::chrono::milliseconds>(ts_now - ts_begin).count();

            if (d >= max_msec) {
                // gaialog_warn("wait_flush timeout... {}, {}/{}", m_notack_queue.size(), d, max_msec);
                break;
            }

            current_interval = current_interval * 2;
            if (d + current_interval > max_msec) {
                current_interval = max_msec - d;
            }

            // gaialog_info("wait_flush for size:{}, interval:{}, {}/{}", m_notack_queue.size(), current_interval, d, max_msec);
            lg.unlock();
            std::this_thread::sleep_for(std::chrono::milliseconds(current_interval));
        }
        // gaialog_warn("wait_flush for size:{} not confirmed", m_notack_queue.size());
        return false;
    }

    using ContinueStatus = RpcClient::ContinueStatus;

    ContinueStatus RpcClient::get_continue_status() {
        ContinueStatus tup;
        if (m_use_rpc_version >= (int)ServiceVersion::v2) {
            std::get<0>(tup).swap(m_notack_queue);
            std::get<1>(tup) = m_seq;
            std::get<2>(tup) = m_recv_idx;
            std::get<3>(tup) = m_use_rpc_version;
            std::get<4>(tup) = m_use_redis_data_version;
        } else {
            std::get<3>(tup) = m_use_rpc_version;
            std::get<4>(tup) = m_use_redis_data_version;
        }
        return tup;
    }

    bool RpcClient::set_continue_status(ContinueStatus& tup) {
        m_use_rpc_version = std::get<3>(tup);
        m_use_redis_data_version = std::get<4>(tup);

        if (m_use_rpc_version >= (int)ServiceVersion::v2) {
            m_notack_queue.swap(std::get<0>(tup));
            m_seq = std::get<1>(tup);
            m_recv_idx = std::get<2>(tup);

            init_sender();
            auto lk = std::unique_lock(m_mtx);
            for (auto& e : m_notack_queue) {
                bool ret = m_rw_sender->Write(e);
                if (!ret) {
                    // gaialog_warn("set_continue_status send error");
                    return false;
                }
            }
        }

        return true;
    }

    void RpcClient::finish() {
        Status status;

        if (m_use_rpc_version == (int)ServiceVersion::not_inited) {
            // do nothing
        } else if (m_use_rpc_version == (int)ServiceVersion::v1) {
            m_sender->WritesDone();
            status = m_sender->Finish();
        } else if (m_use_rpc_version == (int)ServiceVersion::v2) {
            m_rw_sender->WritesDone();
            status = m_rw_sender->Finish();
            if (m_recv_thread_status != (int)RecvThreadStatus::not_inited) {
                m_recv_thread.join();
            }
        } else {
            // gaialog_assert_msg(false, "never come to here");
        }

        if (m_use_redis) {
            try {
                // std::string key(fmt::format("net_usage_{}_{}_{}", m_ref_channel.get_taskid(), m_partyid, m_to_partyid));

                std::string key = "net_usage_" +  m_ref_channel.get_taskid() + "_" + 
                                m_partyid + "_" + 
                                m_to_partyid;
                redis_client->hset(key, {std::make_pair("recv_bytes", std::to_string(m_ref_channel.get_bytes_recv())),
                                         std::make_pair("recv_packet", std::to_string(m_ref_channel.get_packet_recv())),
                                         std::make_pair("send_bytes", std::to_string(m_ref_channel.get_bytes_send())),
                                         std::make_pair("send_packet", std::to_string(m_ref_channel.get_packet_send()))});
                redis_client->expire(key, 3600 * 24 * 7);

                // for cube notify
                if (auto iter = m_ref_channel.get_meta().find("net_usage_redis_key"); iter != m_ref_channel.get_meta().end()) {

                    if (auto it = m_ref_channel.get_meta().find("mesh-urn"); it != m_ref_channel.get_meta().end()) {
                        redis_client->hset(key, std::make_pair(it->first, it->second));
                    }

                    std::string notify_key = iter->second;
                    redis_client->lpush(notify_key, key);
                    redis_client->expire(notify_key, 3600 * 24 * 7);
                }
            } catch (const Error& e) {
                // gaialog_warn("get a redis error:{}", e.what());
            }
        }

        if (status.ok()) {
            m_ref_channel.statistics_output();
            // gaialog_debug("taskid:{},partyid:{},to_partyid:{} channel waiting for shutdown", m_ref_channel.get_taskid(), m_partyid, m_to_partyid);
            m_chl->WaitForStateChange(GRPC_CHANNEL_SHUTDOWN, std::chrono::system_clock::now() + std::chrono::milliseconds(10000));
            // gaialog_debug("taskid:{},partyid:{},to_partyid:{} channel shutdown", m_ref_channel.get_taskid(), m_partyid, m_to_partyid);

        } else {
            // gaialog_warn("RpcClient finish with status: err code {}, err str:{}, err_detail:{}", status.error_code(), status.error_message(),
                        //  status.error_details());
        }
    }
} // namespace gaianet
