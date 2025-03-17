load("@rules_cc//cc:defs.bzl", "cc_test")

cc_test(
    name = "channel_bench",
    srcs = ["channel_bench.cpp"],
    deps = [
        "//:gaianet",
        "@com_google_googletest//:gtest_main",
        "@com_github_gflags_gflags//:gflags",
    ],
)

cc_test(
    name = "channel_test",
    srcs = ["channel_test.cpp"],
    deps = [
        "//:gaianet",
        "@com_google_googletest//:gtest_main",
    ],
)

cc_test(
    name = "channel_echo",
    srcs = ["channel_echo.cpp"],
    deps = [
        "//:gaianet",
        "@com_google_googletest//:gtest_main",
    ],
)

cc_test(
    name = "connect_test",
    srcs = ["connect_test.cpp"],
    deps = [
        "//:gaianet",
        "@com_google_googletest//:gtest_main",
    ],
)

cc_test(
    name = "redis_test",
    srcs = ["redis_test.cc"],
    deps = [
        "//:gaianet",
        "@com_google_googletest//:gtest_main",
    ],
)

cc_test(
    name = "test_grpc_memleak",
    srcs = ["test_grpc_memleak.cpp"],
    deps = [
        "//:gaianet",
        "@com_google_googletest//:gtest_main",
    ],
)

cc_test(
    name = "util_test",
    srcs = ["util_test.cc"],
    deps = [
        "//:gaianet",
        "@com_google_googletest//:gtest_main",
    ],
)