cc_library(
    name = "redis++",
    srcs = glob([
        "src/**/*.cpp",
        "src/**/*.h",
    ]),
    hdrs = glob(["include/**/*.h"]),
    includes = ["include"],
    visibility = ["//visibility:public"],
    copts = ["-std=c++17"],
    deps = ["@hiredis//:hiredis"],
) 