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

def psi_deps():
    _com_github_gflags_gflags()
    _com_github_fmtlib_fmt()
    _com_google_protobuf()
    _com_github_redis_hiredis()
    _com_github_lz4_lz4()
    _com_github_grpc()

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
