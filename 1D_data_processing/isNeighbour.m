function [ isNeigh]=isNeighbour(absPosition,meanRadius,neighbourDrops)
%ISNEIGHBOUR identifies positions of neighbours of inducer droplets 
% (boolean matrix fitting the size of intensity/1Dposition)
% intensity: normalized and smoothed intensity traces

[nt,nd]=size(absPosition);
isNeigh=zeros(nt,nd);
for d=1:nd
        if nanmean(absPosition(:,d))>meanRadius && ...
                nanmean(absPosition(:,d))<meanRadius*(neighbourDrops*2+1)
            isNeigh(:,d)=1;
        end
end

end

