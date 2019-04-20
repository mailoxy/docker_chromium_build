#!/bin/bash

set -e

mkdir -p $DIR/src && cd $DIR
rm -rf $DIR/src/out
mkdir -p $DIR/src/out/Default

rm -rf $DIR/chromium_patches
git clone https://github.com/AndroidHardeningArchive/chromium_patches

fetch --nohooks chromium || true
cd $DIR/src
git reset --hard
echo "target_os = [ 'android' ]" >> ../.gclient
gclient sync --with_branch_heads --jobs 6 -RDf
build/install-build-deps-android.sh
build/linux/sysroot_scripts/install-sysroot.py --all
gclient runhooks

git reset --hard $REF

for patch in ../chromium_patches/*.patch; do
    patch -p1 --no-backup-if-mismatch < $patch
done

cat << EOF > out/Default/args.gn

target_os = "android"
target_cpu = "arm64"

is_debug = false
remove_webcore_debug_symbols=true

use_lld = true # experimental

is_official_build = true
is_component_build = false
enable_resource_whitelist_generation = false
symbol_level = 0

ffmpeg_branding = "Chrome"
proprietary_codecs = true

android_channel = "stable"
android_default_version_name = "$VER"
android_default_version_code = "$REV"
EOF

gn gen out/Default

ninja -C out/Default/ monochrome_public_apk

