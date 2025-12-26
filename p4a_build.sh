name: Build WG-Lite APK for Android 8.0

on:
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  build-apk:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repo
        uses: actions/checkout@v3

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.10'

      - name: Install python-for-android
        run: |
          python -m pip install --upgrade pip
          pip install python-for-android==2023.5.21 Cython==0.29.37

      - name: Prepare Android SDK & NDK
        run: |
          ANDROID_SDK_ROOT=$HOME/android-sdk
          mkdir -p $ANDROID_SDK_ROOT/cmdline-tools
          cd $ANDROID_SDK_ROOT
          wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
          unzip -q commandlinetools-linux-9477386_latest.zip
          mkdir -p cmdline-tools/latest
          mv cmdline-tools/* cmdline-tools/latest/ || true
          yes | sdkmanager --sdk_root=$ANDROID_SDK_ROOT \
            "platform-tools" \
            "platforms;android-26" \
            "build-tools;26.0.3" \
            "ndk;25.2.9519653"
          cd -

      - name: Build APK
        run: |
          python -m pythonforandroid.toolchain apk \
            --name WG-Lite \
            --package org.example.wglite \
            --version 0.1 \
            --private app \
            --bootstrap service_only \
            --requirements python3,pyjnius \
            --arch armeabi-v7a \
            --android-api 26 \
            --minsdk 26 \
            --ndk-api 25 \
            --allow-minsdk-ndkapi-mismatch \
            --permission INTERNET \
            --debug

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: WG-Lite-debug
          path: ~/.local/share/python-for-android/dists/*/build/outputs/apk/debug/*.apk
