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
    _rule_proto()
    _rule_python()
    _rules_foreign_cc()
    _com_google_protobuf()

    _com_github_gflags_gflags()
    _com_github_fmtlib_fmt()
    _com_google_protobuf()
    _com_github_redis_hiredis()
    _com_github_lz4_lz4()
    _com_github_grpc()
    _com_google_googletest()
def _rule_proto():
    maybe(
        http_archive,
        name = "rules_proto",
        sha256 = "dc3fb206a2cb3441b485eb1e423165b231235a1ea9b031b4433cf7bc1fa460dd",
        strip_prefix = "rules_proto-5.3.0-21.7",
        urls = [
            "https://github.com/bazelbuild/rules_proto/archive/refs/tags/5.3.0-21.7.tar.gz",
        ],
    )
def _rule_python():
    maybe(
        http_archive,
        name = "rules_python",
        sha256 = "be04b635c7be4604be1ef20542e9870af3c49778ce841ee2d92fcb42f9d9516a",
        strip_prefix = "rules_python-0.35.0",
        urls = [
            "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.35.0.tar.gz",
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
def _com_google_protobuf():
    maybe(
        http_archive,
        name = "com_google_protobuf",
        sha256 = "2c6a36c7b5a55accae063667ef3c55f2642e67476d96d355ff0acb13dbb47f09",
        strip_prefix = "protobuf-21.12",
        type = "tar.gz",
        patch_args = ["-p1"],
        patches = ["@yacl//bazel:patches/protobuf.patch"],
        urls = [
            "https://github.com/protocolbuffers/protobuf/releases/download/v21.12/protobuf-all-21.12.tar.gz",
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
    
def _com_github_grpc():
    maybe(
        http_archive,
        name = "com_github_grpc",
        strip_prefix = "grpc-1.35.0",
        type = "tar.gz",
        urls = [
            "https://github.com/grpc/grpc/archive/refs/tags/v1.35.0.tar.gz",
        ],
    )



def _com_google_protobuf():
    maybe(
        http_archive,
        name = "com_google_protobuf",
        # sha256 = "2c6a36c7b5a55accae063667ef3c55f2642e67476d96d355ff0acb13dbb47f09",
        strip_prefix = "protobuf-3.6.1",
        type = "tar.gz",
        # patch_args = ["-p1"],
        # patches = ["@yacl//bazel:patches/protobuf.patch"],
        urls = [
            "https://github.com/protocolbuffers/protobuf/archive/refs/tags/v3.6.1.tar.gz",
        ],
    )

def _com_github_redis_hiredis():
    maybe(
        http_archive,
        name = "hiredis",
        strip_prefix = "hiredis-1.2.0",
        build_file = "//bazel:hiredis.BUILD",
        type = "tar.gz",
        urls = [
            "https://github.com/redis/hiredis/archive/refs/tags/v1.2.0.tar.gz",
        ],
    )


def _com_github_lz4_lz4():
    maybe(
        http_archive,
        name = "lz4",
        strip_prefix = "lz4-1.9.3",
        build_file = "//bazel:lz4.BUILD",
        type = "tar.gz",
        urls = [
            "https://github.com/lz4/lz4/archive/refs/tags/v1.9.3.tar.gz",
        ],
    )

