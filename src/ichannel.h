#ifndef GAIA_NET_ICHANNEL_H__
#define GAIA_NET_ICHANNEL_H__
#pragma once

#include <cstdint>
#include <string>
#include <cassert>
// #include "// gaialog.h"

namespace gaianet {
    class IChannel {
      public:
        virtual void send(const void* buf, uint64_t nbytes) = 0;
        virtual void send(std::string& str) = 0;
        virtual void recv(std::string& str) = 0;
        virtual void recv(void* buf, uint64_t length) = 0;
        virtual bool flush() = 0;
        virtual ~IChannel() {
        }

        const std::string& get_channel_id() const {
            return m_channelid;
        }

        uint32_t get_from_party() const {
            return m_from_party;
        }

        uint32_t get_to_party() const {
            return m_to_party;
        }

        void statistics_send(std::size_t nbytes) {
            m_bytes_send += nbytes;
            m_packet_send++;
        }

        void statistics_recv(std::size_t nbytes) {
            m_bytes_recv += nbytes;
            m_packet_recv++;
        }

        void statistics_output() const;

        std::size_t get_bytes_send() const {
            return m_bytes_send;
        }

        std::size_t get_bytes_recv() const {
            return m_bytes_recv;
        }

        std::size_t get_packet_recv() const {
            return m_packet_recv;
        }

        std::size_t get_packet_send() const {
            return m_packet_send;
        }

      public:
        IChannel(const std::string& channelid, uint32_t from_party, uint32_t to_party)
            : m_channelid(channelid)
            , m_from_party(from_party)
            , m_to_party(to_party)
            , m_bytes_send(0)
            , m_bytes_recv(0)
            , m_packet_send(0)
            , m_packet_recv(0) {
        }

      private:
        std::string m_channelid;
        uint32_t m_from_party;
        uint32_t m_to_party;
        std::size_t m_bytes_send;
        std::size_t m_bytes_recv;
        std::size_t m_packet_send;
        std::size_t m_packet_recv;
    };
} // namespace gaianet

#endif