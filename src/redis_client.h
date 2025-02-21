//
// Created by imayuxiang on 12/20/23.
//

#ifndef GAIA_NET_REDIS_CLIENT_H
#define GAIA_NET_REDIS_CLIENT_H

// #include "// gaialog.h"
#include <sw/redis++/redis++.h>
#include <nlohmann/json.hpp>

using namespace sw::redis;
namespace gaianet {
    class RedisClient {
    public:
        RedisClient(std::string redis_address);
        ~RedisClient();
        std::string ping();
        OptionalStringPair brpop(const StringView &key, long long timeout);

        bool hset(const StringView &key, const StringView &field, const StringView &val);
        template <typename T>
        long long hset(const StringView &key, std::initializer_list<T> il) {
            return hset(key, il.begin(), il.end());
        }
        template <typename Input>
        auto hset(const StringView &key, Input first, Input last)
        -> typename std::enable_if<!std::is_convertible<Input, StringView>::value, long long>::type{
            if (m_use_cluster) {
                return redis_cluster->hset<Input>(key, first, last);

            } else {
                return redis->hset<Input>(key, first, last);
            }
        }

        bool hset(const StringView &key, const std::pair<StringView, StringView> &item);

        bool expire(const StringView &key, long long timeout);
        long long lpush(const StringView &key, const StringView &val);
    private:
        Redis * redis;
        RedisCluster * redis_cluster;
        bool m_use_cluster;
        bool m_use_sentinel;
        bool use_url;
    };

}


#endif //GAIA_NET_REDIS_CLIENT_H
