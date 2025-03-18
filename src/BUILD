load("@rules_proto//proto:defs.bzl", "proto_library")
load("@rules_cc//cc:defs.bzl", "cc_library", "cc_proto_library")

proto_library(
    name = "gaia_proto",
    srcs = glob(["protos/*.proto"]),
    visibility = ["//visibility:public"],
)

cc_proto_library(
    name = "gaia_cc_proto",
    deps = [":gaia_proto"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "gaianet",
    srcs = glob([
        "*.cpp",
        "*.h",
        "gaia_utils/*.h",
    ]),
    hdrs = glob([
        "*.h",
        "gaia_utils/*.h",
    ]),
    deps = [
        ":gaia_cc_proto",
        "@com_github_grpc_grpc//:grpc++",
        "@redis_plus_plus//:redis++",
        "@lz4//:lz4",
        "@gflags//:gflags",
        "@com_github_fmtlib_fmt//:fmt",
    ],
    includes = ["src"],
    copts = ["-std=c++17"],
    visibility = ["//visibility:public"],
)