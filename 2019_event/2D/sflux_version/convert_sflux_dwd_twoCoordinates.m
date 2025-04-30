%Purpose: convert DWD wind (nc) to sflux for SCHISM
%Author: Johannes Pein (johannes.pein@uni-oldenburg.de)
%Date: Nov 2012
clear all; close all;
filename = '2023-12-16_2024-2-29.nc';
ncid=netcdf.open(filename,'NC_NOWRITE');

%read wnd data
vid1=netcdf.inqVarID(ncid,'latitude'); %input var./array name
lat = netcdf.getVar(ncid, vid1); 

vid2=netcdf.inqVarID(ncid,'longitude');
lon = netcdf.getVar(ncid, vid2); 
for i=1:length(lon)
  if(lon(i)>180)
      lon(i,1)=lon(i,1)-360;
  end    
end

vid3=netcdf.inqVarID(ncid,'valid_time');
time = netcdf.getVar(ncid, vid3); 

vid4=netcdf.inqVarID(ncid,'u10');
uwind = netcdf.getVar(ncid, vid4); 

vid5=netcdf.inqVarID(ncid,'v10');
vwind = netcdf.getVar(ncid, vid5); 

vid6=netcdf.inqVarID(ncid,'sp');
press = netcdf.getVar(ncid, vid6); 

vid7=netcdf.inqVarID(ncid,'ssrd');
ssrd = netcdf.getVar(ncid, vid7); 

vid8=netcdf.inqVarID(ncid,'strd');
strd = netcdf.getVar(ncid, vid8); 

vid9=netcdf.inqVarID(ncid,'t2m');
t2m = netcdf.getVar(ncid, vid9);

netcdf.close(ncid);

ntime=length(time);
dt=time(2)-time(1); %in sec
[X,Y] = meshgrid(lon,lat);
for i=1:length(lon)
  for j=1:length(lat)
     lon_x(i,j)=lon(i,1);
     lat_y(i,j)=lat(j,1);
  end    
end 

[n1]=size(lat); 
[n2]=size(lon); 
[n3]=size(time); 
nn1 = length(lon);
nn2 = length(lat);

% read specific humidity file
ncid2=netcdf.open('sh_merge.nc','NC_NOWRITE');
vid11=netcdf.inqVarID(ncid,'latitude'); %input var./array name
lat = netcdf.getVar(ncid, vid11); 
vid22=netcdf.inqVarID(ncid,'longitude');
lon = netcdf.getVar(ncid, vid22); 
for i=1:length(lon)
  if(lon(i)>180)
      lon(i,1)=lon(i,1)-360;
  end    
end
vid33=netcdf.inqVarID(ncid,'valid_time');
sh_time = netcdf.getVar(ncid, vid33); 
lonp_x=zeros(length(lon),length(lat));
latp_y=zeros(length(lon),length(lat));
sh_org=zeros(length(lon)*length(lat),3);
for i=1:length(lon)
  for j=1:length(lat)
     lonp_x(i,j)=lon(i,1);
     latp_y(i,j)=lat(j,1);
  end    
end 
%convert specific humidity grid to wind field grid (interpolation)
n=0;
for i=1:length(lon)
  for j=1:length(lat)
   n=n+1;   
   sh_org(n,1)=lonp_x(i,j);
   sh_org(n,2)=latp_y(i,j);
  end    
end
sh=zeros(n2(1,1), n1(1,1),length(sh_time));
for ii=1:length(time)
  n=0;
  for i=1:length(lon)
    for j=1:length(lat)
     n=n+1;   
     sh_org(n,3)=sh(i,j,ii);
    end    
  end 
  disp(strcat('time: ',num2str(ii)));
  F = TriScatteredInterp(sh_org(:,1),sh_org(:,2),sh_org(:,3));
  % prmsl_w = F(X,Y);
  prmsl_w = F(lon_x,lat_y);
  sh(:,:,ii)=prmsl_w;
end

%%%%%%%%%% %%%%%%%%%% %%%%%%%%%%
%define new netcdf file
ncid3=netcdf.create('sflux_air_1.0001.nc','NC_CLOBBER');
lon_dim=netcdf.defDim(ncid3,'nx_grid',nn1); 
lat_dim=netcdf.defDim(ncid3,'ny_grid',nn2); 
time_dim=netcdf.defDim(ncid3,'time',ntime);

time_var=netcdf.defVar(ncid3,'time','float',time_dim);
lon_var=netcdf.defVar(ncid3,'lon','float',[lat_dim lon_dim]);
lat_var=netcdf.defVar(ncid3,'lat','float',[lat_dim lon_dim]);
press_var=netcdf.defVar(ncid3,'prmsl','float',[lat_dim lon_dim time_dim]);
u10_var=netcdf.defVar(ncid3,'uwind','float',[lat_dim lon_dim time_dim]);
v10_var=netcdf.defVar(ncid3,'vwind','float',[lat_dim lon_dim time_dim]);
stmp_var=netcdf.defVar(ncid3,'stmp','float',[lat_dim lon_dim time_dim]); % temperature
spfh_var=netcdf.defVar(ncid3,'spfh','float',[lat_dim lon_dim time_dim]); % specific humidity
dlwrf_var=netcdf.defVar(ncid3,'dlwrf','float',[lat_dim lon_dim time_dim]); % Downward long-wave rad. flux
dswrf_var=netcdf.defVar(ncid3,'dswrf','float',[lat_dim lon_dim time_dim]); % Downward short-wave radiation flux
prate_var=netcdf.defVar(ncid3,'prate','float',[lat_dim lon_dim time_dim]);
srate_var=netcdf.defVar(ncid3,'srate','float',[lat_dim lon_dim time_dim]);

%und jetzt noch attribute
netcdf.putAtt(ncid3,time_var,'long_name','Time');
netcdf.putAtt(ncid3,time_var,'standard_name','time');
netcdf.putAtt(ncid3,time_var,'units', 'days since 2023-12-16 00:00');
netcdf.putAtt(ncid3,time_var,'base_date',int32([2023 12 16 0]));

netcdf.putAtt(ncid3,lon_var,'long_name','Longitude');
netcdf.putAtt(ncid3,lon_var,'standard_name','longitude');
netcdf.putAtt(ncid3,lon_var,'units','degrees_east'); 

netcdf.putAtt(ncid3,lat_var,'long_name','Latitude');
netcdf.putAtt(ncid3,lat_var,'standard_name','latitude');
netcdf.putAtt(ncid3,lat_var,'units','degrees_north'); 

netcdf.putAtt(ncid3,press_var,'long_name','Pressure reduced to MSL');
netcdf.putAtt(ncid3,press_var,'standard_name','air_pressure_at_sea_level');
netcdf.putAtt(ncid3,press_var,'units','Pa');

netcdf.putAtt(ncid3,u10_var,'long_name','Surface Eastward Air Velocity');
netcdf.putAtt(ncid3,u10_var,'standard_name','eastward_wind');
netcdf.putAtt(ncid3,u10_var,'units','m/s');

netcdf.putAtt(ncid3,v10_var,'long_name','Surface Northward Air Velocity');
netcdf.putAtt(ncid3,v10_var,'standard_name','northward_wind');
netcdf.putAtt(ncid3,v10_var,'units','m/s');

netcdf.putAtt(ncid3,stmp_var,'long_name','Surface Air Temperature (2m AGL)');
netcdf.putAtt(ncid3,stmp_var,'standard_name','air_temperature');
netcdf.putAtt(ncid3,stmp_var,'units','Celsius');

netcdf.putAtt(ncid3,spfh_var,'long_name','Surface Specific Humidity (2m AGL)');
netcdf.putAtt(ncid3,spfh_var,'standard_name','specific_humidity');
netcdf.putAtt(ncid3,spfh_var,'units','1');

netcdf.putAtt(ncid3,dlwrf_var,'long_name','Downward long-wave rad. flux');
netcdf.putAtt(ncid3,dlwrf_var,'standard_name','dlwrf');
netcdf.putAtt(ncid3,dlwrf_var,'units','W m-2');

netcdf.putAtt(ncid3,dswrf_var,'long_name','Downward short-wave radiation flux');
netcdf.putAtt(ncid3,dswrf_var,'standard_name','dswrf');
netcdf.putAtt(ncid3,dswrf_var,'units','W m-2');

netcdf.putAtt(ncid3,prate_var,'long_name','Precipitation rate');
netcdf.putAtt(ncid3,prate_var,'standard_name','prate');
netcdf.putAtt(ncid3,prate_var,'units','kg m-2 s-1');

netcdf.putAtt(ncid3,srate_var,'long_name','Snow precipitation rate');
netcdf.putAtt(ncid3,srate_var,'standard_name','srate');
netcdf.putAtt(ncid3,srate_var,'units','kg m-2 s-1');

netcdf.endDef(ncid3);
%end define mode
%write data 
netcdf.putVar(ncid3,lon_var,X);
netcdf.putVar(ncid3,lat_var,Y);

tcount=0;
time2=0.;
for sl=1:ntime
    %order is same as FORTRAN (reversed from ncdump), but 0 based
    start=[0 0 tcount];
    count=[nn2 nn1 1];
    press2=rot90(squeeze(press(:,:,sl)));
    netcdf.putVar(ncid3,press_var,start,count,press2);
    u10_2=rot90(squeeze(uwind(:,:,sl)));
    netcdf.putVar(ncid3,u10_var,start,count,u10_2);
    v10_2=rot90(squeeze(vwind(:,:,sl)));
    netcdf.putVar(ncid3,v10_var,start,count,v10_2);
    t2_2=rot90(squeeze(t2m(:,:,sl)));
    netcdf.putVar(ncid3,stmp_var,start,count,t2_2);
    sh_2=rot90(squeeze(sh(:,:,sl)));
    netcdf.putVar(ncid3,spfh_var,start,count,sh_2);
    dlwrf_2=rot90(squeeze(strd(:,:,sl)));
    netcdf.putVar(ncid3,dlwrf_var,start,count,dlwrf_2);
    dswrf_2=rot90(squeeze(ssrd(:,:,sl)));
    netcdf.putVar(ncid3,dswrf_var,start,count,dswrf_2);
    prate_2=rot90(squeeze(0.0*ones(size(ssrd(:,:,sl)))));
    netcdf.putVar(ncid3,prate_var,start,count,prate_2);
    srate_2=rot90(squeeze(0.0*ones(size(ssrd(:,:,sl)))));
    netcdf.putVar(ncid3,srate_var,start,count,srate_2);
    
    netcdf.putVar(ncid3,time_var,tcount,1,single(time2/86400.));
    
    tcount=tcount+1;
    time2=time2+single(dt);
end %sl

netcdf.close(ncid3);