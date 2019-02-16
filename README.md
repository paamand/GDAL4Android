# GDAL4Android
Building GDAL as a self-contained *.AAR for Android development.

# Requires
- UNIX OS
- libtool
- make
- ninja
- ant
- swig
- C++ compiler (g++ or clang should work)
- autoconf (installed by default on Linux, but not OSX)
- automake (installed by default on Linux, but not OSX)
- (It's possible I'm missing something, but this is all I found/can think of)

# How To...
Clone this repository (make sure to include the --recursive-modules flag!):  
     `git clone --recurse-submodules https://github.com/paamand/GDAL.git`

Install Android Studio: https://developer.android.com/studio/install
 - Be sure to install the 32-bit packages it needs if you're on Linux

Install Android SDKs:
 - *Android Studio* > *Tools* > *SDK Manager* OR *Android Studio Welcome Screen* > *Configure* > *SDK Manager*
     - SDK Platforms should have the latest Android API installed - currently 9.0(Pie)
     - SDK Tools should include:
         - Android SDK Build-Tools
         - LLDB
         - CMake
         - Android SDK Platform-Tools
         - Android SDK Tools
         - NDK

Get SDK/JDK locations and select the embedded JDK:
 - *Android Studio* > *File* > *Project Structure* OR *Android Studio Welcome Screen* > *Project Defaults* > *Project Structure*
     - Make sure that `Use embedded JDK` is checked
     - Write down or copy/paste the `JDK location` and the `Android SDK location`
         - For me, this was `/home/caleb/.local/share/JetBrains/Toolbox/apps/AndroidStudio/ch-0/182.5264788/jre` and `/home/caleb/Android/Sdk` respectively

### Build process
 - Open the project with Android Studio 3.0+ and select build variant 'install'. If this does not run the /submodules/install.sh installation script, jump to the section below.
 - Then build the normal debug/release types to create the .aar, to be found in: `GDAL/gdal/build/outputs/aar/`
#### If building in Android Studio fails
 - Open a terminal
     - Navigate to this repository (i.e., `cd ~/GDAL`)
     - Set these environment variables:
         - `JAVA_HOME=[Embedded JDK location] && export JAVA_HOME`
         - `ANDROID_HOME=[Android SDK location] && export ANDROID_HOME`
     - Run `./gradlew installFromSource`
         - This calls ./submodules/install.sh that creates standalone toolchains and cross-compiles the actual GDAL and PROJ.4 submodules. The compiled libraries are moved to relevant folders along with the wrapper headers etc:
         - If this fails, navigate to `GDAL/gdal` and enter the following:
             - `../submodules/install.sh "[Android NDK location]" "19" 2>&1 | tee gdal-install.log`
                 - If this also fails, please share the log file
             - The NDK location is usually $ANDROID_HOME/ndk-bundle
                - If not, it can be found in the `GDAL/local.properties` file
     - Run `./gradlew build`
         - This should produce the gdal-release.aar and gdal-debug.aar files in `GDAL/gdal/build/outputs/aar/`

The .aar files (gdal-release.aar and gdal-debug.aar) are self-contained with arm-v7s/x86 compiled libs and java wrappers and can be used directly on other projects. Clean AF.
