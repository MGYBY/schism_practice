%Read SCHISM nc outputs to compare with vis6
clear all; close all;

ax=[-80.0 -75.5 43 44.4]; %axis appearance

xcenter=(ax(1)+ax(2))/2;
ycenter=(ax(3)+ax(4))/2;

%Test post-comb
if(1==1)
  ncid0 = netcdf.open('./wwm_hist_0001.nc','NC_NOWRITE');
  dimid = netcdf.inqDimID(ncid0,'mnp');
  [~,np] = netcdf.inqDim(ncid0,dimid);
  % dimid = netcdf.inqDimID(ncid0,'nSCHISM_vgrid_layers');
  dimid = 2;
  [~,nvrt] = netcdf.inqDim(ncid0,dimid);
  vid=netcdf.inqVarID(ncid0,'ocean_time'); 
  time=double(netcdf.getVar(ncid0, vid));
  ntime=length(time);
  vid=netcdf.inqVarID(ncid0,'ele'); 
  nm = double(netcdf.getVar(ncid0, vid)); %(4,ne)
  nm = nm';
  nm =  horzcat(nm, -1.*ones(size(nm,1),1));
  % vid=netcdf.inqVarID(ncid0,'hvel'); %(2,nvrt,np,ntime)
  % %Warning: start in getVaR follows C convention and starts from 0!
  % uv=double(netcdf.getVar(ncid0, vid,[0 nvrt-1 0 ntime-1],[2 1 np 1]));
  vid=netcdf.inqVarID(ncid0,'HS'); %(nvrt,np,ntime)
  % S=double(netcdf.getVar(ncid0, vid,[nvrt-1 0 ntime-1],[1 np 1]));
  S=double(netcdf.getVar(ncid0, vid));
  % vid=netcdf.inqVarID(ncid0,'temp'); 
  % T=double(netcdf.getVar(ncid0, vid,[nvrt-1 0 ntime-1],[1 np 1]));
  %Deal with junks
  % uv(find(abs(uv)>1.e10))=nan;
  % T(find(abs(uv)>1.e10))=nan;
  % S(find(abs(uv)>1.e10))=nan;

  vid=netcdf.inqVarID(ncid0,'lon'); 
  x=double(netcdf.getVar(ncid0, vid));
  vid=netcdf.inqVarID(ncid0,'lat'); 
  y=double(netcdf.getVar(ncid0, vid));
  % vid=netcdf.inqVarID(ncid0,'SCHISM_hgrid_edge_x'); 
  % xcj=double(netcdf.getVar(ncid0, vid));
  % vid=netcdf.inqVarID(ncid0,'SCHISM_hgrid_edge_y'); 
  % ycj=double(netcdf.getVar(ncid0, vid));
%  vid=netcdf.inqVarID(ncid0,'dahv'); 
%  dahv=double(netcdf.getVar(ncid0, vid));
%  vid=netcdf.inqVarID(ncid0,'hvel_side'); 
%  suv=double(netcdf.getVar(ncid0, vid)); %(2,nvrt,ns,ntime)
%  size(suv) %query dims
%  vid=netcdf.inqVarID(ncid0,'salt_elem'); 
%  S_elem=double(netcdf.getVar(ncid0, vid));
%  vid=netcdf.inqVarID(ncid0,'ICE_tracer_1'); 
%  hice=double(netcdf.getVar(ncid0, vid));
  netcdf.close(ncid0);

%  figure(1); hold on;
%  patch('Faces',nm(1:3,:)','Vertices',[x y],'FaceVertexCData',hice(:,end),'FaceColor','interp','EdgeColor','none');
%  caxis([0 3]);
%  axis(ax);
%  colormap(jet(40));
%  colorbar;
%  title(['Ice volume; Time=' num2str(time(end)/86400)]);
%
%  return;

  %axis([1.e5 5e5 0.5e5 5e5]);
%   figure(1); hold on;
%   scale=2e3; %scale to fit
%   quiver(x,y,squeeze(uv(1,1,:))*scale,squeeze(uv(2,1,:))*scale,0,'b');
% %  quiver(xcj,ycj,squeeze(suv(1,end,:,end))*scale,squeeze(suv(2,end,:,end))*scale,0,'b');
%   quiver(3.5e5,4.e5,1*scale,0.,0,'r');
%   text(3.5e5,4.e5,'1 m/s');
%   axis(ax);
%   title(['suv; Time=' num2str(time(end))]);

%  figure(2); hold on;
%  surf=squeeze(S_elem(end,:,end));
%  patch('Faces',nm(1:3,:)','Vertices',[x y],'FaceVertexCData',surf','FaceColor','flat','EdgeColor','none');
%  caxis([0 30]);
%  axis(ax);
%  colormap(jet(40));
%  colorbar;
%  title(['S@elem; Time=' num2str(time(end))]);

  figure(3); hold on;
  surf=S(:,550); 
  patch('Faces',nm(:,1:3),'Vertices',[x y],'FaceVertexCData',surf,'FaceColor','interp','EdgeColor','none');
  caxis([0 0.4]);
  axis(ax);
  colormap(jet(40));
  colorbar;
  title(['S; Time=' num2str(time(end))]);
end %1==2
