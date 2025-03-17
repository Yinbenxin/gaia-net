cmake_minimum_required(VERSION 3.10)
project(net_test)

# 设置输出目录
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
find_package(GTest REQUIRED)


include_directories(
    ${CMAKE_SOURCE_DIR}/../src
)
link_directories(${CMAKE_BINARY_DIR})

#打印路径
message(STATUS "CMAKE_BINARY_DIR:: ${CMAKE_BINARY_DIR}")

add_executable(channel_bench channel_bench.cpp)
target_link_libraries(channel_bench gaianet
                        GTest::GTest 
                        gflags
                        )
