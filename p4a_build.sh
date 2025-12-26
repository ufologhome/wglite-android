#!/bin/bash
set -e

echo "=== WG-Lite p4a build ==="

############################
# 1️⃣ ВЕРСИИ (НЕ ТРОГАТЬ)
############################
ANDROID_API=29          # targetSdk
ANDROID_MINAPI=25       # Android 7.1.12
NDK_API=25              # КРИТИЧНО
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
# 3️⃣ ОЧИСТКА СТАРЫХ СБОРOК
############################
echo "[*] Cleaning old p4a dists"
rm -rf ~/.local/share/python-for-android/dists

############################
# 4️⃣ ANDROID SDK
############################
echo "[*] Installing Android SDK"

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

############################
# 5️⃣ ПРОВЕРКА
############################
echo "[*] SDK:"
sdkmanager --list | grep "android-${ANDROID_API}"

echo "[*] NDK:"
ls $ANDROID_NDK_HOME

############################
# 6️⃣ СБОРКА APK
############################
cd -

echo "[*] Building APK"

python -m pythonforandroid.toolchain apk \
  --name WG-Lite \
  --package org.example.wglite \
  --version 0.1 \
  --private $APP_DIR \
  --bootstrap service_only \
  --requirements python3,pyjnius \
  --arch $ARCH \
  --android-api $ANDROID_API \
  --minsdk $ANDROID_MINAPI \
  --ndk-api $NDK_API \
  --permission INTERNET \
  --debug

############################
# 7️⃣ ГОТОВО
############################
echo "=== BUILD FINISHED ==="
find ~/.local/share/python-for-android/dists -name "*.apk"
