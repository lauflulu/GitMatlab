function [ rawData ] = saveRawData( positionNumber,p,radius,intensitySum,brightIntensitySum,brightArea)
%QUICKSAVEDATA save the exported data
%channels is a cell e.g. {'gfp','ahl','iptg'} are ordered as (gfp,...)_nd
rawData=cell(2,5); 
rawData{1,1}='position';rawData{1,2}='radius';rawData{1,3}='intensitySum';
rawData{1,4}='brightIntensitySum';rawData{1,5}='brightArea';
rawData{2,1}=p;rawData{2,2}=radius;rawData{2,3}=intensitySum;
rawData{2,4}=brightIntensitySum;rawData{2,5}=brightArea;
save(sprintf('data/rawData%3d',positionNumber),'rawData');
end

