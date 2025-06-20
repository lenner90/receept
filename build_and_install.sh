#!/bin/bash

# Script to build and install the Receept app

echo "Building Receept APK..."

# Clean the project first
flutter clean

# Get dependencies
flutter pub get

# Build the APK
flutter build apk --release

echo "Build completed!"
echo "APK location: $(pwd)/build/app/outputs/flutter-apk/app-release.apk"

echo ""
echo "Installation options:"
echo "1. Connect your Android device via USB with USB debugging enabled"
echo "2. Run: flutter install"
echo ""
echo "Or transfer the APK to your device manually and install it."
echo "Make sure your device is connected to the same WiFi network as your development machine."
echo "The server should be running at http://192.168.10.123:3000"