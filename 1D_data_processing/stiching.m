function [ intensity,p ] = stiching( reference1, reference2 , p1,p2,intensity1,intensity2,nettoInt1,nettoInt2)
%% description:
%reference1/2 identifies a reference droplet in the two pictures
%they can be determined by loading filteredDroplet%3d, clicking the droplet
%and displaying its number

%the function then merges the droplet properties to one list whereat the
%position for drops in the 2nd picture are updated as: 
%p1=p2 +(p_1ref-p_2ref)

%intensity traces are normalized according to nettoInt1/2

nd1=length(p1(1,:))/2;
nd2=length(p2(1,:))/2; % number of droplets in 1st/ 2nd picture

%% normalize to the total maximum intensity using nettoInt1/2
if nettoInt1<nettoInt2
    intensity1=intensity1*(nettoInt1/nettoInt2);
end
if nettoInt1>=nettoInt2
    intensity2=intensity2*(nettoInt2/nettoInt1);
end

%% adjust positions
% extract position (x,y) of the reference droplets for each time point
pRef1=p1(:,2*reference1-1:2*reference1);
pRef2=p2(:,2*reference2-1:2*reference2);
% adjust positions of 2nd picture to the coordinate system of the 1st
for d=1:nd2
    p2(:,2*d-1)=p2(:,2*d-1)+(pRef1(:,1)-pRef2(:,1));
    p2(:,2*d)=p2(:,2*d)+(pRef1(:,2)-pRef2(:,2));
end

%% eliminate every droplet in the 2nd picture that has a position smaller
% than the reference droplet (from back to front to avoid shifting of
% arrays)
% same for all upper droplets with position larger than the reference.
% here x0,y0 is simply the mean position of the reference droplet
x0=nanmean(pRef1(:,1)); y0=nanmean(pRef1(:,2));
absP1=position1D(10,p1,x0,y0);
absP2=position1D(10,p2,x0,y0);
meanRefP1=nanmean(absP1(:,reference1));
meanRefP2=nanmean(absP2(:,reference2));
for d=1:nd1
    if nanmean(p1(:,nd1+1-d))>meanRefP1+10
        p1(:,nd1+1-d)=[];
        intensity1(:,nd1+1-d)=[];
    end
end
for d=1:nd2
    if nanmean(p2(:,nd2+1-d))<meanRefP2+10
        p2(:,nd2+1-d)=[];
        intensity2(:,nd2+1-d)=[];

    end
end
%% merge
p=[p1,p2];
intensity=[intensity1,intensity2];

% figure(2)
% hold all
% plot(smoothIntLow,'r')
% plot(smoothIntUp,'b')
end

