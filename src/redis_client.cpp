//
// Created by imayuxiang on 12/20/23.
//

#include "redis_client.h"
#include <nlohmann/json.hpp>

namespace gaianet {
    RedisClient::RedisClient(std::string redis_address){
        m_use_sentinel = false;
        m_use_cluster = false;
        auto cluster_mode = getenv("CPP_REDIS_CLUSTER_MODE");
        auto use_three_factors = getenv("CPP_REDIS_USE_THREE_FACTORS");
        if (cluster_mode && !strcmp(cluster_mode, "cluster")) {
            m_use_cluster = true;
        }
        if (use_three_factors) {
            if (m_use_cluster){
            	ConnectionOptions connection_options;
                auto host = getenv("CPP_REDIS_CLUSTER_HOST");
                auto password = getenv("CPP_REDIS_CLUSTER_PASSWORD");
                auto port = getenv("CPP_REDIS_CLUSTER_PORT");

                if (host) {
                    // gaialog_info("use  redis_cluster host  {} from env value", host);
                } else {
                    // gaialog_error("get redis_cluster host from env value failed");
                }
                if (port) {
                    // gaialog_info("use  redis_cluster port  {} from env value", port);
                } else {
                    // gaialog_error("get redis_cluster port from env value failed");
                }

                if (password) {
                    // gaialog_info("use  redis_cluster password  from env value");
                } else {
                    // gaialog_warn("get redis_cluster password from env value failed");
                }

                connection_options.host = host;
                connection_options.port = std::atoi(port);
                if (password){
                    connection_options.password = password;
                }
                redis_cluster = new RedisCluster(connection_options);
            } else if (cluster_mode && !strcmp(cluster_mode, "sentinel")){
                m_use_sentinel = true;
                auto password = getenv("CPP_REDIS_CLUSTER_PASSWORD");
                auto sentinel_password = getenv("CPP_REDIS_SENTINEL_PASSWORD");
                auto master_name = getenv("CPP_REDIS_SENTINEL_MASTER");
                auto redis_nodes = getenv("CPP_REDIS_CLUSTER_NODES");
                if (redis_nodes){
                    // gaialog_info("use  redis_cluster redis_nodes {}  from env value", redis_nodes);
                } else {
                    // gaialog_error("get redis_cluster redis_nodes from env value failed");
                }
                std::vector<std::pair<std::string, int>> nodes;

                nlohmann::json jsonArray = nlohmann::json::parse(redis_nodes);
                for (const auto& element : jsonArray) {
                    std::string host = element["host"];
                    int port = element["port"];
                    nodes.push_back(std::make_pair(host, port));
                }

                SentinelOptions sentinel_opts;
                sentinel_opts.nodes = nodes;
		if (sentinel_password) {
                    // gaialog_info("use  redis_cluster sentinel_password  from env value");
                    sentinel_opts.password = sentinel_password;
                } else {
                    // gaialog_warn("get redis_cluster sentinel_password from env value failed");
                }

                auto sentinel = std::make_shared<Sentinel>(sentinel_opts);
                ConnectionOptions connection_opts;
                if (password) {
                    // gaialog_info("use  redis_cluster password  from env value");
                    connection_opts.password = password;  // Optional. No password by default.
                } else {
                    // gaialog_warn("get redis_cluster password from env value failed");
                }

                if (master_name) {
                    // gaialog_info("use  redis_cluster master_name {} from env value", master_name);
                } else {
                    // gaialog_warn("get redis_cluster master_name s from env value failed");
                }

                connection_opts.connect_timeout = std::chrono::milliseconds(100);   // Required.
                connection_opts.socket_timeout = std::chrono::milliseconds(100);    // Required.
                redis = new Redis(sentinel, master_name, Role::MASTER, connection_opts);

            } else {
            	ConnectionOptions connection_options;
                auto host = getenv("CPP_REDIS_HOST");
                auto password = getenv("CPP_REDIS_PASSWORD");
                auto port = getenv("CPP_REDIS_PORT");

                if (host) {
                    // gaialog_info("use  redis host  {} from env value", host);
                } else {
                    // gaialog_error("get redis host from env value failed");
                }
                if (port) {
                    // gaialog_info("use  redis port  {} from env value", port);
                } else {
                    // gaialog_error("get redis port from env value failed");
                }

                if (password) {
                    // gaialog_info("use  redis password  from env value");
                } else {
                    // gaialog_warn("get redis password from env value failed");
                }

                connection_options.host = host;
                connection_options.port = std::atoi(port);
                if (password) {
                    connection_options.password = password;
                }
                redis = new Redis(connection_options);
            }
        } else {
            if (m_use_cluster){
                redis_cluster = new RedisCluster(redis_address);
            } else {
                redis = new Redis(redis_address);
            }
        }
    }
    RedisClient::~RedisClient(){
        if (m_use_cluster){
            delete redis_cluster;
        } else {
            delete redis;
        }
    }
    std::string RedisClient::ping(){
        if (m_use_cluster or m_use_sentinel){
            return "cluster not support ping()";
        } else {
            return redis->ping();
        }
    }

    OptionalStringPair RedisClient::brpop(const StringView &key, long long timeout){
        if (m_use_cluster){
            return redis_cluster->brpop(key, timeout);
        }
        else {
            return redis->brpop(key, timeout);
        }
    }

    bool RedisClient::hset(const StringView &key, const StringView &field, const StringView &val){
        if (m_use_cluster){
            return redis_cluster->hset(key, field, val);
        } else {
            return redis->hset(key, field, val);
        }
    }

    bool RedisClient::hset(const StringView &key, const std::pair<StringView, StringView> &item) {
        if (m_use_cluster){
            return redis_cluster->hset(key, item.first, item.second);

        } else {
            return redis->hset(key, item.first, item.second);
        }
    }


    bool RedisClient::expire(const StringView &key, long long timeout){
        if (m_use_cluster){
            return redis_cluster->expire(key, timeout);
        }
        else {
            return redis->expire(key, timeout);
        }
    }

    long long RedisClient::lpush(const StringView &key, const StringView &val){
        if (m_use_cluster){
            return redis_cluster->lpush(key, val);

        } else {
            return redis->lpush(key, val);
        }
    }

}
