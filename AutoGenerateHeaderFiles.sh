#!/bin/sh
# Copyright (c) 2017 Lightricks. All rights reserved.
# Created by Gershon Hochman.

set -x

export ARCHS="i386 x86_64"
export ARCHS_STANDARD="i386 x86_64"
export ARCHS_STANDARD_32_64_BIT="i386 x86_64"
export ARCHS_STANDARD_32_BIT=i386
export ARCHS_STANDARD_64_BIT=x86_64
export ARCHS_STANDARD_INCLUDING_64_BIT="i386 x86_64"
export CURRENT_ARCH=x86_64
export DEPLOYMENT_TARGET_CLANG_ENV_NAME=MACOSX_DEPLOYMENT_TARGET
export DEPLOYMENT_TARGET_CLANG_FLAG_NAME=mmacosx-version-min
export DEPLOYMENT_TARGET_SETTING_NAME=MACOSX_DEPLOYMENT_TARGET
export EFFECTIVE_PLATFORM_NAME=-macosx
export MACOSX_DEPLOYMENT_TARGET=$_system_version
export NATIVE_ARCH=x86_64
export PLATFORM_DEVELOPER_APPLICATIONS_DIR=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Applications
export PLATFORM_DEVELOPER_BIN_DIR=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/bin
export PLATFORM_DEVELOPER_SDK_DIR=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs
export PLATFORM_DEVELOPER_TOOLS_DIR=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Tools
export PLATFORM_DEVELOPER_USR_DIR=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr
export PLATFORM_DIR=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform
export PLATFORM_DISPLAY_NAME=MacOSX
export PLATFORM_NAME=macosx
export PLATFORM_PREFERRED_ARCH=x86_64
export SDKROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
export SDK_DIR=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
export SDK_NAME=macosx$_system_version
export SDK_NAMES=macosx$_system_version
export SDK_VERSION=$_system_version
export VALID_ARCHS="i386 x86_64"
export arch=x86_64

unset IPHONEOS_DEPLOYMENT_TARGET

mkdir -p "$OBJECT_FILE_DIR"
mkdir -p "$DERIVED_SOURCES_DIR"

cd "$SOURCE_ROOT/IlmBase/Half"

g++ -DHAVE_CONFIG_H -I. -I.. -D_THREAD_SAFE -pipe -g -O2  -MD -MP -c -o "$OBJECT_FILE_DIR/toFloat.o" toFloat.cpp
g++ -pipe -g -O2 -o "$OBJECT_FILE_DIR/toFloat" "$OBJECT_FILE_DIR/toFloat.o" -Wl,-bind_at_load
"$OBJECT_FILE_DIR/toFloat" > "$DERIVED_SOURCES_DIR/toFloat.h"

g++ -DHAVE_CONFIG_H -I. -I.. -D_THREAD_SAFE -pipe -g -O2  -MD -MP -c -o "$OBJECT_FILE_DIR/eLut.o" eLut.cpp
g++ -pipe -g -O2 -o "$OBJECT_FILE_DIR/eLut" "$OBJECT_FILE_DIR/eLut.o" -Wl,-bind_at_load
"$OBJECT_FILE_DIR/eLut" > "$DERIVED_SOURCES_DIR/eLut.h"

g++ -DHAVE_CONFIG_H -I. -I.. -I"$DERIVED_SOURCES_DIR" -D_THREAD_SAFE -pipe -g -O2  -MD -MP -c -o "$OBJECT_FILE_DIR/half.o" half.cpp

cd "$SOURCE_ROOT/IlmBase/IlmThread"

g++ -DHAVE_CONFIG_H -I. -I.. -I../Iex -D_THREAD_SAFE -pipe -g -O2  -MD -MP -c -o "$OBJECT_FILE_DIR/IlmThread.o" IlmThread.cpp
g++ -DHAVE_CONFIG_H -I. -I.. -I../Iex -D_THREAD_SAFE -pipe -g -O2  -MD -MP -c -o "$OBJECT_FILE_DIR/IlmThreadPosix.o" IlmThreadPosix.cpp
g++ -DHAVE_CONFIG_H -I. -I.. -I../Iex -D_THREAD_SAFE -pipe -g -O2  -MD -MP -c -o "$OBJECT_FILE_DIR/IlmThreadSemaphore.o" IlmThreadSemaphore.cpp
g++ -DHAVE_CONFIG_H -I. -I.. -I../Iex -D_THREAD_SAFE -pipe -g -O2  -MD -MP -c -o "$OBJECT_FILE_DIR/IlmThreadSemaphorePosix.o" IlmThreadSemaphorePosix.cpp
g++ -DHAVE_CONFIG_H -I. -I.. -I../Iex -D_THREAD_SAFE -pipe -g -O2  -MD -MP -c -o "$OBJECT_FILE_DIR/IlmThreadSemaphorePosixCompat.o" IlmThreadSemaphorePosixCompat.cpp

cd "$SOURCE_ROOT/IlmBase/Iex"
g++ -DHAVE_CONFIG_H -I. -I.. -D_THREAD_SAFE -pipe -g -O2  -MD -MP -c -o "$OBJECT_FILE_DIR/IexThrowErrnoExc.o" IexThrowErrnoExc.cpp
g++ -DHAVE_CONFIG_H -I. -I.. -D_THREAD_SAFE -pipe -g -O2  -MD -MP -c -o "$OBJECT_FILE_DIR/IexBaseExc.o" IexBaseExc.cpp

cd "$SOURCE_ROOT/OpenEXR/IlmImf"

g++ -DHAVE_CONFIG_H -I. -I.. -I"$SOURCE_ROOT/IlmBase/Half" -D_THREAD_SAFE -pipe -g -O2  -MD -MP -c -o "$OBJECT_FILE_DIR/b44ExpLogTable.o" b44ExpLogTable.cpp
g++ -pipe -g -O2 -o "$OBJECT_FILE_DIR/b44ExpLogTable" "$OBJECT_FILE_DIR/b44ExpLogTable.o" "$OBJECT_FILE_DIR/half.o" -Wl,-bind_at_load
"$OBJECT_FILE_DIR/b44ExpLogTabl"e > "$DERIVED_SOURCES_DIR/b44ExpLogTable.h"

g++ -DHAVE_CONFIG_H -I. -I.. -I"$SOURCE_ROOT/IlmBase" -I"$SOURCE_ROOT/IlmBase/Half"  -I"$SOURCE_ROOT/IlmBase/Ie"x -I"$SOURCE_ROOT/IlmBase/IlmThread" -I"$SOURCE_ROOT/IlmBase/Imath" -D_THREAD_SAFE -pipe -g -O2  -MD -MP -c -o "$OBJECT_FILE_DIR/dwaLookups.o" dwaLookups.cpp
g++ -pipe -g -O2 -o "$OBJECT_FILE_DIR/dwaLookups" "$OBJECT_FILE_DIR/dwaLookups.o" "$OBJECT_FILE_DIR/half.o" "$OBJECT_FILE_DIR/IlmThreadSemaphorePosixCompat.o" "$OBJECT_FILE_DIR/IlmThreadSemaphore.o" "$OBJECT_FILE_DIR/IlmThreadSemaphorePosix.o" "$OBJECT_FILE_DIR/IlmThreadPosix.o" "$OBJECT_FILE_DIR/IlmThread.o" "$OBJECT_FILE_DIR/IexThrowErrnoExc.o" "$OBJECT_FILE_DIR/IexBaseExc.o" -Wl,-bind_at_load
"$OBJECT_FILE_DIR/dwaLookups" > "$DERIVED_SOURCES_DIR/dwaLookups.h"
