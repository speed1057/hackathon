#!/bin/bash

# Build script for Flutter web deployment
echo "Building Flutter web app..."

# Clean previous build
flutter clean

# Get dependencies
flutter pub get

# Build for web with optimizations
flutter build web --release --base-href / -O 4

echo "Build complete! Files are in build/web/"
