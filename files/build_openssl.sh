#!/usr/bin/env bash

. /tmp/build_base.sh

# OpenSSL
# hash from https://www.openssl.org/source/
OPENSSL_FILENAME="$OPENSSL_VERSION.tar.gz"

rm -rf "$OPENSSL_PREFIX_DIR_64"
mkdir -p "$OPENSSL_PREFIX_DIR_64"
rm -rf "$OPENSSL_PREFIX_DIR_32"
mkdir -p "$OPENSSL_PREFIX_DIR_32"

wget $WGET_OPTIONS "https://github.com/openssl/openssl/releases/download/$OPENSSL_VERSION/$OPENSSL_FILENAME"
bsdtar --no-same-owner --no-same-permissions -xf "$OPENSSL_FILENAME"
rm $OPENSSL_FILENAME
cd openssl*

# Configure and build for 64-bit

CONFIGURE_OPTIONS="--prefix=$OPENSSL_PREFIX_DIR_64 --openssldir=${OPENSSL_PREFIX_DIR_64}/ssl shared mingw64 --cross-compile-prefix=x86_64-w64-mingw32-"

./Configure $CONFIGURE_OPTIONS
make
make install
echo -n $OPENSSL_VERSION > $OPENSSL_PREFIX_DIR_64/done

# Configure and build for 32-bit
make distclean
CONFIGURE_OPTIONS="--prefix=$OPENSSL_PREFIX_DIR_32 --openssldir=${OPENSSL_PREFIX_DIR_32}/ssl shared mingw --cross-compile-prefix=i686-w64-mingw32-"

./Configure $CONFIGURE_OPTIONS
make
make install
echo -n $OPENSSL_VERSION > $OPENSSL_PREFIX_DIR_32/done