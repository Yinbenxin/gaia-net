#include "gaiarandom.h"

#include <cstdlib>
#include <chrono>

// #include "// gaialog.h"
#define gaia_likely(x) __builtin_expect(!!(x), 1)
#define gaia_unlikely(x) __builtin_expect(!!(x), 0)

unsigned int gaiarandom::fast_seed() {
    uint64_t ns = std::chrono::duration_cast<std::chrono::nanoseconds>(std::chrono::system_clock::now().time_since_epoch()).count();
    return (unsigned int)ns;
}

int gaiarandom::fast_rand(unsigned int* seed) {
    return rand_r(seed);
}

int gaiarandom::safe_rand() {

    static thread_local bool seed_inited = false;
    static thread_local unsigned int seed;

    if (gaia_unlikely(!seed_inited)) {
        seed_inited = true;
        seed = fast_seed();
    }

    return rand_r(&seed);
}
