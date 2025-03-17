load("@rules_cc//cc:defs.bzl", "cc_library")

cc_library(
    name = "grpc++",
    srcs = glob([
        "src/core/**/*.cc",
        "src/cpp/**/*.cc",
    ]),
    hdrs = glob([
        "include/**/*.h",
        "src/core/**/*.h",
        "src/cpp/**/*.h",
    ]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    copts = [
        "-std=c++17",
        "-DGRPC_BAZEL_BUILD",
    ],
    deps = [
        "@com_google_protobuf//:protobuf",
        "@boringssl//:ssl",
    ],
)