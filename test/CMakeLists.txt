cmake_minimum_required(VERSION 3.10)
project(net_test)

# 设置输出目录
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
find_package(GTest REQUIRED)


include_directories(
    ${CMAKE_SOURCE_DIR}/../src
    ${PKG_INCLUDE_DIRS}
)

add_executable(channel_bench channel_bench.cpp)
target_link_libraries(channel_bench ${TARGET_NAME} 
                        GTest::GTest 
                        )
