load("@bazel_gazelle//:deps.bzl", "go_repository")

def go_repositories():
    go_repository(
        name = "com_github_reltuk_bazel_consumed_go",
        build_file_proto_mode = "disable_global",
        importpath = "github.com/reltuk/bazel_consumed/go",
        sum = "h1:e6yTHJ4OhH3pIhK5EXVpTVAoiYqgJNG7zpada+xRIcQ=",
        version = "v0.0.0-20210215225838-f7c6d7598c4c",
    )
