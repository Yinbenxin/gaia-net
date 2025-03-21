load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library", "cc_proto_library")
load("@rules_proto//proto:defs.bzl", "proto_library")
load("@com_github_grpc_grpc//bazel:cc_grpc_library.bzl", "cc_grpc_library")

package(default_visibility = ["//visibility:public"])

proto_library(
    name = "gaia_proto",
    srcs = glob(["protos/*.proto"]),
    deps = [
        "@com_google_protobuf//:any_proto",
        "@com_google_protobuf//:empty_proto",
    ],
)

cc_proto_library(
    name = "gaia_cc_proto",
    deps = [":gaia_proto"],
)

cc_grpc_library(
    name = "gaia_cc_grpc",
    srcs = [":gaia_proto"],
    grpc_only = True,
    deps = [":gaia_cc_proto"],
)

cc_library(
    name = "gaia_net",
    srcs = glob([
        "*.cpp",
    ]),
    hdrs = glob([
        "*.h",
        "gaia_utils/*.h",
        "gaia_utils/extern/**/*.h",
    ]),
    deps = [
        ":gaia_cc_grpc",
        "@com_github_fmtlib_fmt//:fmtlib",  
        "@com_github_gflags_gflags//:gflags",
        "@com_github_lz4//:lz4",
        "@com_github_hiredis//:hiredis",
        "@com_github_redis_plus_plus//:redis_plus_plus",
        "@com_github_nlohmann_json//:json",
        "@com_google_protobuf//:protoc_lib",
        "@com_google_protobuf//:protobuf",
        "@com_github_grpc_grpc//:grpc",
        "@com_github_grpc_grpc//:grpc++",
        "@com_google_googletest//:gtest_main",
    ],
    copts = [
        "-I.",
        "-I$(GENDIR)/src",
        "-I$(GENDIR)/external/com_google_protobuf/src",
    ],
    strip_include_prefix = ".",

)