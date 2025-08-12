# MIT License
#
# Copyright (c) 2017-2018 Maxim Biro <nurupo.contributions@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# Common directory paths

readonly WORKSPACE_DIR="/workspace"

# More directory variables

readonly BUILD_DIR="/build"
readonly OUTPUT_DIR="/output"
readonly DEP_DIR_64="$WORKSPACE_DIR/x86_64/dep-cache"
readonly DEP_DIR_32="$WORKSPACE_DIR/i686/dep-cache"
readonly OPENSSL_PREFIX_DIR_64="$DEP_DIR_64/libopenssl"
readonly OPENSSL_PREFIX_DIR_32="$DEP_DIR_32/libopenssl"
readonly OPENSSL_VERSION="openssl-3.5.2"

# Build dir should be empty

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Use all cores for building

MAKEFLAGS=j$(nproc)
export MAKEFLAGS

readonly WGET_OPTIONS="--timeout=10"

set -euox pipefail