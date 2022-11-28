@echo off
bazelisk run @bazel_gazelle_go_repository_tools//:bin/gazelle.exe -- %*
