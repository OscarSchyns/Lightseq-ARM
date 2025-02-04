#!/bin/bash

# Check if NDK exists (Cask location)
NDK_PATH="/usr/local/share/android-ndk"
if [ ! -d "$NDK_PATH" ]; then
    echo "Error: Android NDK not found at $NDK_PATH"
    echo "Please install Android NDK first using: brew install --cask android-ndk"
    exit 1
fi

# Check if adb exists
if ! command -v adb &> /dev/null; then
    echo "Error: adb not found"
    echo "Please install Android platform tools first using: brew install android-platform-tools"
    exit 1
fi

# Set up environment variables
export ANDROID_NDK=$NDK_PATH
export PATH=$PATH:$ANDROID_NDK

# Create build directory
mkdir -p build && cd build

# Configure CMake
cmake .. \
    -DCMAKE_TOOLCHAIN_FILE=$NDK_PATH/build/cmake/android.toolchain.cmake \
    -DANDROID_ABI="arm64-v8a" \
    -DANDROID_PLATFORM=android-21 \
    -DCMAKE_BUILD_TYPE=Release

# Build
make -j$(sysctl -n hw.ncpu)

# Go back to root directory
cd ..
