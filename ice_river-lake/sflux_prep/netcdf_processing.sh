cdo remapbil,./2019-11 ./humidity/2019-11 ./humidity/2019-11_remapped
cp ./humidity/2019-11_remapped .
cdo merge 2019-11 2019-11_remapped* 2019-11_merged.nc

cdo remapbil,./2019-12 ./humidity/2019-12 ./humidity/2019-12_remapped
cp ./humidity/2019-12_remapped .
cdo merge 2019-12 2019-12_remapped* 2019-12_merged.nc

cdo remapbil,./2020-1 ./humidity/2020-1 ./humidity/2020-1_remapped
cp ./humidity/2020-1_remapped .
cdo merge 2020-1 2020-1_remapped* 2020-1_merged.nc

cdo remapbil,./2020-2 ./humidity/2020-2 ./humidity/2020-2_remapped
cp ./humidity/2020-2_remapped .
cdo merge 2020-2 2020-2_remapped* 2020-2_merged.nc

cdo remapbil,./2020-3 ./humidity/2020-3 ./humidity/2020-3_remapped
cp ./humidity/2020-3_remapped .
cdo merge 2020-3 2020-3_remapped* 2020-3_merged.nc

cdo remapbil,./2020-4 ./humidity/2020-4 ./humidity/2020-4_remapped
cp ./humidity/2020-4_remapped .
cdo merge 2020-4 2020-4_remapped* 2020-4_merged.nc

cdo remapbil,./2020-5 ./humidity/2020-5 ./humidity/2020-5_remapped
cp ./humidity/2020-5_remapped .
cdo merge 2020-5 2020-5_remapped* 2020-5_merged.nc


rm ./*_remapped