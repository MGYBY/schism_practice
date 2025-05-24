# schism_practice
Some Schism sim codes.

Cmake command: `cmake -C  ../cmake/SCHISM.local.build -C ../cmake/SCHISM.local.myown ../src -DNetCDF_Fortran_LIBRARY=$(nc-config --libdir)/libnetcdff.so -DNetCDF_C_LIBRARY=$(nc-config --libdir)/libnetcdf.so -DNetCDF_INCLUDE_DIR=$(nc-config --includedir) -DOLDIO=false -DUSE_WWM=true -DUSE_WW3=true  -DCMAKE_Fortran_FLAGS_RELEASE="-O2 -ffree-line-length-none -fallow-argument-mismatch"`. (**does not seem to pass the benchmark test**)

or follow the documentation: `cmake -C ../cmake/SCHISM.local.build -C ../cmake/SCHISM.local.myown ../src/ -DCMAKE_Fortran_FLAGS="-fallow-argument-mismatch"`

Wave setup in WWM: `cmake -C ../cmake/SCHISM.local.build -C ../cmake/SCHISM.local.myown ../src/ -DCMAKE_Fortran_FLAGS="-fallow-argument-mismatch -DWWM_SETUP=1"` (also need to modify L513 of `wwm_wave_setup.F90`).

`make -j8 pschism`
