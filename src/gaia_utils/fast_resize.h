#ifndef SRC_GAIA_UTILS_FAST_RESIZE_H__
#define SRC_GAIA_UTILS_FAST_RESIZE_H__
#pragma once

#include "extern/folly/memory/UninitializedMemoryHacks.h"

namespace gaia_utils {
    namespace detail {
        namespace traits {

            template <typename T> struct is_vector : std::false_type {};

            template <typename T> struct is_vector<std::vector<T>> : std::true_type {};

            template <typename T> struct is_string : std::is_same<std::string, T> {};

            template <typename T> struct is_vector_or_string : std::disjunction<is_string<T>, is_vector<T>> {};
        } // namespace traits

        template <typename T> inline constexpr bool is_vector_or_string_v = traits::is_vector_or_string<T>::value;

        template <typename T> inline constexpr bool is_non_const_v = !std::is_const<typename std::remove_reference<T>::type>::value;

    } // namespace detail

    template <typename T> inline void fast_resize(T& vector_or_string, std::size_t n) {

        static_assert(detail::is_non_const_v<T>, "only work for non-const ref...");

        static_assert(detail::is_vector_or_string_v<T>, "only work for std::vector<T> or std::string!!!");

        folly::resizeWithoutInitialization(vector_or_string, n);
    }
} // namespace gaia_utils

#ifndef GAIA_FAST_RESIZE_VECTOR_TYPE
#define GAIA_FAST_RESIZE_VECTOR_TYPE FOLLY_DECLARE_VECTOR_RESIZE_WITHOUT_INIT
#endif

#endif
