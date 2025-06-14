#!/bin/bash

# Vercel deployment script for Flutter web
set -e

echo "🚀 Starting Flutter web deployment to Vercel..."

# Check if flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    exit 1
fi

# Check if vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "📦 Installing Vercel CLI..."
    npm install -g vercel
fi

# Clean and build
echo "🧹 Cleaning previous build..."
flutter clean

echo "📚 Getting dependencies..."
flutter pub get

echo "🔨 Building Flutter web app..."
flutter build web --release --base-href / -O 4

# Navigate to build directory
cd build/web

echo "🌐 Deploying to Vercel..."
vercel --prod

echo "✅ Deployment complete!"
echo "🎉 Your app is now live on Vercel!"
