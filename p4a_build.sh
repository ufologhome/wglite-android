#!/bin/bash
set -e

export ANDROIDSDK=$HOME/android-sdk
export ANDROIDNDK=$HOME/android-ndk/android-ndk-r21e
export ANDROIDAPI=29
export ANDROIDMINAPI=25
export PATH=$ANDROIDSDK/cmdline-tools/latest/bin:$PATH

APP_DIR=$(pwd)/app

python3 -m pythonforandroid.toolchain create \
  --dist_name=wglite \
  --bootstrap=service_only \
  --requirements=python3,pyjnius \
  --arch=armeabi-v7a \
  --ndk-api=21 \
  --android-api=29 \
  --ignore-setup-py \
  --debug

python3 -m pythonforandroid.toolchain apk \
  --name WG-Lite \
  --package org.example.wglite \
  --version 0.1 \
  --private $APP_DIR \
  --bootstrap service_only \
  --arch armeabi-v7a \
  --sdk 29 \
  --minsdk 25 \
  --manifest $APP_DIR/android_manifest.tmpl.xml \
  --permission INTERNET \
  --debug
