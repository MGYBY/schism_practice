# schism_practice
Some Schism sim codes.

Cmake command: `cmake -C  ../cmake/SCHISM.local.build -C ../cmake/SCHISM.local.myown ../src -DNetCDF_Fortran_LIBRARY=$(nc-config --libdir)/libnetcdff.so -DNetCDF_C_LIBRARY=$(nc-config --libdir)/libnetcdf.so -DNetCDF_INCLUDE_DIR=$(nc-config --includedir) -DOLDIO=false -DUSE_WWM=true -DUSE_WW3=true  -DCMAKE_Fortran_FLAGS_RELEASE="-O2 -ffree-line-length-none -fallow-argument-mismatch"`.
