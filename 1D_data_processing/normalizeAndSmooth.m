function [ smoothInt,nettoInt ] = normalizeAndSmooth( intensity,area,mode)
%process raw intensity data: normalize and smooth
%mode=1: substract minimum of each trace
%mode=2: substract global minimum
%mode=3: substract backgroundTrace ----not implemented yet----

nd=length(area(1,:));
intensity=intensity./area; % average
smoothInt=zeros(size(intensity));
for i=1:nd
    smoothInt(:,i)=smoothn(intensity(:,i)); %smooth
end

if mode==1 %substract minimum of each trace
    maxInt=max(max(smoothInt));
    for i=1:nd
        bg=min(smoothInt(:,i)); %background
        smoothInt(:,i)=(smoothInt(:,i)-bg)/(maxInt-bg); %normalization
    end
end
if mode==2 % subsstract the global minimum
    maxInt=max(max(smoothInt));
    bg=min(min(smoothInt));
    smoothInt=(smoothInt-bg)/(maxInt-bg);
end
if mode==3% substract reference trace
    for i=1:nd
        smoothInt(:,i)=(smoothInt(:,i)-backgroundTrace); %normalization
    end
    maxInt=max(max(smoothInt));
    bg=min(min(smoothInt));
    smoothInt=(smoothInt-bg)/(maxInt-bg);
end
nettoInt=maxInt-bg;%for comparison with other positions
smoothInt(isnan(intensity))=NaN; %regenerate NaN values
end

