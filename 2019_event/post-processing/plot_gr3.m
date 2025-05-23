function [ ]=plot_gr3(fname,caxis_min,caxis_max,num_columns,isphere, savename)
%plot_gr3(fname,caxis_min,caxis_max,num_columns,isphere) 
%Plot depths in .gr3 (tri-quad) in matlab
% where fname is a cell array (e.g. {'a','b'}
%caxis_min,caxis_max are min/max used in caxis
%num_columns: # of columna in subplot
%isphere: shperical grid option. If /=0, assumes lon discontinuity @dateline, 
%         and will recast lon to [0,360) and mask out discontinuity @prime meridian
%e.g. plot_gr3({'hgrid.gr3'},-1,10,1,0)

close all
% nfiles=length(fname);
nfiles=1;
% nrows=ceil(nfiles/num_columns);
nrows = num_columns;
figure(1);
set(gcf,'Color',[1 1 1]);
% for ifile=1:nfiles
% for ifile=1:1
  ifile = fname; % only plot 1 file
  % fid=fopen(fname(ifile),'r');
  fid=fopen(ifile,'r');
  % char=fgetl(fid);
  % char=fopen(fid);
  % tmp1=str2num(fopen(fid));
  tmp1=fid;
  fclose(fid);
  
  % ne=fix(tmp1(1));
  % np=fix(tmp1(2));
  % use this ugly input now
  ne = 24462;
  np = 13561;
  % 
  % fid=fopen(fname{ifile},'r');
  fid=fopen(ifile,'r');
  % %Change here if there are >1 'depths'
  c1=textscan(fid,'%d%f%f%f',np,'headerLines',2);
  fclose(fid);
  fid=fopen(ifile,'r');
  c2=textscan(fid,'%d%d%d%d%d%d',ne,'headerLines',2+np);
  fclose(fid);
  
  x=c1{2}(:);
  y=c1{3}(:);
  bathy=c1{4}(:);
  i34=c2{2}(:);

  %Make lon in [0,360)
  if(isphere~=0)
    indx=find(x<0);
    x(indx)=x(indx)+360;
  end
  
  nm(1:ne,1:4)=nan;
  for i=1:ne
    for j=1:i34(i)
      nm(i,j)=fix(c2{j+2}(i));
    end %for j

    %Check discontinuity across prime meridian
    if(isphere~=0)
      ifl=0; %flag
      for j=1:i34(i)
        n1=nm(i,j);
        j2=j+1;
        if(j==i34(i)); j2=j2-i34(i); end;
        n2=nm(i,j2);
        if(abs(x(n1)-x(n2))>180.)
          ifl=1; break;
        end
      end %for j

      if(ifl>0) %mask out this elem
        nm(i,:)=nan;
      end
    end %isphere/
  end %for i
  
  % subplot(nrows,num_columns,ifile); hold on;
  subplot(nrows,num_columns,1); hold on;
  %Plot with grid on
  %To plot .prop, use 'CData'
  %patch('Faces',nm(:,1:4),'Vertices',[x y],'FaceVertexCData',bathy,'FaceColor','interp'); 
  set(0,'defaultAxesFontSize',22);
  % set(0,'defaultAxesFontName','Times New Roman')
  set(gcf,'position',[10,10,1200,750])
  set(0, 'DefaultLineLineWidth', 0.5);
  set(gca, 'OuterPosition', [0,0,1,1])
  set(gca,'TickLabelInterpreter','latex') 
  set(0,'defaulttextinterpreter','latex')

  grid on
  box on
  % contourcbar
  pbaspect([1.9 1 1])

  patch('Faces',nm(:,1:4),'Vertices',[x y],'FaceVertexCData',bathy,'FaceColor','interp','EdgeColor','none');
  % colormap(jet);
  cm = acc_colormap('es_coolwarm');
  colormap(cm)
  caxis([caxis_min caxis_max]);
  xlabel('Longitude') 
  ylabel('Latitude')
  xlim([-80 -76])
  ylim([43.1 44.3])
  h = colorbar('southoutside');
  set(h,'fontsize',22);
  LabelText = 'Depth (m)'; %// Use superscript
  ylabel(h,LabelText,'FontSize',25)
  % w = h.LineWidth;
  % h.LineWidth = 1.5;
  % if(ifile==nfiles); colorbar; end;
  if(ifile==nfiles); end;
  % Export plots
figs = get(0,'children');
for f = 1:numel(figs)
    fname = sprintf(savename, figs(f).Number);
    print(figs(f).Number,fname,'-djpeg','-r800');
end
  % saveas(gcf,savename)
  %axis([5e5 6e5 4.13e6 4.24e6]);
% end %for ifile
