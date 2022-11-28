@echo off
bazelisk run @bazel_gazelle_go_repository_tools//:bin/gazelle.exe -- update-repos -from_file=go.mod -to_macro=deps.bzl%%go_dependencies -prune -build_file_proto_mode=disable_global
