#!/usr/bin/env bash

# Baixa o clang do GitHub Release deste repo e extrai no layout AOSP
# (clang/host/linux-x86/<versao>). O tarball fica em cache em
# ~/.cache/pegasus-toolchains para nao redownloadar ao recriar a toolchain.
#
# GitHub nao aceita arquivos >100 MB no git, por isso o clang (~3,8 GB)
# so existe como asset de Release.

set -e

REPO="XhakaTK/toolchains"
VERSION=${1:-"clang-r614150"}
ASSET="$VERSION-linux-x86.tar.zst"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="$DIR/clang/host/linux-x86"
CACHE="${TOOLCHAIN_CACHE:-$HOME/.cache/pegasus-toolchains}"

if [ -x "$DEST/$VERSION/bin/clang" ]; then
    echo "clang ja instalado em $DEST/$VERSION"
    exit 0
fi

mkdir -p "$DEST" "$CACHE"
URL="https://github.com/$REPO/releases/download/$VERSION/$ASSET"

if [ ! -f "$CACHE/$ASSET" ]; then
    echo "Baixando $URL..."
    curl -fL --retry 3 -o "$CACHE/$ASSET.part" "$URL"
    mv "$CACHE/$ASSET.part" "$CACHE/$ASSET"
fi

echo "Extraindo em $DEST..."
tar -C "$DEST" -f "$CACHE/$ASSET" -x --zstd

[ -x "$DEST/$VERSION/bin/clang" ] || {
    rm -rf "$DEST/$VERSION"
    echo "ERRO: extração não produziu $DEST/$VERSION/bin/clang" >&2
    exit 1
}

echo "OK: $DEST/$VERSION"
