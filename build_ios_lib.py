#!/usr/bin/env python3

import glob, re, os, os.path, shutil, string, sys, argparse, traceback, multiprocessing
from subprocess import check_call, check_output, CalledProcessError

IPHONEOS_DEPLOYMENT_TARGET='12.0'  # default, can be changed via command line options or environemnt variable

def execute(cmd, cwd = None):
    print("Executing: %s in %s" % (cmd, cwd), file=sys.stderr)
    print('Executing: ' + ' '.join(cmd))
    retcode = check_call(cmd, cwd = cwd)
    if retcode != 0:
        raise Exception("Child returned:", retcode)

class Builder:
    def __init__(self, configuration, bitcode_enabled, deployment_target):
        self.configuration = configuration
        self.bitcode_enabled = bitcode_enabled
        self.deployment_target = deployment_target

    def get_toolchain(self):
        script_dir_path = os.path.abspath(os.path.dirname(__file__))
        return os.path.join(script_dir_path, "ios-cmake", "ios.toolchain.cmake")

    def _build(self, outdir):
        out_dir = os.path.abspath(outdir)
        os.makedirs(out_dir)
        build_path = os.path.join(out_dir, "build")
        platform_libs_path = os.path.join(build_path, "intermediate")
        os.makedirs(platform_libs_path)

        platforms = ["SIMULATOR64", "OS64"]

        for platform in platforms:
            platform_out_dir = os.path.join(build_path, platform)
            os.makedirs(platform_out_dir)
            print("Creating directory " + platform_out_dir)
            self.build_platform(platform, platform_out_dir)
            platform_merged_lib_file = os.path.join(platform_libs_path, self.platform_lib_file(platform))
            platform_lib_dir = os.path.join(platform_out_dir, "lib")
            self.merge_libs_in_directory(platform_lib_dir, platform_merged_lib_file)
        
        final_lib_path = os.path.join(out_dir, "product", "lib")
        final_include_path = os.path.join(out_dir, "product", "include")
        os.makedirs(final_lib_path)
        os.makedirs(final_include_path)

        self.create_universal_static_lib(platform_libs_path, os.path.join(final_lib_path, "libOpenEXR.a"))
        platform_include_dir = os.path.join(build_path, platforms[0], "include", "OpenEXR")
        shutil.copytree(platform_include_dir, os.path.join(final_include_path, "OpenEXR"))

    def platform_lib_file(self, platform):
        return f"OpenExr_{platform}.a" 

    def build(self, outdir):
        try:
            self._build(outdir)
        except Exception as e:
            print("="*60, file=sys.stderr)
            print("ERROR: %s" % e, file=sys.stderr)
            print("="*60, file=sys.stderr)
            traceback.print_exc(file=sys.stderr)
            sys.exit(1)

    def get_cmake_xcode_generate_command(self, platform, out_dir):
        return [
            "cmake",
            os.path.abspath(os.path.dirname(__file__)),
            "-GXcode",
            f"-DCMAKE_TOOLCHAIN_FILE={self.get_toolchain()}",
            f"-DPLATFORM={platform}",
            "-DCMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY=''",
            "-DCMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM=''",
            "-DBUILD_SHARED_LIBS=OFF",
            f"-DDEPLOYMENT_TARGET={self.deployment_target}",
            f"-DENABLE_BITCODE={'ON' if self.bitcode_enabled else 'OFF'}",
            f"-DCMAKE_INSTALL_PREFIX={out_dir}",
        ]

    def get_cmake_build_command(self):
        args = [
            "cmake",
            "--build",
            ".",
            "--clean-first",
            "--config",
            self.configuration,
            "--target",
            "install",
        ]
        return args

    def build_platform(self, platform, build_dir):
        execute(self.get_cmake_xcode_generate_command(platform, build_dir), cwd = build_dir)
        execute(self.get_cmake_build_command(), cwd = build_dir)

    def merge_libs_in_directory(self, directory_path, out_lib_file_path):
        print("Merging libraries in path " + directory_path)
        libs = glob.glob(os.path.join(directory_path, "*.a"))
        print("Merging libraries:\n\t%s" % "\n\t".join(libs), file=sys.stderr)
        execute(["libtool", "-static", "-o", out_lib_file_path] + libs)

    def create_universal_static_lib(self, directory_path, out_lib_file_path):
        libs = glob.glob(os.path.join(directory_path, "*.a"))
        lipocmd = ["lipo", "-create"]
        lipocmd.extend(libs)
        lipocmd.extend(["-o", out_lib_file_path])
        print("Creating universal library from:\n\t%s" % "\n\t".join(libs), file=sys.stderr)
        execute(lipocmd)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='The script builds OpenEXR static lib for iOS.')
    parser.add_argument('out_dir', help='folder to put built library')
    parser.add_argument('--configuration', dest='configuration', choices=["Debug", "Release"], required=True, help='Configuration to build')
    parser.add_argument('--enable-bitcode', default=True, dest='bitcode_enabled', action='store_true', help='enable bitcode (disabled by default)')
    parser.add_argument('--deployment_target', default="12.0", dest='deployment_target',help='Deployment target')
    args = parser.parse_args()

    b = Builder(args.configuration, args.bitcode_enabled, args.deployment_target)
    b.build(args.out_dir)
