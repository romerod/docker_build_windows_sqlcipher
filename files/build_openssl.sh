#!/usr/bin/env bash

. /tmp/build_base.sh

# OpenSSL
# hash from https://www.openssl.org/source/
OPENSSL_HASH="c53a47e5e441c930c3928cf7bf6fb00e5d129b630e0aa873b08258656e7345ec"
OPENSSL_FILENAME="openssl-$OPENSSL_VERSION.tar.gz"

rm -rf "$OPENSSL_PREFIX_DIR"
mkdir -p "$OPENSSL_PREFIX_DIR"

wget $WGET_OPTIONS "https://www.openssl.org/source/$OPENSSL_FILENAME"
check_sha256 "$OPENSSL_HASH" "$OPENSSL_FILENAME"
bsdtar --no-same-owner --no-same-permissions -xf "$OPENSSL_FILENAME"
rm $OPENSSL_FILENAME
cd openssl*

CONFIGURE_OPTIONS="--prefix=$OPENSSL_PREFIX_DIR --openssldir=${OPENSSL_PREFIX_DIR}/ssl shared"
if [[ "$ARCH" == "x86_64" ]]
then
  CONFIGURE_OPTIONS="$CONFIGURE_OPTIONS mingw64 --cross-compile-prefix=x86_64-w64-mingw32-"
elif [[ "$ARCH" == "i686" ]]
then
  CONFIGURE_OPTIONS="$CONFIGURE_OPTIONS mingw --cross-compile-prefix=i686-w64-mingw32-"
fi

./Configure $CONFIGURE_OPTIONS
make
make install
echo -n $OPENSSL_VERSION > $OPENSSL_PREFIX_DIR/done

CONFIGURE_OPTIONS=""