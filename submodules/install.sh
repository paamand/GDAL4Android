#!/bin/sh
export NDK_ROOT=$1
export MIN_SDK_VERSION=$2
export APP_ROOT=$(pwd)

export GDALDIR=$APP_ROOT/../submodules/gdal/gdal
export PROJDIR=$APP_ROOT/../submodules/proj4
export BUILDDIR=$APP_ROOT/../submodules/build

######## ARM #########
$NDK_ROOT/build/tools/make-standalone-toolchain.sh --platform=android-$MIN_SDK_VERSION --install-dir=$BUILDDIR/toolchain-$MIN_SDK_VERSION-arm --stl=libc++ --force
export PATH=$BUILDDIR/toolchain-$MIN_SDK_VERSION-arm/bin:$PATH

### GDAL, ARM ###
cd $GDALDIR
CC="arm-linux-androideabi-clang" CXX="arm-linux-androideabi-clang++" CFLAGS="-mthumb" CXXFLAGS="-mthumb" LIBS="-lstdc++" ./configure --host=arm-linux-androideabi --with-libz=internal --prefix=$BUILDDIR/arm --with-threads
#--without-gif
make clean
make
make install
mkdir -p $APP_ROOT/src/main/jniLibs/armeabi-v7a
cp $BUILDDIR/arm/lib/libgdal.so $APP_ROOT/src/main/jniLibs/armeabi-v7a/
cp -a $BUILDDIR/arm/include $APP_ROOT/src/main/cpp/include

# SWIG, ARM
cd swig/java
# Delete GDALtest because it does not support Android
rm apps/GDALtest.java
make clean
make ANDROID=yes
#make install
# Make install may produce lint java error (ColorTable). The cmd below overrules it.
$GDALDIR/libtool --mode=install $GDALDIR/install-sh -c lib*jni.la $BUILDDIR/arm/lib
cp $BUILDDIR/arm/lib/lib*jni.so $APP_ROOT/src/main/jniLibs/armeabi-v7a/
cp gdal.jar $APP_ROOT/libs/
#cp -r org $APP_ROOT/src/main/java/
cp *_wrap.cpp $APP_ROOT/src/main/cpp/
cp *_wrap.c $APP_ROOT/src/main/cpp/

# PROJ.4, ARM
cd $PROJDIR
./autogen.sh
CC="arm-linux-androideabi-clang" CXX="arm-linux-androideabi-clang++" CFLAGS="-mthumb" CXXFLAGS="-mthumb" LIBS="-lstdc++" ./configure --host=arm-linux-androideabi --prefix=$BUILDDIR/arm
make clean
make
cd src
make install
cp $BUILDDIR/arm/lib/libproj.so $APP_ROOT/src/main/jniLibs/armeabi-v7a/

######### x86 ##########
$NDK_ROOT/build/tools/make-standalone-toolchain.sh --platform=android-$MIN_SDK_VERSION --install-dir=$BUILDDIR/toolchain-$MIN_SDK_VERSION-x86 --stl=libc++ --arch=x86 --force
export PATH=$BUILDDIR/toolchain-$MIN_SDK_VERSION-x86/bin:$PATH

# GDAL, x86
cd $GDALDIR
sed -i -e 's/std::to_string/to_string/g' ./ogr/ogrsf_frmts/cad/libopencad/dwg/r2000.cpp #Needed due to missing std::to_string support in x86 android (replaces)
CC="i686-linux-android-clang" CXX="i686-linux-android-clang++" LIBS="-lstdc++" ./configure --host=i686-linux-android --with-libz=internal --prefix=$BUILDDIR/x86 --with-threads
#--without-gif
make clean
make
make install
mkdir -p $APP_ROOT/src/main/jniLibs/x86/
cp $BUILDDIR/x86/lib/libgdal.so $APP_ROOT/src/main/jniLibs/x86/

# SWIG, x86
cd swig/java
make clean
make ANDROID=yes
#make install
$GDALDIR/libtool --mode=install $GDALDIR/install-sh -c lib*jni.la $BUILDDIR/x86/lib
cp $BUILDDIR/x86/lib/lib*jni.so $APP_ROOT/src/main/jniLibs/x86/

# PROJ.4, x86
cd $PROJDIR
./autogen.sh
CC="i686-linux-android-clang" CXX="i686-linux-android-clang++" LIBS="-lstdc++" ./configure --host=i686-linux-android --prefix=$BUILDDIR/x86
make clean
make
cd src
make install
cp $BUILDDIR/x86/lib/libproj.so $APP_ROOT/src/main/jniLibs/x86/