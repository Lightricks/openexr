#!/bin/sh
# Copyright (c) 2017 Lightricks. All rights reserved.
# Created by Gershon Hochman.

# Define output folder environment variable.
UNIVERSAL_OUTPUTFOLDER=${BUILD_DIR}/${CONFIGURATION}-universal

# Build Device and Simulator versions.
xcodebuild -target OpenEXR ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos  BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}"
xcodebuild -target OpenEXR ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphonesimulator BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}"

# Make sure the output directory exists.
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}/lib"

# Create universal binary file using lipo.
lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/lib/libOpenEXR.a" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/libOpenEXR.a" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/libOpenEXR.a"

# Copy the header files.
cp -R "${BUILD_DIR}/${CONFIGURATION}-iphoneos/include" "${UNIVERSAL_OUTPUTFOLDER}/"
