#!/bin/sh
# Copyright (c) 2017 Lightricks. All rights reserved.
# Created by Gershon Hochman.

# Define output folder environment variable.
UNIVERSAL_OUTPUTFOLDER=${BUILD_DIR}/${CONFIGURATION}-universal

# Build Device and Simulator versions.
xcodebuild -target OpenEXRLib ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos  BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}"
xcodebuild -target OpenEXRLib -configuration ${CONFIGURATION} -sdk iphonesimulator -arch x86_64 BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}"

# Make sure the output directory exists.
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"

# Create universal binary file using lipo.
lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/lib${PROJECT_NAME}.a" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/lib${PROJECT_NAME}.a" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/lib${PROJECT_NAME}.a"

# Copy the header files.
cp -R "${BUILD_DIR}/${CONFIGURATION}-iphoneos/include" "${UNIVERSAL_OUTPUTFOLDER}/"
