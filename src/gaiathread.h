
#ifndef __GAIA_THREAD_H
#define __GAIA_THREAD_H

#include <condition_variable>
#include <mutex>
#include <thread>
//#include "GLogHelper.h"

namespace gaianet {

class CThread {
  public:
    CThread();

    virtual ~CThread();

    bool Start();

    bool Wait();

    bool IsRunning() const;

  protected:
    virtual void ThreadMain() = 0;

    bool m_bRunning;
    std::thread thread_;
};

class CLock {
  public:
    CLock() = default;

    ~CLock() = default;

    void Lock();

    void Unlock();

    // make CLock `BasicLockable`
    void lock();

    void unlock();

  private:
    std::mutex mutex_;
};

class CEvent {
  public:
    CEvent(bool bManualReset = false, bool bInitialSet = false);

    ~CEvent() = default;

    bool Set();

    bool Wait();

    bool IsSet() const;

    bool Reset();

  private:
    std::condition_variable cv_;
    mutable std::mutex mutex_;
    bool m_bManual;
    bool m_bSet;
};
} 

#endif //__GAIA_THREAD_H
