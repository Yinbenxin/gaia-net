set -e
PROXY_BASE=https://github.91chi.fun//

test -f /usr/bin/wget || apt-get install -y wget

#test -d grpc || git clone --recurse-submodules -b v1.35.x --depth 1 --shallow-submodules https://github.com/grpc/grpc || (echo fetch grpc error; exit -1)
#test -d gflags || git clone -b master --depth 1 https://github.com/gflags/gflags || (echo fetch gflags error; exit -1)
#test -d glog || git clone -b v0.5.0 --depth 1 https://github.com/google/glog || (echo fetch glog error; exit -1)
test -d hiredis || git clone -b v1.1.0 --depth 1 ${PROXY_BASE}https://github.com/redis/hiredis.git
test -d redis-plus-plus || git clone -b 1.3.3 --depth 1 ${PROXY_BASE}https://github.com/sewenew/redis-plus-plus.git
#test -d gperftools || git clone -b gperftools-2.9.1 --depth 1 https://github.com/gperftools/gperftools|| (echo fetch gperftools error; exit -1)
#test -d lz4 || git clone -b v1.9.3 --depth 1 https://github.com/lz4/lz4|| (echo fetch lz4 error; exit -1)
#test -d pybind11 || git clone -b v2.9.2 --depth 1 https://github.com/pybind/pybind11|| (echo fetch pybind11 error; exit -1)

test -d relic || git clone ${PROXY_BASE}https://github.com/relic-toolkit/relic.git && (cd relic && git checkout c25edf6)
#test -d bitpolymul || git clone ${PROXY_BASE}https://github.com/ladnir/bitpolymul.git && (cd bitpolymul && git checkout 4e3bca53cf3bacc1bdd07a0901cfde8c460f7a54)
test -d span-lite || git clone ${PROXY_BASE}https://github.com/martinmoene/span-lite.git && (cd span-lite && git checkout 2987dd8d3b8fe7c861e3c3f879234cc1c412f03f)
test -f torch-1.11.0-cp38-cp38-manylinux2014_aarch64.whl || wget https://download.pytorch.org/whl/torch-1.11.0-cp38-cp38-manylinux2014_aarch64.whl || (echo fetch torch error; exit -1)