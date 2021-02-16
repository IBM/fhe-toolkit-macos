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

#Load in version Vars from the ConfigConstants file
source ConfigConstants.xcconfig

change_submodules() 
{
    git submodule update --init --recursive
}

check_cmake() 
{
    install_cmake()
    {
        echo "installing cmake"
        curl -OL https://github.com/Kitware/CMake/releases/download/v3.19.2/cmake-3.19.2-macos-universal.tar.gz
        tar -xzf cmake-3.19.2-macos-universal.tar.gz 
        sudo mv cmake-3.19.2-macos-universal/CMake.app /Applications 
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
prepare()
{
    download_gmp()
    {
        CURRENT_DIR=`pwd`
        if [ ! -s ${CURRENT_DIR}/gmp-${GMP_VERSION}.tar.bz2 ]; then
            curl -k -L -o ${CURRENT_DIR}/gmp-${GMP_VERSION}.tar.bz2 https://gmplib.org/download/gmp/gmp-${GMP_VERSION}.tar.bz2
        fi
        rm -rf gmp
        tar xfj "gmp-${GMP_VERSION}.tar.bz2"
        mv gmp-${GMP_VERSION} gmp
    }
    download_ntl()
    {
        CURRENT_DIR=`pwd`
        if [ ! -s ${CURRENT_DIR}/ntl-${NTL_VERSION}.tar.gz ]; then
            curl -k -L -o ${CURRENT_DIR}/ntl-${NTL_VERSION}.tar https://www.shoup.net/ntl/ntl-${NTL_VERSION}.tar.gz
        fi
        tar xvf "ntl-${NTL_VERSION}.tar"
    }
    download_ntl
    download_gmp
}

build_gmp()
{
   
     cd gmp
    PLATFORM=$1
    ARCH=$2
    SDK=`xcrun --sdk $PLATFORM --show-sdk-path`
    PLATFORM_PATH=`xcrun --sdk $PLATFORM --show-sdk-platform-path`
    CLANG=`xcrun --sdk $PLATFORM --find clang`
    CURRENT_DIR=`pwd`
    DEVELOPER=`xcode-select --print-path`
    #export PATH="${PLATFORM_PATH}/Developer/usr/bin:${DEVELOPER}/usr/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    mkdir "${CURRENT_DIR}/../gmplib-so-${PLATFORM}-${ARCH}"
    CFLAGS="-arch ${ARCH} --sysroot=${SDK}"
    EXTRA_FLAGS="$(version_min_flag $PLATFORM)"
    CCARGS="${CLANG} ${CFLAGS}"
    CPPFLAGSARGS="${CFLAGS} ${EXTRA_FLAGS}"
    #CONFIGURESCRIPT="gmp_configure_script.sh"
    #cat >"$CONFIGURESCRIPT" << EOF

    ./configure CC="$CCARGS" CPPFLAGS="$CPPFLAGSARGS" --host=${ARCH}-apple-darwin --disable-assembly --prefix="${CURRENT_DIR}/../gmplib-so-${PLATFORM}-${ARCH}"

    make -j $LOGICALCPU_MAX &> "${CURRENT_DIR}/gmplib-so-${PLATFORM}-${ARCH}-build.log"
    make install &> "${CURRENT_DIR}/gmplib-so-${PLATFORM}-${ARCH}-install.log"
    #rm "${CURRENT_DIR}/../gmplib-so-${PLATFORM}-${ARCH}/lib/libgmp.10.dylib"
    rm "${CURRENT_DIR}/../gmp-${GMP_VERSION}.tar.bz2"
    cd ../
}

build_ntl()
{
    PLATFORM=$1
    ARCH=$2
    CURRENT_DIR=`pwd`
    SDK=`xcrun --sdk $PLATFORM --show-sdk-path`
    
    mkdir ntl
    mkdir ntl/libs
    cd ntl-${NTL_VERSION}
    cd src

    ./configure CXX=clang++ CXXFLAGS="-stdlib=libc++  -arch ${ARCH} -isysroot ${SDK}"  NTL_THREADS=on NATIVE=on TUNE=x86 SHARED=off NTL_GMP_LIP=on PREFIX="${CURRENT_DIR}/ntl" GMP_PREFIX="${CURRENT_DIR}/gmplib-so-${PLATFORM}-${ARCH}"
    make -j
    
    cp -R "${CURRENT_DIR}/ntl-${NTL_VERSION}/include" "${CURRENT_DIR}/ntl/include" 
    cp "${CURRENT_DIR}/ntl-${NTL_VERSION}/src/ntl.a" "${CURRENT_DIR}/ntl/libs/ntl.a"
    rm "${CURRENT_DIR}/ntl-${NTL_VERSION}.tar"
    cd ../../
}

build_helib() 
{
    PLATFORM=$1
    ARCH=$2
    CURRENT_DIR=`pwd`
    DEPEND_DIR="${CURRENT_DIR}"
    cp "${CURRENT_DIR}/Helib_install/CMakeLists.txt" "${CURRENT_DIR}/HElib"
    cd "${CURRENT_DIR}/HElib"
    cmake -S. -B../HElib_macOS -GXcode \
    -DCMAKE_SYSTEM_NAME=Darwin \
    "-DCMAKE_OSX_ARCHITECTURES=arm64;x86_64" \
    -DCMAKE_OSX_DEPLOYMENT_TARGET=10.14 \
    -DCMAKE_INSTALL_PREFIX=`pwd`/_install \
    -DCMAKE_XCODE_ATTRIBUTE_ONLY_ACTIVE_ARCH=NO \
    -DCMAKE_IOS_INSTALL_COMBINED=YES \
    -DHELIB_DEPENDENCIES_DIR="${DEPEND_DIR}/HElib/dependencies" \
    -DGMP_DIR="${DEPEND_DIR}/gmp" \
    -DNTL_INCLUDE_PATHS="${DEPEND_DIR}/ntl/include" \
    -DNTL_LIB="${DEPEND_DIR}/ntl/libs/ntl.a" \
    -DNTL_DIR="${DEPEND_DIR}/ntl/include"
    cd ../
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
    cmake -G "Xcode" -DCMAKE_OSX_ARCHITECTURES="x86_64" -DCMAKE_BUILD_TYPE:STRING=Release -DBUILD_SHARED_LIBS:BOOL=OFF -DBUILD_TESTING:BOOL=OFF -DHDF5_BUILD_TOOLS:BOOL=ON ../CMake-hdf5-1.12.0/hdf5-1.12.0
    CURRENT_DIR=`pwd`
    xcodebuild -target hdf5-static
    cd ../
}

build_all()
{
    SUFFIX=$1
    BUILD_IN=$2
    
    build_gmp "${MACOS}" "x86_64"
    build_ntl "${MACOS}" "x86_64"
    build_helib "${MACOS}" "x86_64"
    build_hdf5
    build_boost
    cd ../
    xcodebuild clean
}

change_submodules | tee -a "$log_file"
check_cmake | tee -a "$log_file"
prepare | tee -a "$log_file"
build_all | tee -a "$log_file"

echo " — — — — — — — — — — Building Dependencies Script Ended — — — — — — — — — — " | tee -a "$log_file"

