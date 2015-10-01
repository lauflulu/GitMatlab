function [ isInducer ] = isInducer( intensity,threshold )
%INDUCERPOSITION identifies positions of inducer droplets 
% (boolean matrix fitting the size of p)
% intensity: normalized and smoothed intensity traces

[nt,nd]=size(intensity);
minInt=min(nanmean(intensity(1:20,:),1));
maxInt=max(nanmean(intensity(1:20,:),1));
isInducer=zeros(nt,2*nd);
for d=1:nd
        if nanmean(intensity(1:20,d))>(maxInt+minInt)*0.5*threshold
            isInducer(:,2*d-1:2*d)=1;
        end
end
end

