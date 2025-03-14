cmake_minimum_required(VERSION 3.10)
project(gaianet VERSION 1.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 查找pkg-config依赖
find_package(PkgConfig REQUIRED)
pkg_check_modules(GRPC++ REQUIRED grpc++)
pkg_check_modules(PROTOBUF REQUIRED protobuf)
pkg_check_modules(REDIS++ REQUIRED redis++)
pkg_check_modules(LZ4 REQUIRED liblz4)

include_directories(${GRPC++_INCLUDE_DIRS} ${PROTOBUF_INCLUDE_DIRS} ${REDIS++_INCLUDE_DIRS} ${LZ4_INCLUDE_DIRS})

# 设置源文件和目标库名
set(TARGET_NAME gaianet)
set(SOURCES 
    src/redis_client.cpp
    src/grpc_client.cpp
    src/ichannel.cpp
    src/channel.cpp
    src/gaianet.cpp
    src/gaiahelper.cpp
    src/gaiarandom.cpp
    src/memchannel.cpp
    src/version.cpp
)

# 打印CMAKE_SOURCE_DIR
message(STATUS "CMAKE_SOURCE_DIR: ${CMAKE_SOURCE_DIR}")

message(STATUS "CMAKE_CURRENT_BINARY_DIR: ${CMAKE_CURRENT_BINARY_DIR}")


# 处理Protobuf文件
file(GLOB PROTO_FILES "${CMAKE_SOURCE_DIR}/src/protos/*.proto")
foreach(PROTO_FILE ${PROTO_FILES})
    get_filename_component(PROTO_NAME ${PROTO_FILE} NAME_WE)
    set(PROTO_CC "${CMAKE_CURRENT_BINARY_DIR}/src/protos/${PROTO_NAME}.pb.cc")
    set(PROTO_GRPC_CC "${CMAKE_CURRENT_BINARY_DIR}/src/protos/${PROTO_NAME}.grpc.pb.cc")
    
    add_custom_command(
        OUTPUT ${PROTO_CC} ${PROTO_GRPC_CC}
        COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/src/protos
        COMMAND protoc
        ARGS --grpc_out=${CMAKE_CURRENT_BINARY_DIR}/src/protos
             --cpp_out=${CMAKE_CURRENT_BINARY_DIR}/src/protos
             -I ${CMAKE_CURRENT_SOURCE_DIR}/src/protos
             --plugin=protoc-gen-grpc=`which grpc_cpp_plugin`
             ${PROTO_FILE}
        DEPENDS ${PROTO_FILE}
        COMMENT "Generating Protobuf files for ${PROTO_NAME}"
    )
    
    list(APPEND GENERATED_PB_SRC ${PROTO_CC} ${PROTO_GRPC_CC})
endforeach()

include_directories(${CMAKE_CURRENT_BINARY_DIR}/src/protos)

# 添加Protobuf生成的源文件
list(APPEND SOURCES ${GENERATED_PB_SRC})

# 检查操作系统并添加特定库
if(APPLE)
    find_package(spdlog REQUIRED)
    include_directories(${spdlog_INCLUDE_DIRS})
endif()

if(UNIX AND NOT APPLE)
    list(APPEND LIBS rt)
endif()

# 链接gRPC库
link_directories(${GRPC++_LIBRARY_DIRS})
add_library(${TARGET_NAME}  ${SOURCES})
target_link_libraries(${TARGET_NAME} 
    ${GRPC++_LIBRARIES} 
    ${PROTOBUF_LIBRARIES} 
    ${REDIS++_LIBRARIES} 
    ${LZ4_LIBRARIES} 
    pthread 
    dl 
    ${LIBS}
)

install(TARGETS ${TARGET_NAME} DESTINATION lib)
install(DIRECTORY src/ DESTINATION include FILES_MATCHING PATTERN "*.h")
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/src/protos/ DESTINATION include/protos FILES_MATCHING PATTERN "*.h")

# 清理规则
add_custom_target(clean-all
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_CURRENT_BINARY_DIR}/src/protos/
    COMMENT "Cleaning all generated files"
)

add_subdirectory(test)