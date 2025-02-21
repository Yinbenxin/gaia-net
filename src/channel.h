
#ifndef CHANNEL_H_
#define CHANNEL_H_

#include <cstdint>
#include <map>
#include <string>
#include <cassert>
#include "ichannel.h"

#define CHANNEL_CONNECT_TIMEOUT 60000

namespace gaianet {
    using std::string;
    class RpcClient;

    class channel final : public IChannel {
      public:
        channel(const channel&) = delete;

        channel& operator=(const channel&) = delete;

        channel(channel&&)
            : IChannel("", 0, 0)
            , m_server_address()
            , m_redis_address()
            , m_connect_wait_time()
            , m_use_redis()
            , m_net_log_switch()
            , m_meta()

        {
            // disable move construct, just for compile
            std::abort();
        }

        channel(uint32_t from_party, uint32_t to_party, const string& taskid, const string& server_address, const string& redis_address,
                uint32_t connect_wait_time = CHANNEL_CONNECT_TIMEOUT * 1000, bool use_redis = true, bool net_log_switch = false,
                const std::map<std::string, std::string>& meta = std::map<std::string, std::string>());

        ~channel();

        void client_finish();

        virtual void send(const void* buf, uint64_t nbytes) override;

        virtual void send(std::string& str) override;

        void send_with_compress(const void* buf, uint64_t nbytes);

        void send_with_compress(const std::string& str);

        virtual void recv(std::string& str) override;

        virtual void recv(void* pbuf, uint64_t length) override;

        void recv_with_decompress(void* pbuf, uint64_t length);

        void recv_with_decompress(std::string& str);

        virtual bool flush() override;

        RpcClient* get_client() {
            return m_client;
        }

        const std::string& get_taskid() const {
            return get_channel_id();
        }

        const std::map<std::string, std::string>& get_meta() const {
            return m_meta;
        }

      private:
        void create_channel();
        void destroy_channel();
        void real_send(std::string& move_str);
        void real_recv(std::string& move_in_str);

      private:
        RpcClient* m_client;
        RpcClient* m_rcv_client;

        const string m_server_address;
        const string m_redis_address;
        const uint32_t m_connect_wait_time;
        const bool m_use_redis;
        const bool m_net_log_switch;
        const std::map<std::string, std::string> m_meta;
    };
} // namespace gaianet

#endif /* CHANNEL_H_ */
