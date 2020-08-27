#MIT License
#
#Copyright (c) 2020 International Business Machines
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

#!/bin/sh
set -x
log_file="setup.log"

echo " — — — — — — — — — — Building Dependencies Script Started — — — — — — — — — — " | tee -a "$log_file"

MIN_IOS="10.0"
MIN_WATCHOS="2.0"
MIN_TVOS=$MIN_IOS
MIN_MACOS="10.10"
IPHONEOS=iphoneos
IPHONESIMULATOR=iphonesimulator
WATCHOS=watchos
WATCHSIMULATOR=watchsimulator
TVOS=appletvos
TVSIMULATOR=appletvsimulator
MACOS=macosx
LOGICALCPU_MAX=`sysctl -n hw.logicalcpu_max`


PLATFORM=macosx
ARCH="x86_64"

SDK=`xcrun --sdk $PLATFORM --show-sdk-path`
PLATFORM_PATH=`xcrun --sdk $PLATFORM --show-sdk-platform-path`
CLANG=`xcrun --sdk $PLATFORM --find clang`
CMAKE_C_COMPILER="${CLANG}"
CLANGXX=`xcrun --sdk $PLATFORM --find clang++`
CMAKE_CXX_COMPILER="${CLANGXX}"
CURRENT_DIR=`pwd`
DEVELOPER=`xcode-select --print-path`

CMAKE_PATH=$(dirname `which cmake`)

export PATH="${CMAKE_PATH}:${PLATFORM_PATH}/Developer/usr/bin:${DEVELOPER}/usr/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

GMP_DIR="`pwd`/gmp"
NTL_VERSION="11.4.1"
GMP_VERSION="6.1.2"
BOOST_VERSION="1_72_0"
HDF5_VERSION="1-12-0"

check_cmake() 
{
    install_cmake()
    {
        echo "installing cmake"
        curl -OL https://github.com/Kitware/CMake/releases/download/v3.17.1/cmake-3.17.1-Darwin-x86_64.tar.gz
        tar -xzf cmake-3.17.1-Darwin-x86_64.tar.gz
        sudo mv cmake-3.17.1-Darwin-x86_64/CMake.app /Applications
        sudo /Applications/CMake.app/Contents/bin/cmake-gui --install

    }

    if hash cmake 2>/dev/null; then
        echo "CMAKE is present on this system so skipping install."
    else
        #we have to install cmake
        echo "no CMAKE Found.  Installing now..."
        install_cmake
    fi
}

version_min_flag()
{
    PLATFORM=$1
    FLAG=""
    if [[ $PLATFORM = $IPHONEOS ]]; then
        FLAG="-miphoneos-version-min=${MIN_IOS}"
    elif [[ $PLATFORM = $IPHONESIMULATOR ]]; then
        FLAG="-mios-simulator-version-min=${MIN_IOS}"
    elif [[ $PLATFORM = $WATCHOS ]]; then
        FLAG="-mwatchos-version-min=${MIN_WATCHOS}"
    elif [[ $PLATFORM = $WATCHSIMULATOR ]]; then
        FLAG="-mwatchos-simulator-version-min=${MIN_WATCHOS}"
    elif [[ $PLATFORM = $TVOS ]]; then
        FLAG="-mtvos-version-min=${MIN_TVOS}"
    elif [[ $PLATFORM = $TVSIMULATOR ]]; then
        FLAG="-mtvos-simulator-version-min=${MIN_TVOS}"
    elif [[ $PLATFORM = $MACOS ]]; then
        FLAG="-mmacosx-version-min=${MIN_MACOS}"
    fi
    echo $FLAG
}

build_boost() 
{
     #hardcoding the version because they want to specifically use the 1.72.0 release
    download_boost()
    {
        CURRENT_DIR=`pwd`
        if [ ! -s ${CURRENT_DIR}/boost_1_72_0.tar.gz ]; then
            curl -k -L -o ${CURRENT_DIR}/boost_1_72_0.tar.gz "https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.gz"
        fi
        tar xvzf "boost_${BOOST_VERSION}.tar.gz"
    }
    download_boost

    CURRENT_DIR=`pwd`
    cd boost_1_72_0
    ./bootstrap.sh --without-libraries=python --prefix=${CURRENT_DIR}
    ./b2 install
    cd ../
}

build_hdf5() 
{
    download_hdf5() 
    {
        CURRENT_DIR=`pwd`
        if [ ! -s ${CURRENT_DIR}/cmake-hdf5-${HDF5_VERSION}.tar.gz ]; then
            curl -k -L -o ${CURRENT_DIR}/cmake-hdf5-${HDF5_VERSION}.tar.gz "https://www.hdfgroup.org/package/cmake-hdf5-${HDF5_VERSION}-tar-gz/?wpdmdl=14580&refresh=5f19d44b903561595528267"
        fi
        tar xvzf "cmake-hdf5-1-12-0.tar.gz"
    }
    download_hdf5

    CURRENT_DIR=`pwd`
    mkdir hdf5-1.12.0
    cd hdf5-1.12.0
    cmake -G "Xcode" -DCMAKE_BUILD_TYPE:STRING=Release -DBUILD_SHARED_LIBS:BOOL=OFF -DBUILD_TESTING:BOOL=OFF -DHDF5_BUILD_TOOLS:BOOL=ON ../CMake-hdf5-1.12.0/hdf5-1.12.0
    touch H5lib_settings.c
    touch H5Tinit.c
    cd ../
    
}

build_all()
{
    SUFFIX=$1
    BUILD_IN=$2
    
    build_hdf5
    build_boost
    cd ../
    xcodebuild clean
}

check_cmake | tee -a "$log_file"
build_all | tee -a "$log_file"

echo " — — — — — — — — — — Building Dependencies Script Ended — — — — — — — — — — " | tee -a "$log_file"

