% comp2dseason plot the spatial variables mean for each GCM 
% not applicable for wind speeds

% INPUTS:
%	shape file that specifies the polygone of the domain. So that all
%	compuatation is performed inside the polygone (for oceanic purposes).
%	The file is specified in shapefiles folder.
%	
%   Refrence data as a netcdf file naming 'REANALYSIS.nc' in ncs directory 
%
%   GCM datasets in netcdf format in ncs directory (all netcdf files must be
%   regridded into a similar grid. We used remapbic command of CDO package, for this purpose)

% OUTPUTS:
% 2D plot of spatial variables mean for each GCM 


clc
clear
close all

cd('ncfiles')
nc=dir('*.nc');
obs='REANALYSIS.nc';
lon=ncread(obs,'lon');
lat=ncread(obs,'lat');
[X,Y]=meshgrid(lon,lat);
var='tas'; %variable: hurs psl
vars=ncread(obs,var);%read the reference data
plotn=1;
for i=1:size(nc,1)
    fldtmo=ncinfo(nc(i).name);
    a=char(fldtmo.Variables.Name);
    if all(~contains(a,var))
        continue;
    end
    varsm=ncread(nc(i).name,var);%read the GCM data
    cd ../shapefies
    S=shaperead('AS.shp');
    cd ../ncfiles
    Lon=repmat(lon,size(lat));
    Lat=repmat(lat,size(lon));
    [in,on]=inpolygon(Lon,Lat,S.X',S.Y');%points inside the specified ploygone by shapefile
    % plot(Lon(in),Lat(in),'r+')
    CC=[Lon(in),Lat(in)];
    for x=1:size(lon)
        for y=1:size(lat)
            CCC=[lon(x) lat(y)];
            if ismember(CCC,CC,'rows')
                mvars(x,y,:,:)=reshape(squeeze(vars(x,y,:))',12,[]); %% create 128years array
                spring(x,y)=mean(mean(mvars(x,y,5:6,:))); %% 5:6 can be edited for the other seasons
                mvarsm(x,y,:,:)=reshape(squeeze(varsm(x,y,:))',12,[]);
                springm(x,y)=mean(mean(mvarsm(x,y,5:6,:)));
            else
                springm(x,y)= NaN;
            end
        end
   end
%ploting spatial mean of variables for GCMs
subaxis(double(int64(size(nc,1)/3))+1,3,plotn,'SpacingVert',0.02,'SpacingHoriz',0.02)
h=pcolor(X'-0.5,Y'-0.5,springm);
colormap(jet(20))
set(h,'edgecolor','none')
mapshow(S,'Color','k');
str=split(nc(i).name,'.nc');
title(str(2));
plotn=plotn+1;            
end