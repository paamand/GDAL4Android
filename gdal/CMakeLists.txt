# For more information about using CMake with Android Studio, read the
# documentation: https://d.android.com/studio/projects/add-native-code.html

# Sets the minimum version of CMake required to build the native library.

cmake_minimum_required(VERSION 3.4.1)

add_library( gdalwrap SHARED src/main/cpp/gdal_wrap.cpp )
#add_library( osrwrap SHARED src/main/cpp/osr_wrap.cpp )
#add_library( ogrwrap SHARED src/main/cpp/ogr_wrap.cpp )
#add_library( gdalconstwrap SHARED src/main/cpp/gdalconst_wrap.cpp )

include_directories( src/main/cpp/include )

# Include GDAL shared lib
# Example: https://developer.android.com/studio/projects/configure-cmake.html
add_library(gdal SHARED IMPORTED)
set_target_properties( gdal PROPERTIES IMPORTED_LOCATION
                       ${PROJECT_SOURCE_DIR}/src/main/jniLibs/${ANDROID_ABI}/libgdal.so)

# LINK
target_link_libraries(gdalwrap gdal)
#target_link_libraries(osrwrap gdal)
#target_link_libraries(ogrwrap gdal)
#target_link_libraries(gdalconstwrap gdal)