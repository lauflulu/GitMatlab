function [ intensity,area ] = extractChannel( positionNumber,channels,channelNumber)
%EXTRACTCHANNEL returns intensity and area of a single fluorescence channel
% channelType=1: for GFP -> returns brightIntSum, brightArea
% channelType=2: for AHL/IPTG -> returns intSum, radius^2*pi
nc=length(channels);
channel=channels{channelNumber};
c=channel{2};
channelType=channel{3};
load(sprintf('data/rawData%3d',positionNumber),'rawData')

if channelType==1
    brightIntSum=rawData{2,4};brightArea=rawData{2,5};
    [~,nd]=size(brightIntSum);nd=nd/nc;
    intensity=brightIntSum(:,c:nc:nc*nd-nc+c);
    area=brightArea(:,c:nc:nc*nd-nc+c);    
end

if channelType==2
    intSum=rawData{2,3};radius=rawData{2,2};
    [~,nd]=size(intSum);nd=nd/nc;
    intensity=intSum(:,c:nc:nc*nd-nc+c);
    area=radius.^2*pi;
end

end

