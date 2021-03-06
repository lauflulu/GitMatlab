function [ rawData ] = saveRawData(droplets, index)
%QUICKSAVEDATA save the exported data

% create folder data, if it does not exist
if exist('data','dir')==7 % 7=directory
    % do nothing
else
    mkdir('data')
end

%channels is a cell e.g. {'gfp','ahl','iptg'} are ordered as (gfp,...)_nd
[~,ND]=size([droplets.radius]); %number of droplets
[~,NCD]=size([droplets.intensitySum]); % number of droplets*channels
NC=NCD/ND; % number of channels

% fill rawData
rawData=cell(2,3+3*NC); 

position=[droplets.p];
rawData{1,1}='x';
rawData{2,1}=position(:,1:2:2*ND);

rawData{1,2}='y';
rawData{2,2}=position(:,2:2:2*ND);

rawData{1,3}='radius';
rawData{2,3}=[droplets.radius];

intSum=[droplets.intensitySum];
for c=1:NC
    rawData{1,3+c}=sprintf('meanIntensity%d',c);
    rawData{2,3+c}=meanIntensity([droplets.radius],intSum(:,c:NC:NCD));
end

briArea=[droplets.brightArea];
for c=1:NC
    rawData{1,3+NC+c}=sprintf('brightArea%d',c);
    rawData{2,3+NC+c}=briArea(:,c:NC:NCD);
end

briIntSum=[droplets.brightIntensitySum];
for c=1:NC
    rawData{1,3+2*NC+c}=sprintf('meanBrightIntensity%d',c);
    rawData{2,3+2*NC+c}=meanBrightIntensity([droplets.brightArea],briIntSum(:,c:NC:NCD));
end

save(sprintf('data/rawData%3d',index),'rawData');
end

