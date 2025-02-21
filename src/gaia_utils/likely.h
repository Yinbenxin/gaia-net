#ifndef SRC_GAIA_UTILS_LIKELY_H__
#define SRC_GAIA_UTILS_LIKELY_H__
#pragma once

#define gaia_likely(x) __builtin_expect(!!(x), 1)
#define gaia_unlikely(x) __builtin_expect(!!(x), 0)

#endif