% summary of the data analysis procedure
% add the functions folder to your MATLAB path
% browse to e.g. data_analysis\AHLdroplets\150924
% copy this file into this folder and use it as a template, changes only 
% necessary in this file

%% tracking
% track droplets: filter on/off, higher extrude may help
% filter droplets: meanRadius, evtl. meanCyclicity or dataSize, manually
% disselect droplets by pressing ctrl
% export data: position (p),radius, intensitySum, brightIntensitySum, brightArea
% use saveRawData(number, ...) to save these variables

%tracking = DropletTracking(); tracking.open();
%filteredDroplets=droplets.guiSelect('meanRadius');
%filteredDroplets=filteredDroplets.guiSelect('dataSize');
%filteredDroplets=dropletSelection_1;
%saveRawData(241,p,radius,intensitySum,brightIntensitySum,brightArea);

%---------------done? now start with the script-----------------------

%% initialize variables
channels={{'GFP',1,1},{'AHL',2,2}}; nc=length(channels); %channelNo,channelType
positions=[241]; np=length(positions);
nInd=0; %number of inducers
for c=1:nc
    if channels{c}{3}==2 % channelType==2 means its an inducer
        nInd=nInd+1;
    end
end

data=cell(2,2+nc+nInd); % to store processed data, gets filled during the scipt
data{1,1}='positionXY';data{1,2}='position1D';
for c=3:nc+2
    data{1,c}=sprintf('intensity%s',channels{c-2}{1});
end
% inducer positions are labelled later

%% store x,y positions into data
positionXY=cell(1,np);
for p=1:np
    load(sprintf('data/rawData%3d',positions(p)),'rawData'); %load rawData of position
    positionXY{1,p}=rawData{2,1};
end
data{2,1}=positionXY;

%% processing of fluorescence traces
for c=1:nc
    normIntensity=cell(2,np); % intensity;nettoInt
    for p=1:np
        % get fluorescence data for each channel
        % e.g. channels={{'GFP',1,1},{'AHL',2,2}}, {channelName,channelNo,channelType}
        % channelType=1->brightIntSum (=reciever), channelType=2->intSum (=Inducer)
        [ intensity,area ] = extractChannel( positions(p),channels,c);

        % normalize and smooth the fluorescence traces
        %[ smoothInt,nettoInt ] = normalizeAndSmooth( intensity,area,mode);
        %mode=1: substract minimum of each trace
        %mode=2: substract global minimum
        %mode=3: substract backgroundTrace + global minimum ----not implemented yet----
        [ intensity,nettoInt ] = normalizeAndSmooth( intensity,area,2);
        normIntensity{1,p}=intensity; normIntensity{2,p}=nettoInt;
    end
    data{2,c+2}=normIntensity;
end
%% optional: stiching --check it--
% combine different (overlapping) positions by identifying
% reference droplets, includes normalization and smoothing of intensities
% (multiple channels) as well as calculation of absolute positions of droplets
% (distance from a predefined origin which can be a random droplet or the
% end of the capillary for reservoir experiments)

%% optional: registration of inducer droplets----evtl pack into function
% isInducer = isInducer(intensity,threshold) gives a boolean array
% that is 1 if the corresponding droplet is an inducer and 0 if not
% based on fluorescence intensity, threshold is at (max+min)/2*th
ind=0; %counts inducers
for c=1:nc
    if channels{c}{3}==2 % channelType==2 means its an inducer
        ind=ind+1;
        positionInducer=cell(1,np);
        for p=1:np
            position=data{2,1}{1,p}; %load x,y position
            intensity=data{2,4}{1,p}; % 4 to be generalized---------
            isInd=isInducer(intensity,1.2); pInd=position(logical(isInd));
            pInd=reshape(pInd,[],sum(isInd(1,:))); 
            meanPInd=nanmean(pInd,1);
            positionInducer{1,p}=meanPInd;
        end
        data{1,2+nc+ind}=sprintf('position%s',channels{c}{1});
        data{2,2+nc+ind}=positionInducer;
    end
end

%% calculating 1D positions
%[ p ] = absolutePosition( objective, p,x0,y0 )
dataToPlot=cell(1,2);
ind=0; %counts inducers
for c=1:nc
    if channels{c}{3}==2 % channelType==2 means its an inducer
        ind=ind+1;
        for p=1:np 
            meanPInd=data{2,2+nc+ind}{1,p};
            [~,ndInd]=size(meanPInd);ndInd=ndInd/2;
            load(sprintf('data/rawData%3d',positions(p)),'rawData'); radius=rawData{2,2};
            meanRadius=nanmean(nanmean(radius,1)); neighbourDrops=3;
            for dind=1:ndInd
                position=data{2,1}{1,p};
                intensity=data{2,2+1}{1,p}; % 2+1 to be generalized--------
                x0=meanPInd(2*ndInd-1);
                y0=meanPInd(2*ndInd);
                absPosition=abs(position1D(10, position,x0,y0 ));
                %eliminate everydrop but neighbours - needs to be generalized
                isNeigh=isNeighbour(absPosition,meanRadius,neighbourDrops);
                intensity=intensity(logical(isNeigh));
                intensity=reshape(intensity,[],sum(isNeigh(1,:)));
                absPosition=absPosition(logical(isNeigh));
                absPosition=reshape(absPosition,[],sum(isNeigh(1,:)));
                dataToPlot{1,1}=intensity;dataToPlot{1,2}=absPosition;
            end
        end
    end
end
    
%% plotting
% plotData(...) makes different plots, to be generalized...
intensity=dataToPlot{1,1};
position=dataToPlot{1,2};
plotData(position,intensity);