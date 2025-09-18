#!/bin/bash

FRAMEWORK_NAME="NetInspect"
BUILD_DIR="build"

rm -rf "$BUILD_DIR"

echo "🚀 Building $FRAMEWORK_NAME for iOS Device..."
xcodebuild archive \
  -workspace "$FRAMEWORK_NAME.xcworkspace" \
  -scheme "$FRAMEWORK_NAME" \
  -sdk iphoneos \
  -archivePath "$BUILD_DIR/ios_devices.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "📱 Building $FRAMEWORK_NAME for iOS Simulator..."
xcodebuild archive \
  -workspace "$FRAMEWORK_NAME.xcworkspace" \
  -scheme "$FRAMEWORK_NAME" \
  -sdk iphonesimulator \
  -archivePath "$BUILD_DIR/ios_simulator.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "📦 Creating XCFramework..."
xcodebuild -create-xcframework \
  -framework "$BUILD_DIR/ios_devices.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework" \
  -framework "$BUILD_DIR/ios_simulator.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework" \
  -output "$BUILD_DIR/$FRAMEWORK_NAME.xcframework"