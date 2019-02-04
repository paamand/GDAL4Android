# GDAL
Building GDAL as a *.JAR for android

# How TO...
Clone the project and open it with Android Studio 3.0+

Alternatively the project can be build from command line with gradlew (https://developer.android.com/studio/build/building-cmdline).

First build the special build type 'install', which calls ./submodules/install.sh that compiles the actual GDAL and PROJ.4 submodules. The compiled libraries are moved to relevant folders along with the wrapper headers etc. Then build the normal debug/release types to create the .aar.
