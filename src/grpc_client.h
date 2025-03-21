#ifndef GRPC_CLIENT_H_
#define GRPC_CLIENT_H_
#include <chrono>
#include <grpcpp/grpcpp.h>
#include <iostream>
#include <memory>
#include <random>
#include <string>
#include <thread>

// #include "// gaialog.h"
#include "redis_client.h"
#include "src/protos/gaia_proxy.grpc.pb.h"

#include "channel.h"
#include <condition_variable>
#include <deque>
#include <iomanip>
#include <mutex>
#include <sstream>

using grpc::Channel;
using grpc::ClientContext;
using grpc::Status;

using grpc::ClientReader;
using grpc::ClientReaderWriter;
using grpc::ClientWriter;

using VersionRequest = com::be::cube::core::networking::proxy::VersionRequest;
using VersionResponse = com::be::cube::core::networking::proxy::VersionResponse;
using namespace com::be::cube::core::networking::proxy;
using std::chrono::system_clock;


namespace gaianet {

    class RpcClient {
      public:
        RpcClient(const channel& ch, std::shared_ptr<Channel> channel, uint32_t partyid, uint32_t to_party_id, std::string redis_address,
                  bool use_redis = false, bool net_debug = false);

        ~RpcClient();

        void init_sender();
        void init_rpc_version();
        void init_redis_data_version(std::string&);

        // Assembles the client's payload, sends it and presents the response back
        // from the server.
        bool Send(const std::string& taskid, std::string& content);

        bool Recv(const std::string& taskid, std::string& content, bool* need_resend = nullptr);

        typedef std::tuple<std::deque<Packet>, int, int, int, int> ContinueStatus;

        bool flushed() const {
            return m_notack_queue.empty();
        }

        bool wait_flush(int max_msec, bool* need_resend = nullptr);

        ContinueStatus get_continue_status();

        bool set_continue_status(ContinueStatus& tup);

        void finish();

        uint32_t partyid() const {
            return m_partyid;
        }

      private:
        const channel& m_ref_channel;
        const uint32_t m_partyid;
        const uint32_t m_to_partyid;
        const bool m_use_redis;
        const bool m_net_debug;
        std::unique_ptr<DataTransferService::Stub> m_stub;
        ClientContext m_context;
        ServerSummary m_stats;
        std::unique_ptr<ClientWriter<Packet>> m_sender;
        RedisClient* redis_client;
        int m_redis_timeout;
        std::shared_ptr<grpc::Channel> m_chl;

        // from v2
        std::unique_ptr<ClientReaderWriter<Packet, Packet>> m_rw_sender;
        int m_use_rpc_version;
        int m_use_redis_data_version;
        int m_seq;
        int m_recv_idx;

        std::deque<Packet> m_notack_queue;
        std::mutex m_mtx;
        std::condition_variable m_cv;

        std::thread m_recv_thread;
        int m_recv_thread_status;
    };

} // namespace gaianet
#endif
