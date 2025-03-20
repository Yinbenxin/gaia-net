load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def gaia_net_deps():
    _bazel_features_version()
    _rules_foreign_cc()
    _com_google_googletest()
    _com_github_gflags_gflags()
    _com_github_nlohmann_json()
    _build_bazel_apple_support()
    _build_bazel_rules_apple()
    _io_bazel_rules_go()
    _rules_cc()
    _rule_proto()
    _rule_python()
    _com_google_protobuf()
    _com_github_grpc_grpc()
    _bazel_gazelle()
    _com_google_googleapis()
    _com_github_fmtlib_fmt()
    _com_github_lz4()
    _com_github_hiredis()
    _com_github_redis_plus_plus()
def _bazel_features_version():
    maybe(
        http_archive,
        name = "bazel_features",
        sha256 = "091d8b1e1f0bf1f7bd688b95007687e862cc489f8d9bc21c14be5fd032a8362f",
        strip_prefix = "bazel_features-1.26.0",
        type = "tar.gz",
        url = "https://github.com/bazel-contrib/bazel_features/releases/download/v1.26.0/bazel_features-v1.26.0.tar.gz"
    )

def _rules_foreign_cc():
    maybe(
        http_archive,
        name = "rules_foreign_cc",
        sha256 = "b3127e65fc189f28833be0cf64ba8b33b0bbb2707b7d448ba3baba5247a3c9f8",
        strip_prefix = "rules_foreign_cc-5c34b7136f0dec5d8abf2b840796ec8aef56a7c1",
        type = "tar.gz",
        urls = [
            "https://github.com/bazelbuild/rules_foreign_cc/archive/5c34b7136f0dec5d8abf2b840796ec8aef56a7c1.tar.gz",
        ],
    )

def _com_google_googletest():
    maybe(
        http_archive,
        name = "com_google_googletest",
        sha256 = "7b42b4d6ed48810c5362c265a17faebe90dc2373c885e5216439d37927f02926",
        type = "tar.gz",
        strip_prefix = "googletest-1.15.2",
        urls = [
            "https://github.com/google/googletest/archive/refs/tags/v1.15.2.tar.gz",
        ],
    )

def _com_github_gflags_gflags():
    maybe(
        http_archive,
        name = "com_github_gflags_gflags",
        sha256 = "34af2f15cf7367513b352bdcd2493ab14ce43692d2dcd9dfc499492966c64dcf",
        strip_prefix = "gflags-2.2.2",
        type = "tar.gz",
        urls = [
            "https://github.com/gflags/gflags/archive/v2.2.2.tar.gz",
        ],
    )

def _com_github_nlohmann_json():
    maybe(
        http_archive,
        name = "com_github_nlohmann_json",
        sha256 = "0d8ef5af7f9794e3263480193c491549b2ba6cc74bb018906202ada498a79406",
        strip_prefix = "json-3.11.3",
        type = "tar.gz",
        urls = [
            "https://github.com/nlohmann/json/archive/refs/tags/v3.11.3.tar.gz",
        ],
    )

def _build_bazel_apple_support():
    maybe(
        http_archive,
        name = "build_bazel_apple_support",
        sha256 = "cfc295c5acb751fc3299425a1852e421ec0a560cdd97b6a7426d35a1271c2df5",
        strip_prefix = "apple_support-1.17.1",
        type = "tar.gz",
        urls = [
            "https://github.com/bazelbuild/apple_support/archive/refs/tags/1.17.1.tar.gz",
        ],
    )

def _build_bazel_rules_apple():
    maybe(
        http_archive,
        name = "build_bazel_rules_apple",
        sha256 = "0ddf84813268ef73039335e7a53d0c838049a441927ef5c071f350ab8faa5494",
        strip_prefix = "rules_apple-3.9.2",
        type = "tar.gz",
        urls = [
            "https://github.com/bazelbuild/rules_apple/archive/refs/tags/3.9.2.tar.gz",
        ],
    )

def _io_bazel_rules_go():
    maybe(
        http_archive,
        name = "io_bazel_rules_go",
        sha256 = "b8e1e0cd332c5861b58f9d5200fcb755c68bbb1473bdcf44f5edd20f9678fe1d",
        strip_prefix = "rules_go-0.50.1",
        type = "tar.gz",
        urls = [
            "https://github.com/bazelbuild/rules_go/archive/v0.50.1.tar.gz",
        ],
    )

def _rules_cc():
    maybe(
        http_archive,
        name = "rules_cc",
        sha256 = "2037875b9a4456dce4a79d112a8ae885bbc4aad968e6587dca6e64f3a0900cdf",
        strip_prefix = "rules_cc-0.0.9",
        type = "tar.gz",
        urls = [
            "https://github.com/bazelbuild/rules_cc/releases/download/0.0.9/rules_cc-0.0.9.tar.gz",
        ],
    )

def _rule_proto():
    maybe(
        http_archive,
        name = "rules_proto",
        strip_prefix = "rules_proto-6.0.0-rc2",
        type = "tar.gz",
        sha256 = "71fdbed00a0709521ad212058c60d13997b922a5d01dbfd997f0d57d689e7b67",
        urls = [
            "https://github.com/bazelbuild/rules_proto/archive/refs/tags/6.0.0-rc2.tar.gz",
        ],
    )

def _rule_python():
    maybe(
        http_archive,
        name = "rules_python",
        sha256 ="ca77768989a7f311186a29747e3e95c936a41dffac779aff6b443db22290d913",
        strip_prefix = "rules_python-0.36.0",
        type = "tar.gz",
        urls = [
            "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.36.0.tar.gz",
        ],
    )

def _com_google_protobuf():
    maybe(
        http_archive,
        name = "com_google_protobuf",
        sha256 = "b2340aa47faf7ef10a0328190319d3f3bee1b24f426d4ce8f4253b6f27ce16db",
        strip_prefix = "protobuf-28.2",
        type = "tar.gz",
        urls = [
            "https://github.com/protocolbuffers/protobuf/archive/refs/tags/v28.2.tar.gz",
        ],
    )



def _com_github_grpc_grpc():
    maybe(
        http_archive,
        name = "com_github_grpc_grpc",
        sha256 ="eacf07e6354b6a30056b0338027b20c7f5a1da556a674d108cea1b8938d7abec",
        strip_prefix = "grpc-1.66.0",
        type = "tar.gz",
        urls = [
            "https://github.com/grpc/grpc/archive/refs/tags/v1.66.0.tar.gz",
        ],
    )

def _bazel_gazelle():
    maybe(
        http_archive,
        name = "bazel_gazelle",
        sha256 = "dcdab026e60076db9da79c8063c184766e95146b19dca63be21cfab9c222760c",
        strip_prefix = "bazel-gazelle-0.39.1",
        type = "tar.gz",
        urls = [
            "https://github.com/bazel-contrib/bazel-gazelle/archive/refs/tags/v0.39.1.tar.gz",
        ],
    )

def _com_google_googleapis():
    maybe(
        http_archive,
        name = "com_google_googleapis",
        sha256 = "0513f0f40af63bd05dc789cacc334ab6cec27cc89db596557cb2dfe8919463e4",
        strip_prefix = "googleapis-fe8ba054ad4f7eca946c2d14a63c3f07c0b586a0",
        type = "tar.gz",
        urls = [
            "https://github.com/googleapis/googleapis/archive/fe8ba054a.tar.gz",
        ],
    )

def _com_github_fmtlib_fmt():
    maybe(
        http_archive,
        name = "com_github_fmtlib_fmt",
        sha256 = "1cafc80701b746085dddf41bd9193e6d35089e1c6ec1940e037fcb9c98f62365",
        strip_prefix = "fmt-6.1.2",
        build_file = "@gaia_net//bazel:fmtlib.BUILD",
        type = "tar.gz",
        urls = [
            "https://github.com/fmtlib/fmt/archive/refs/tags/6.1.2.tar.gz",
        ],
    )

def _com_github_lz4():
    maybe(
        http_archive,
        name = "com_github_lz4",
        sha256 = "030644df4611007ff7dc962d981f390361e6c97a34e5cbc393ddfbe019ffe2c1",
        strip_prefix = "lz4-1.9.3",
        build_file = "@gaia_net//bazel:lz4.BUILD",
        type = "tar.gz",
        urls = [
            "https://github.com/lz4/lz4/archive/refs/tags/v1.9.3.tar.gz",
        ],
    )

def _com_github_hiredis():
    maybe(
        http_archive,
        name = "com_github_hiredis",
        sha256 ="82ad632d31ee05da13b537c124f819eb88e18851d9cb0c30ae0552084811588c",
        strip_prefix = "hiredis-1.2.0",
        build_file = "@gaia_net//bazel:hiredis.BUILD",
        type = "tar.gz",
        urls = [
            "https://github.com/redis/hiredis/archive/refs/tags/v1.2.0.tar.gz",
        ],
    )

def _com_github_redis_plus_plus():
    maybe(
        http_archive,
        name = "com_github_redis_plus_plus",
        sha256 = "678a61898ed72f0c692102c7ce103a1bcae1e6ff85a4ad03e6002c1ba8fe1e08",
        strip_prefix = "redis-plus-plus-1.3.13",
        build_file = "@gaia_net//bazel:redis_plus_plus.BUILD",
        type = "tar.gz",
        urls = [
            "https://github.com/sewenew/redis-plus-plus/archive/refs/tags/1.3.13.tar.gz",
        ],
    )