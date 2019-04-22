#!/bin/bash
export NDK_ROOT=$1
export MIN_SDK_VERSION=$2
export APP_ROOT=$(pwd)
export HOST_TAG=linux-x86_64
export GDALDIR=$APP_ROOT/../submodules/gdal/gdal
export PROJDIR=$APP_ROOT/../submodules/proj4
export BUILDDIR=$APP_ROOT/../submodules/build

# https://developer.android.com/ndk/guides/other_build_systems
# https://developer.android.com/ndk/guides/standalone_toolchain
# https://developer.android.com/ndk/guides/abis

#echo "APP_ROOT" $APP_ROOT
cd $GDALDIR

# Mods to GDAL for Android compatibility
rm swig/java/apps/GDALtest.java # GDALtest.java did not support Android

export TOOLCHAIN=$NDK_ROOT/toolchains/llvm/prebuilt/$HOST_TAG

ABIs=("x86" "x86_64" "armeabi-v7a" "arm64-v8a")
TRIPLEs=("i686-linux-android" "x86_64-linux-android" "armv7a-linux-androideabi" "aarch64-linux-android")
for i in 0 1 2 3 # For each ABI
do
    export ABI=${ABIs[$i]}
    export TRIPLE=${TRIPLEs[$i]}

    export CFLAGS=""
    export CXXFLAGS="-stdlib=libc++"
    #export LDFLAGS="-stdlib=libc++" #"-static-libstdc++"
    #export LIBS="-lstdc++"

    export AR=$TOOLCHAIN/bin/$TRIPLE-ar
    export AS=$TOOLCHAIN/bin/$TRIPLE-as
    export LD=$TOOLCHAIN/bin/$TRIPLE-ld
    #export STRIP=$TOOLCHAIN/bin/$TRIPLE-strip
    export CC=$TOOLCHAIN/bin/$TRIPLE$MIN_SDK_VERSION-clang
    export CXX=$TOOLCHAIN/bin/$TRIPLE$MIN_SDK_VERSION-clang++

    if [ $ABI = "armeabi-v7a" ] # For 32-bit ARM, the compiler is prefixed with armv7a-linux-androideabi, but the binutils tools are prefixed with arm-linux-androideabi.
    then
        export AR=$TOOLCHAIN/bin/arm-linux-androideabi-ar
        export AS=$TOOLCHAIN/bin/arm-linux-androideabi-as
        export LD=$TOOLCHAIN/bin/arm-linux-androideabi-ld
        #export STRIP=$TOOLCHAIN/bin/arm-linux-androideabi-strip
        export CFLAGS="-mthumb"
        export CXXFLAGS="-mthumb"
    fi

    #if [ $ABI = "arm64-v8a" ] # For some reason
        #export LIBS=""
        #Enable AR, AS, LD, STRIP

    echo "######### " $ABI ":" $TRIPLE " ##########"

    # GDAL
    cd $GDALDIR
    make clean
    ./configure --host=$TRIPLE --with-libz=internal --with-curl=no --with-xml2=no --with-cpp14 --prefix=$BUILDDIR/$ABI
    #./configure --host=$TRIPLE --with-libz=internal --with-cpp14 --prefix=$BUILDDIR/$ABI
    make
    make install
    mkdir -p $APP_ROOT/src/main/jniLibs/$ABI/
    cp $BUILDDIR/$ABI/lib/libgdal.so $APP_ROOT/src/main/jniLibs/$ABI/

    # SWIG
    cd swig/java
    make clean
    make ANDROID=yes
    # Make install may produce lint java error (ColorTable). The cmd below overrules it.
    #make install
    $GDALDIR/libtool --mode=install $GDALDIR/install-sh -c lib*jni.la $BUILDDIR/$ABI/lib
    cp $BUILDDIR/$ABI/lib/lib*jni.so $APP_ROOT/src/main/jniLibs/$ABI/

    #PROJ.4
    cd $PROJDIR
    ./autogen.sh
    ./configure --host=$TRIPLE --prefix=$BUILDDIR/$ABI
    make clean
    make
    cd src
    make install
    cp $BUILDDIR/$ABI/lib/libproj.so $APP_ROOT/src/main/jniLibs/$ABI/
done

mkdir $APP_ROOT/src/main/cpp
cp -a $BUILDDIR/$ABI/include $APP_ROOT/src/main/cpp/include

cd $GDALDIR/swig/java
mkdir $APP_ROOT/libs
cp gdal.jar $APP_ROOT/libs/
#cp -r org $APP_ROOT/src/main/java/
cp *_wrap.cpp $APP_ROOT/src/main/cpp/
cp *_wrap.c $APP_ROOT/src/main/cpp/
