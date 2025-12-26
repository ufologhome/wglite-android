#!/bin/bash
set -e

echo "=== WG-Lite p4a build ==="

############################
# 1️⃣ ВЕРСИИ
############################
ANDROID_API=29
ANDROID_MINAPI=21
NDK_API=21
ARCH=armeabi-v7a

############################
# 2️⃣ ПУТИ
############################
export ANDROID_SDK_ROOT=$HOME/android-sdk
export ANDROID_HOME=$ANDROID_SDK_ROOT
export ANDROID_NDK_HOME=$ANDROID_SDK_ROOT/ndk/25.2.9519653

export PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH
export PATH=$ANDROID_NDK_HOME:$PATH

APP_DIR=$(pwd)/app

############################
# 3️⃣ ЖЁСТКАЯ ОЧИСТКА DIST
############################
echo "[*] Removing old python-for-android dists"
rm -rf ~/.local/share/python-for-android

############################
# 4️⃣ SDK
############################
rm -rf $ANDROID_SDK_ROOT
mkdir -p $ANDROID_SDK_ROOT/cmdline-tools
cd $ANDROID_SDK_ROOT

wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
unzip -q commandlinetools-linux-9477386_latest.zip

mkdir -p cmdline-tools/latest
mv cmdline-tools/* cmdline-tools/latest/ || true

yes | sdkmanager --sdk_root=$ANDROID_SDK_ROOT \
  "platform-tools" \
  "platforms;android-${ANDROID_API}" \
  "build-tools;29.0.3" \
  "ndk;25.2.9519653"

cd -

############################
# 5️⃣ BUILD
############################
python -m pythonforandroid.toolchain apk \
  --name WG-Lite \
  --package org.example.wglite \
  --version 0.1 \
  --private app \
  --bootstrap service_only \
  --requirements python3,pyjnius \
  --arch armeabi-v7a \
  --android-api 29 \
  --minsdk 21 \
  --ndk-api 21 \
  --permission INTERNET \
  --debug

