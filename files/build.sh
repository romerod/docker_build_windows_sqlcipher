#!/usr/bin/env bash

. /tmp/build_base.sh

# SQLCipher

SQLCIPHER_PREFIX_DIR="$DEP_DIR/libsqlcipher"
SQLCIPHER_VERSION=v4.10.0
SQLCIPHER_HASH="676B636FF01FEF2FA437B8749E73BD3BEC4BA15041B7DF9821A188BA52AAB241"
SQLCIPHER_FILENAME="$SQLCIPHER_VERSION.tar.gz"

rm -rf "$SQLCIPHER_PREFIX_DIR"
mkdir -p "$SQLCIPHER_PREFIX_DIR"

wget $WGET_OPTIONS "https://github.com/sqlcipher/sqlcipher/archive/$SQLCIPHER_FILENAME"
check_sha256 "$SQLCIPHER_HASH" "$SQLCIPHER_FILENAME"
bsdtar --no-same-owner --no-same-permissions -xf "$SQLCIPHER_FILENAME"
rm $SQLCIPHER_FILENAME
cd sqlcipher*

sed -i s/'if test "$TARGET_EXEEXT" = ".exe"'/'if test ".exe" = ".exe"'/g configure
sed -i 's|exec $PWD/mksourceid manifest|exec $PWD/mksourceid.exe manifest|g' tool/mksqlite3h.tcl

./configure --host="$ARCH-w64-mingw32" \
            --prefix="$SQLCIPHER_PREFIX_DIR" \
            --disable-shared \
            --with-tempstore=yes \
            CFLAGS="-O2 -g0 -DSQLITE_HAS_CODEC -DSQLITE_EXTRA_INIT=sqlcipher_extra_init -DSQLITE_EXTRA_SHUTDOWN=sqlcipher_extra_shutdown  -I$OPENSSL_PREFIX_DIR/include/" \
            LDFLAGS="$OPENSSL_PREFIX_DIR/lib64/libcrypto.a -lcrypto -lgdi32 -lws2_32 -lcrypt32 -L$OPENSSL_PREFIX_DIR/lib64/" \
            LIBS="-lgdi32 -lws2_32 -lcrypt32" || cat config.log

sed -i s/"TEXE = $"/"TEXE = .exe"/ Makefile

make
make install
cp "$SQLCIPHER_PREFIX_DIR/bin/sqlite3.exe" "$OUTPUT_DIR/"
