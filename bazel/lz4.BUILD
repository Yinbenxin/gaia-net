load("@rules_foreign_cc//foreign_cc:defs.bzl", "make")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(
        include = ["**"],
        exclude = ["*.bazel"],
    ),
)

make(
    name = "lz4",
    args = ["-j4"],
    env = select({
        "@platforms//os:macos": {
            "AR": "/usr/bin/ar",  # 使用系统默认的 ar
        },
        "//conditions:default": {
            "MODULESDIR": "",
        },
    }),
    lib_source = ":all_srcs",
    out_static_libs = ["liblz4.a"],
    targets = [
        "lib",
        "install",
    ],
)