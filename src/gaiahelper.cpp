#include "gaiahelper.h"

#if defined(__APPLE__)
#include <pthread.h>
#elif defined(__linux__)
#include <sys/prctl.h>
#else
#error "not support platform"
#endif

void gaiahelper::set_thread_name(const std::string& name) {
#if defined(__APPLE__)
    pthread_setname_np(name.c_str());
#elif defined(__linux__)
    std::string tmp_name = name;
    tmp_name.resize(16);
    prctl(PR_SET_NAME, tmp_name.data());
#else

#endif
}