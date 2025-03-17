workspace(name = "gaianet")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# gRPC
http_archive(
    name = "com_github_grpc_grpc",
    urls = ["https://github.com/grpc/grpc/archive/v1.54.0.tar.gz"],
    strip_prefix = "grpc-1.54.0",
)

load("@com_github_grpc_grpc//bazel:grpc_deps.bzl", "grpc_deps")
grpc_deps()

load("@com_github_grpc_grpc//bazel:grpc_extra_deps.bzl", "grpc_extra_deps")
grpc_extra_deps()

# Redis++
http_archive(
    name = "redis_plus_plus",
    urls = ["https://github.com/sewenew/redis-plus-plus/archive/refs/tags/1.3.14.tar.gz"],
    strip_prefix = "redis-plus-plus-1.3.14",
    build_file = "//bazel/redis-plus-plus.BUILD",
)

# Hiredis
http_archive(
    name = "hiredis",
    urls = ["https://github.com/redis/hiredis/archive/v1.1.0.tar.gz"],
    strip_prefix = "hiredis-1.1.0",
    build_file = "//bazel/hiredis.BUILD",
)

# fmt
http_archive(
    name = "fmt",
    urls = ["https://github.com/fmtlib/fmt/archive/8.1.1.tar.gz"],
    strip_prefix = "fmt-8.1.1",
    build_file = "//bazel/fmt.BUILD",
)

# lz4
http_archive(
    name = "lz4",
    urls = ["https://github.com/lz4/lz4/archive/v1.9.4.tar.gz"],
    strip_prefix = "lz4-1.9.4",
    build_file = "//bazel/lz4.BUILD",
)

# gflags
http_archive(
    name = "com_github_gflags_gflags",
    urls = ["https://github.com/gflags/gflags/archive/v2.2.2.tar.gz"],
    strip_prefix = "gflags-2.2.2",
)