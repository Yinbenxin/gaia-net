# Copyright 2021 Ant Group Co., Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def yacl_deps():
    _bazel_features_version()
    _rules_foreign_cc()

    _com_google_googletest()
    _com_github_gflags_gflags()
    _com_github_fmtlib_fmt()
    _com_github_lz4()
    _com_github_hiredis()
    _com_github_redis_plus_plus()
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

def _rule_proto():
    maybe(
        http_archive,
        name = "rules_proto",
        strip_prefix = "rules_proto-6.0.0-rc2",
        urls = [
            "https://github.com/bazelbuild/rules_proto/archive/refs/tags/6.0.0-rc2.tar.gz",
        ],
    )
def _rule_python():
    maybe(
        http_archive,
        name = "rules_python",
        strip_prefix = "rules_python-0.36.0",
        urls = [
            "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.36.0.tar.gz",
        ],
    )
def _rules_foreign_cc():
    maybe(
        http_archive,
        name = "rules_foreign_cc",
        sha256 = "b3127e65fc189f28833be0cf64ba8b33b0bbb2707b7d448ba3baba5247a3c9f8",
        strip_prefix = "rules_foreign_cc-5c34b7136f0dec5d8abf2b840796ec8aef56a7c1",
        urls = [
            "https://github.com/bazelbuild/rules_foreign_cc/archive/5c34b7136f0dec5d8abf2b840796ec8aef56a7c1.tar.gz",
        ],
    )

def _com_github_fmtlib_fmt():
    maybe(
        http_archive,
        name = "com_github_fmtlib_fmt",
        strip_prefix = "fmt-6.1.2",
        build_file = "@yacl//bazel:fmtlib.BUILD",
        urls = [
            "https://github.com/fmtlib/fmt/archive/refs/tags/6.1.2.tar.gz",
        ],
    )

def _com_github_gflags_gflags():
    maybe(
        http_archive,
        name = "com_github_gflags_gflags",
        strip_prefix = "gflags-2.2.2",
        type = "tar.gz",
        urls = [
            "https://github.com/gflags/gflags/archive/v2.2.2.tar.gz",
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
def _com_github_lz4():
    maybe(
        http_archive,
        name = "com_github_lz4",
        strip_prefix = "lz4-1.9.3",
        build_file = "//bazel:lz4.BUILD",
        type = "tar.gz",
        urls = [
            "https://github.com/lz4/lz4/archive/refs/tags/v1.9.3.tar.gz",
        ],
    )

def _com_github_hiredis():
    maybe(
        http_archive,
        name = "com_github_hiredis",
        strip_prefix = "hiredis-1.2.0",
        build_file = "//bazel:hiredis.BUILD",
        type = "tar.gz",
        urls = [
            "https://github.com/redis/hiredis/archive/refs/tags/v1.2.0.tar.gz",
        ],
    )
def _com_github_redis_plus_plus():
    maybe(
        http_archive,
        name = "com_github_redis_plus_plus",
        strip_prefix = "redis-plus-plus-1.3.13",
        build_file = "//bazel:redis_plus_plus.BUILD",
        type = "tar.gz",
        urls = [
            "https://github.com/sewenew/redis-plus-plus/archive/refs/tags/1.3.13.tar.gz",
        ],
    )

def _com_google_protobuf():
    maybe(
        http_archive,
        name = "com_google_protobuf",
        strip_prefix = "protobuf-28.2",
        # build_file = "//bazel:protobuf.BUILD",
        type = "tar.gz",
        urls = [
            "https://github.com/protocolbuffers/protobuf/archive/refs/tags/v28.2.tar.gz",
        ],
    )

def _com_github_grpc_grpc():
    maybe(
        http_archive,
        name = "com_github_grpc_grpc",
        strip_prefix = "grpc-1.66.0",
        type = "tar.gz",
        urls = [
            "https://github.com/grpc/grpc/archive/refs/tags/v1.66.0.tar.gz",
        ],
    )

def _build_bazel_apple_support():
    maybe(
        http_archive,
        name = "build_bazel_apple_support",
        strip_prefix = "apple_support-1.17.1",
        urls = [
            "https://github.com/bazelbuild/apple_support/archive/refs/tags/1.17.1.tar.gz",
        ],
    )

def _build_bazel_rules_apple():
    maybe(
        http_archive,
        name = "build_bazel_rules_apple",
        strip_prefix = "rules_apple-3.9.2",
        urls = [
            "https://github.com/bazelbuild/rules_apple/archive/refs/tags/3.9.2.tar.gz",
        ],
    )

def _io_bazel_rules_go():
    maybe(
        http_archive,
        name = "io_bazel_rules_go",
        strip_prefix = "rules_go-0.50.1",
        urls = [
            "https://github.com/bazelbuild/rules_go/archive/v0.50.1.tar.gz",
        ],
    )

def _rules_cc():
    maybe(
        http_archive,
        name = "rules_cc",
        strip_prefix = "rules_cc-0.0.9",
        urls = [
            "https://github.com/bazelbuild/rules_cc/releases/download/0.0.9/rules_cc-0.0.9.tar.gz",
        ],
    )

def _bazel_gazelle():
    maybe(
        http_archive,
        name = "bazel_gazelle",
        strip_prefix = "bazel-gazelle-0.39.1",
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
        urls = [
            "https://github.com/googleapis/googleapis/archive/fe8ba054a.tar.gz",
        ],
    )


def _bazel_features_version():
    maybe(
        http_archive,
        name = "bazel_features",
        sha256 = "091d8b1e1f0bf1f7bd688b95007687e862cc489f8d9bc21c14be5fd032a8362f",
        strip_prefix = "bazel_features-1.26.0",
        url = "https://github.com/bazel-contrib/bazel_features/releases/download/v1.26.0/bazel_features-v1.26.0.tar.gz"
    )

def _com_github_nlohmann_json():
    maybe(
        http_archive,
        name = "com_github_nlohmann_json",
        strip_prefix = "json-3.11.3",
        build_file = "//bazel:nlohmann_json.BUILD",
        urls = [
            "https://github.com/nlohmann/json/archive/refs/tags/v3.11.3.tar.gz",
        ],
    )