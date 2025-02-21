#ifndef __GAIA_RANDOM_H
#define __GAIA_RANDOM_H
class gaiarandom {
  public:
    // cost : 4.7 ns
    static unsigned int fast_seed();

    // cost : 7.8 ns
    static int fast_rand(unsigned int* seed);

    // cost : 21.1 ns
    static int safe_rand();
};
#endif