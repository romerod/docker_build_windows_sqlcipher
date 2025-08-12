#!/usr/bin/env bash

. /tmp/build_base.sh

# SQLCipher

SQLCIPHER_PREFIX_DIR="$DEP_DIR_32/libsqlcipher"
SQLCIPHER_VERSION="v4.10.0"
SQLCIPHER_FILENAME="$SQLCIPHER_VERSION.tar.gz"

rm -rf "$SQLCIPHER_PREFIX_DIR"
mkdir -p "$SQLCIPHER_PREFIX_DIR"

wget $WGET_OPTIONS "https://github.com/sqlcipher/sqlcipher/archive/$SQLCIPHER_FILENAME"
bsdtar --no-same-owner --no-same-permissions -xf "$SQLCIPHER_FILENAME"
rm $SQLCIPHER_FILENAME
cd sqlcipher*

sed -i s/'if test "$TARGET_EXEEXT" = ".exe"'/'if test ".exe" = ".exe"'/g configure
sed -i 's|exec $PWD/mksourceid manifest|exec $PWD/mksourceid.exe manifest|g' tool/mksqlite3h.tcl

LIB_DIR_32="lib";
LIB_DIR_64="lib64";

./configure --host="i686-w64-mingw32" \
            --prefix="$SQLCIPHER_PREFIX_DIR" \
            --disable-shared \
            --with-tempstore=yes \
            CFLAGS="-O2 -g0 -DSQLITE_HAS_CODEC -DSQLITE_EXTRA_INIT=sqlcipher_extra_init -DSQLITE_EXTRA_SHUTDOWN=sqlcipher_extra_shutdown  -I$OPENSSL_PREFIX_DIR_32/include/" \
            LDFLAGS="$OPENSSL_PREFIX_DIR_32/$LIB_DIR_32/libcrypto.a -lcrypto -lgdi32 -lws2_32 -lcrypt32 -static-libgcc -L$OPENSSL_PREFIX_DIR_32/$LIB_DIR_32/" \
            LIBS="-lgdi32 -lws2_32 -lcrypt32" || cat config.log

sed -i s/"TEXE = $"/"TEXE = .exe"/ Makefile

make
make install
make sqlite3.dll USE_NATIVE_LIBPATHS=1 "OPTS=-DSQLITE_ENABLE_FTS3=1 -DSQLITE_ENABLE_FTS4=1 -DSQLITE_ENABLE_FTS5=1 -DSQLITE_ENABLE_RTREE=1 -DSQLITE_ENABLE_JSON1=1 -DSQLITE_ENABLE_GEOPOLY=1 -DSQLITE_ENABLE_SESSION=1 -DSQLITE_ENABLE_PREUPDATE_HOOK=1 -DSQLITE_ENABLE_SERIALIZE=1 -DSQLITE_ENABLE_MATH_FUNCTIONS=1"
mkdir -p "$OUTPUT_DIR/x86"
cp "$SQLCIPHER_PREFIX_DIR/bin/sqlite3.exe" "$OUTPUT_DIR/x86/"
cp "/build/sqlcipher-${SQLCIPHER_VERSION:1}/sqlite3.dll" "$OUTPUT_DIR/x86/e_sqlite3.dll"

make distclean

./configure --host="x86_64-w64-mingw32" \
            --prefix="$SQLCIPHER_PREFIX_DIR" \
            --disable-shared \
            --with-tempstore=yes \
            CFLAGS="-O2 -g0 -DSQLITE_HAS_CODEC -DSQLITE_EXTRA_INIT=sqlcipher_extra_init -DSQLITE_EXTRA_SHUTDOWN=sqlcipher_extra_shutdown  -I$OPENSSL_PREFIX_DIR_64/include/" \
            LDFLAGS="$OPENSSL_PREFIX_DIR_64/$LIB_DIR_64/libcrypto.a -lcrypto -lgdi32 -lws2_32 -lcrypt32 -static-libgcc -L$OPENSSL_PREFIX_DIR_64/$LIB_DIR_64/" \
            LIBS="-lgdi32 -lws2_32 -lcrypt32" || cat config.log

sed -i s/"TEXE = $"/"TEXE = .exe"/ Makefile

make
make install
make sqlite3.dll USE_NATIVE_LIBPATHS=1 "OPTS=-DSQLITE_ENABLE_FTS3=1 -DSQLITE_ENABLE_FTS4=1 -DSQLITE_ENABLE_FTS5=1 -DSQLITE_ENABLE_RTREE=1 -DSQLITE_ENABLE_JSON1=1 -DSQLITE_ENABLE_GEOPOLY=1 -DSQLITE_ENABLE_SESSION=1 -DSQLITE_ENABLE_PREUPDATE_HOOK=1 -DSQLITE_ENABLE_SERIALIZE=1 -DSQLITE_ENABLE_MATH_FUNCTIONS=1"
mkdir -p "$OUTPUT_DIR/x64"
cp "$SQLCIPHER_PREFIX_DIR/bin/sqlite3.exe" "$OUTPUT_DIR/x64/"
cp "/build/sqlcipher-${SQLCIPHER_VERSION:1}/sqlite3.dll" "$OUTPUT_DIR/x64/e_sqlite3.dll"

RELEASE_NAME="${OPENSSL_VERSION}_sqlcipher_${SQLCIPHER_VERSION:1}"
echo "$RELEASE_NAME" > "$OUTPUT_DIR/release_name.txt"