load("@yacl//bazel:yacl.bzl", "yacl_cmake_external")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

yacl_cmake_external(
    name = "hiredis",
    lib_source = ":all_srcs",
    out_headers_only = True,
)
