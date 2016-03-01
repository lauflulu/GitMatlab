function [ smoothInt,nettoInt] = normalizeAndSmooth( intensity,area,mode,bgDrop)
%process raw intensity data: normalize and smooth
%mode=1: substract minimum of each trace
%mode=2: substract global minimum
%mode=3: substract trace of bgDrop (get number from droplet Dialog)

nd=length(area(1,:));
intensity=intensity./area; % average
smoothInt=zeros(size(intensity));
for d=1:nd
    smoothInt(:,d)=smoothn(intensity(:,d)); %smooth
end

if mode==1 %substract minimum of each trace
    maxInt=max(max(smoothInt));
    for d=1:nd
        bg=min(smoothInt(:,d)); %background
        smoothInt(:,d)=(smoothInt(:,d)-bg)/(maxInt-bg); %normalization
    end
end

if mode==2 % subsstract the global minimum
    maxInt=max(max(smoothInt));
    bg=min(min(smoothInt));
    smoothInt=(smoothInt-bg)/(maxInt-bg);
end

if mode==3% substract reference trace
    bgd=smoothInt(:,bgDrop);
    for d=1:nd
        smoothInt(:,d)=smoothInt(:,d)-bgd; %normalization
    end
    %smoothInt(:,bgDrop)=[];
    maxInt=max(max(smoothInt));
    for d=1:nd
        bg=min(smoothInt(:,d)); %background
        smoothInt(:,d)=(smoothInt(:,d)-bg)/(maxInt-bg); %normalization
    end
end

nettoInt=maxInt-bg;%for comparison with other positions
smoothInt(isnan(intensity))=NaN; %regenerate NaN values
end

