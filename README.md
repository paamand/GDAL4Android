# GDAL
Building GDAL as a *.JAR for android

# Requires
- libtool
- other?

# How TO...
Clone the project, including submodules:

`git clone --recurse-submodules https://github.com/paamand/GDAL.git`

Then open it with Android Studio 3.0+ and select build variant 'install'.

If gradle sync fails, comment out line 18-24 of GDAL/gdal/gdal.gradle and retry.

Alternatively the project can be build from command line with gradlew (https://developer.android.com/studio/build/building-cmdline).

First build the special build type 'install', which calls ./submodules/install.sh that compiles the actual GDAL and PROJ.4 submodules. The compiled libraries are moved to relevant folders along with the wrapper headers etc. Then build the normal debug/release types to create the .aar.
