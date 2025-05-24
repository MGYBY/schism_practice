%Purpose: convert DWD wind (nc) to sflux for SCHISM
%Author: Johannes Pein (johannes.pein@uni-oldenburg.de)
%Date: Nov 2012
clear all; close all;
filename = 'uniform_2000-9-29_10-03.nc';
ncid=netcdf.open(filename,'NC_NOWRITE');

%read wnd data
vid1=netcdf.inqVarID(ncid,'lat'); %input var./array name
lat = netcdf.getVar(ncid, vid1); 

vid2=netcdf.inqVarID(ncid,'lon');
lon = netcdf.getVar(ncid, vid2); 
for i=1:length(lon)
  if(lon(i)>180)
      lon(i,1)=lon(i,1)-360;
  end    
end

vid3=netcdf.inqVarID(ncid,'time');
time = netcdf.getVar(ncid, vid3); 

vid4=netcdf.inqVarID(ncid,'u10');
uwind = netcdf.getVar(ncid, vid4); 

vid5=netcdf.inqVarID(ncid,'v10');
vwind = netcdf.getVar(ncid, vid5); 

vid6=netcdf.inqVarID(ncid,'sp');
press = netcdf.getVar(ncid, vid6); 

netcdf.close(ncid);

ntime=length(time);
dt=time(2)-time(1); %in sec
[X,Y] = meshgrid(lon,lat);
Y=flip(Y); % not sure why here

%define new netcdf file
ncid2=netcdf.create('sflux_air.nc','NC_CLOBBER');
lon_dim=netcdf.defDim(ncid2,'nx_grid',length(lon));
lat_dim=netcdf.defDim(ncid2,'ny_grid',length(lat));
time_dim=netcdf.defDim(ncid2,'time',ntime);

time_var=netcdf.defVar(ncid2,'time','float',time_dim);
lon_var=netcdf.defVar(ncid2,'lon','float',[lat_dim lon_dim]);
lat_var=netcdf.defVar(ncid2,'lat','float',[lat_dim lon_dim]);
press_var=netcdf.defVar(ncid2,'prmsl','float',[lat_dim lon_dim time_dim]);
u10_var=netcdf.defVar(ncid2,'uwind','float',[lat_dim lon_dim time_dim]);
v10_var=netcdf.defVar(ncid2,'vwind','float',[lat_dim lon_dim time_dim]);
stmp_var=netcdf.defVar(ncid2,'stmp','float',[lat_dim lon_dim time_dim]);
spfh_var=netcdf.defVar(ncid2,'spfh','float',[lat_dim lon_dim time_dim]);

%und jetzt noch attribute
netcdf.putAtt(ncid2,time_var,'long_name','Time');
netcdf.putAtt(ncid2,time_var,'standard_name','time');
netcdf.putAtt(ncid2,time_var,'units', 'days since 2000-09-29 00:00');
netcdf.putAtt(ncid2,time_var,'base_date',int32([2000 9 29 0]));

netcdf.putAtt(ncid2,lon_var,'long_name','Longitude');
netcdf.putAtt(ncid2,lon_var,'standard_name','longitude');
netcdf.putAtt(ncid2,lon_var,'units','degrees_east'); 

netcdf.putAtt(ncid2,lat_var,'long_name','Latitude');
netcdf.putAtt(ncid2,lat_var,'standard_name','latitude');
netcdf.putAtt(ncid2,lat_var,'units','degrees_north'); 

netcdf.putAtt(ncid2,press_var,'long_name','Pressure reduced to MSL');
netcdf.putAtt(ncid2,press_var,'standard_name','air_pressure_at_sea_level');
netcdf.putAtt(ncid2,press_var,'units','Pa');

netcdf.putAtt(ncid2,u10_var,'long_name','Surface Eastward Air Velocity');
netcdf.putAtt(ncid2,u10_var,'standard_name','eastward_wind');
netcdf.putAtt(ncid2,u10_var,'units','m/s');

netcdf.putAtt(ncid2,v10_var,'long_name','Surface Northward Air Velocity');
netcdf.putAtt(ncid2,v10_var,'standard_name','northward_wind');
netcdf.putAtt(ncid2,v10_var,'units','m/s');

netcdf.putAtt(ncid2,stmp_var,'long_name','Surface Air Temperature (2m AGL)');
netcdf.putAtt(ncid2,stmp_var,'standard_name','air_temperature');
netcdf.putAtt(ncid2,stmp_var,'units','Celsius');

netcdf.putAtt(ncid2,stmp_var,'long_name','Surface Specific Humidity (2m AGL)');
netcdf.putAtt(ncid2,stmp_var,'standard_name','specific_humidity');
netcdf.putAtt(ncid2,stmp_var,'units','1');

netcdf.endDef(ncid2);
%end define mode
%write data 
netcdf.putVar(ncid2,lon_var,X);
netcdf.putVar(ncid2,lat_var,Y);

tcount=0;
time2=0.;
for sl=1:ntime
%order is same as FORTRAN (reversed from ncdump), but 0 based
start=[0 0 tcount];
count=[length(lat) length(lon) 1];
press2=rot90(squeeze(100.0.*press(:,:,sl)));
% press2=(squeeze(press(:,:,sl)));
netcdf.putVar(ncid2,press_var,start,count,press2);
u10_2=rot90(squeeze(uwind(:,:,sl)));
% u10_2=(squeeze(uwind(:,:,sl)));
netcdf.putVar(ncid2,u10_var,start,count,u10_2);
v10_2=rot90(squeeze(vwind(:,:,sl)));
% v10_2=(squeeze(vwind(:,:,sl)));
netcdf.putVar(ncid2,v10_var,start,count,v10_2);
% t2_2=rot90(squeeze(t2(:,:,sl)));
% netcdf.putVar(ncid2,stmp_var,start,count,t2_2);
%    dev2_2=rot90(squeeze(dev2(:,:,sl)));
% spfh=single(1.e-2*ones(size(t2_2)));
% netcdf.putVar(ncid2,spfh_var,start,count,spfh);
netcdf.putVar(ncid2,time_var,tcount,1,single(time2/86400.));

tcount=tcount+1;
time2=time2+single(dt);
end %sl

netcdf.close(ncid2);