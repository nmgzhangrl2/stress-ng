#!/bin/bash
 
#ndk version must later than r19
NDK_ROOT="${1:-${ANDROID_NDK_HOME}}"
SHELL_PATH=$(pwd)
LOGIC_CPU=$(cat /proc/cpuinfo | grep "processor" | wc -l)
 
ANDROID_API_LEVEL=28
INSTALL_DIR="${SHELL_PATH}/install"
declare -a ANDROID_ABI_LIST=("arm64-v8a" "armeabi-v7a" "x86" "x86_64")
declare -a NDK_COMPILER_LIST=("aarch64-linux-android" "armv7a-linux-androideabi" "i686-linux-android" "x86_64-linux-android")
echo -e "\033[32mNDK_ROOT=${NDK_ROOT}\033[0m"
 
for i in {0..3}
do
        
    ANDROID_ABI=${ANDROID_ABI_LIST[i]}
    echo "Start building ${ANDROID_ABI} version"
 
    TEMP_INSTALL_DIR="${INSTALL_DIR}/android_${ANDROID_ABI}"
    rm -rf "${TEMP_INSTALL_DIR}"
    mkdir -p "${TEMP_INSTALL_DIR}"
 
        export CC=${NDK_ROOT}toolchains/llvm/prebuilt/linux-x86_64/bin/${NDK_COMPILER_LIST[i]}${ANDROID_API_LEVEL}-clang
        export CXX=${NDK_ROOT}toolchains/llvm/prebuilt/linux-x86_64/bin/${NDK_COMPILER_LIST[i]}${ANDROID_API_LEVEL}-clang++
    echo -e "\033[32mCC=${CC}\033[0m"
    echo -e "\033[32mCXX=${CXX}\033[0m"
        make clean
        make -j${LOGIC_CPU}
    make install DESTDIR=${TEMP_INSTALL_DIR}
    echo -e "\033[32m${ANDROID_ABI} make success\033[0m"
done
