#!/bin/bash
set -e
#(cd grpc && mkdir -p cmake/build && cd cmake/build && cmake -DgRPC_INSTALL=ON -DgRPC_BUILD_TESTS=OFF -DBUILD_SHARED_LIBS=ON -DgRPC_SSL_PROVIDER=package ../.. && make -j4  && make install) || (echo "build grpc failed"; exit -1)
# cp -r /usr/local/include/grpc/impl/codegen/* /usr/local/include/grpc/impl/
#(cd gflags && mkdir build && cd build && cmake ../ -DCMAKE_POSITION_INDEPENDENT_CODE=ON && make && make install) || (echo "build gflags failed"; exit -1)

#(cd glog && mkdir build && cd build && cmake ../ -DCMAKE_POSITION_INDEPENDENT_CODE=ON && make && make install) || (echo "build glog failed"; exit -1)

(cd relic && cmake  -DMULTI=PTHREAD -DCMAKE_POSITION_INDEPENDENT_CODE=ON . && make -j8 && make install) || (echo "build relic failed"; exit -1)

(cd hiredis && cmake . -DCMAKE_POSITION_INDEPENDENT_CODE=ON &&  make && make install) || (echo "build hiredis failed"; exit -1)

(cd redis-plus-plus && mkdir build && cd build && cmake .. -DCMAKE_POSITION_INDEPENDENT_CODE=ON && make -j8 &&make install) || (echo "build relic-plus-plus failed"; exit -1)

#(cd gperftools && ./autogen.sh && ./configure && make -j && make install) || (echo "build gperftools failed"; exit -1)

#(cd lz4 && make && make install) || (echo "build lz4 failed"; exit -1)

#(cd pybind11 && mkdir build && cd build && cmake .. -DPYBIND11_TEST=OFF -DPYBIND11_NOPYTHON=ON -DCMAKE_POSITION_INDEPENDENT_CODE=ON &&  make && make install) || (echo "build pybind11 failed"; exit -1)

#(cd bitpolymul && mkdir build && cd build && cmake .. -DCMAKE_POSITION_INDEPENDENT_CODE=ON && make -j8 &&make install) || (echo "build bitpolymul failed"; exit -1)

(cd span-lite && mkdir build && cd build && cmake .. -DCMAKE_POSITION_INDEPENDENT_CODE=ON && make -j8 && make install) || (echo "build span-lite failed"; exit -1)