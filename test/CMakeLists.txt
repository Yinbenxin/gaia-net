cmake_minimum_required(VERSION 3.10)
project(net_test)

# 设置输出目录
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
find_package(GTest REQUIRED)
find_package(PkgConfig REQUIRED)
find_package(gflags REQUIRED)
find_package(ZLIB REQUIRED)
find_package(fmt REQUIRED)

pkg_check_modules(LZ4 REQUIRED liblz4)

include_directories(
    ${CMAKE_SOURCE_DIR}/../src
    ${PKG_INCLUDE_DIRS}
)

add_executable(channel_bench channel_bench.cpp)
target_link_libraries(channel_bench ${TARGET_NAME} 
                        GTest::GTest 
                        ZLIB::ZLIB
                        GTest::Main 
                        ${PKG_LIBRARIES} 
                        gflags
                        fmt::fmt)

#  设置RPATH
# set_redis_test  redis_test.cpp)PRTIES
#     BUILD_WITHredis_testH TRUE
#     INST                    R}/../lib;${GR                    STALL_RPATH