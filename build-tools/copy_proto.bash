#!/usr/bin/env bash
cd "$BUILD_WORKSPACE_DIRECTORY"
rm -rf "@@TO_DIR@@"
mkdir -p "@@TO_DIR@@"
cp -pR @@FROM_DIR@@/* "@@TO_DIR@@"
