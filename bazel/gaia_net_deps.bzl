load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def gaia_net_deps():
    _rules_foreign_cc()
    _rule_python()
    _rules_cc()

    _bazel_platform()
    _upb()
    _com_google_absl()
    _com_github_openssl_openssl()
    _com_github_grpc_grpc()

    _com_github_nlohmann_json()
    _com_google_googletest()
    _com_github_gflags_gflags()
    _com_google_googleapis()
    _com_github_fmtlib_fmt()
    _com_github_lz4()
    _com_github_hiredis()
    _com_github_redis_plus_plus()

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


def _upb():
    maybe(
        http_archive,
        name = "upb",
        sha256 = "017a7e8e4e842d01dba5dc8aa316323eee080cd1b75986a7d1f94d87220e6502",
        strip_prefix = "upb-e4635f223e7d36dfbea3b722a4ca4807a7e882e2",
        urls = [
            "https://storage.googleapis.com/grpc-bazel-mirror/github.com/protocolbuffers/upb/archive/e4635f223e7d36dfbea3b722a4ca4807a7e882e2.tar.gz",
            "https://github.com/protocolbuffers/upb/archive/e4635f223e7d36dfbea3b722a4ca4807a7e882e2.tar.gz",
        ],
        patch_args = ["-p1"],
        patches = [
            "@gaia_net//bazel/patches:upb.patch",
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

def _bazel_platform():
    http_archive(
        name = "platforms",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/platforms/releases/download/0.0.8/platforms-0.0.8.tar.gz",
            "https://github.com/bazelbuild/platforms/releases/download/0.0.8/platforms-0.0.8.tar.gz",
        ],
        sha256 = "8150406605389ececb6da07cbcb509d5637a3ab9a24bc69b1101531367d89d74",
    )
def _com_google_absl():
    maybe(
        http_archive,
        name = "com_google_absl",
        sha256 = "f50e5ac311a81382da7fa75b97310e4b9006474f9560ac46f54a9967f07d4ae3",
        type = "tar.gz",
        strip_prefix = "abseil-cpp-20240722.0",
        urls = [
            "https://github.com/abseil/abseil-cpp/archive/refs/tags/20240722.0.tar.gz",
        ],
    )
def _com_github_openssl_openssl():
    maybe(
        http_archive,
        name = "com_github_openssl_openssl",
        sha256 = "bedbb16955555f99b1a7b1ba90fc97879eb41025081be359ecd6a9fcbdf1c8d2",
        type = "tar.gz",
        strip_prefix = "openssl-openssl-3.3.2",
        urls = [
            "https://github.com/openssl/openssl/archive/refs/tags/openssl-3.3.2.tar.gz",
        ],
        build_file = "@gaia_net//bazel:openssl.BUILD",
    )

def _com_github_grpc_grpc():
    maybe(
        http_archive,
        name = "com_github_grpc_grpc",
        sha256 = "7f42363711eb483a0501239fd5522467b31d8fe98d70d7867c6ca7b52440d828",
        strip_prefix = "grpc-1.51.0",
        type = "tar.gz",
        patch_args = ["-p1"],
        patches = ["@gaia_net//bazel/patches:grpc.patch"],
        urls = [
            "https://github.com/grpc/grpc/archive/refs/tags/v1.51.0.tar.gz",
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