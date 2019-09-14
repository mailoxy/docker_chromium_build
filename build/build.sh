#!/bin/bash

set -e

git config --global user.name "Your Name"
git config --global user.email "you@example.org"

mkdir -p $DIR && cd $DIR
fetch --nohooks android || true
cd $DIR/src
echo "target_os = [ 'android' ]" >> ../.gclient
#[ -d $DIR/src/.git ] && 
git clean -d -x -f
gclient sync --with_branch_heads --jobs 6 -D -r $VER
mkdir -p $DIR/src/out/Default
build/install-build-deps-android.sh
build/linux/sysroot_scripts/install-sysroot.py --all
gclient runhooks

cd $DIR && rm -rf $DIR/Vanadium
git clone https://github.com/GrapheneOS/Vanadium.git

cd $DIR/src

for patch in ../Vanadium/*.patch; do
    git am $patch || git am --abort
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

autoninja -C out/Default/ monochrome_public_apk
