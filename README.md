# GDAL
Building GDAL as a *.AAR for android

# Requires
- Unix OS
- libtool
- other?

# How TO...
Clone the project, including submodules:

`git clone --recurse-submodules https://github.com/paamand/GDAL.git`

First build the special build type 'install', which calls ./submodules/install.sh that creates standalone toolchains and cross-compiles the actual GDAL and PROJ.4 submodules. The compiled libraries are moved to relevant folders along with the wrapper headers etc:
- Open the project with Android Studio 3.0+ and select build variant 'install'. If this does not run the /submodules/install.sh installation script call it manually through
`cd GDAL
gradlew installFromSource`
(https://developer.android.com/studio/build/building-cmdline).

Then build the normal debug/release types to create the .aar, to be found in:
`GDAL/gdal/build/outputs/aar/`

The .aar files (gdal-release.aar and gdal-debug.aar) are self-contained with arm-v7s/x86 compiled libs and java wrappers and can be used directly on other projects. Clean AF.
