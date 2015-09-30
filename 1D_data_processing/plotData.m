function [  ] = plotData(  )

load('data/positionStiched')
load('data/meanBrightIntStiched')
%stiching(2,2,189,193);
%absolutePosition(10);

nt=length(meanBrightInt(:,1)); %number of time steps
nd=length(meanBrightInt(1,:)); %number of droplets

% average position
meanPosition=zeros(nd,1);
for i=1:nd
    meanPosition(i,1)=nanmean(p(:,i));
end
pmean=meanPosition;

% get switch-on time:
onTime=ones(nd,1)*180;
th=.1; %threshold
for i=1:nd
    for t=2:nt
        if meanBrightInt(t,i)>th && onTime(i,1)==180 && meanBrightInt(t-1,i)<th
            onTime(i,1)=t;
        end
    end
end
%delete datapoints from backend
meanPosition(onTime==180)=[];
meanPosition=meanPosition;
onTime(onTime==180)=[];
onTime=onTime*5; %in minutes

%% plot
figure(1) % position vs. onTime
plot(onTime,meanPosition,'r+')
ylabel('position [\mum]')
xlabel('time [min]')

figure(2) % time traces, colourmapped, threshold (fixed position)
hold all
map1=zeros(nd,3);
for i=1:nd
    plot([1:nt]*5/60,meanBrightInt(:,i),'Color',[1-pmean(i)/max(pmean),.2,pmean(i)/max(pmean)])
    map1(i,:)=[(1-min(pmean)/max(pmean))*(nd-i)/(nd-1),.2,(min(pmean)/max(pmean)*(nd-i)+(i-1))/(nd-1)];
end
colormap(map1);
h=colorbar; caxis([min(pmean),max(pmean)]);ylabel(h,'position [\mum]');
plot([1:nt]*5/60,ones(nt)*th,'Color',[0,1,0])
xlabel('time [h]'); ylabel('normalized intensity [a.u.]'); 

figure(3) % intensity profile at fixed times
hold all
map=zeros(180/30,3);
k=1;
for t=[1,30:30:nt]
    plot(p(t,:),meanBrightInt(t,:),'.-','Color',[0,t/180,0])
    map(k,:)=[0,t/180,0];
    k=k+1;
end
colormap(map);
h=colorbar; caxis([0,nt*5/60]); ylabel(h,'time [h]');
set(h,'Ytick',1/14*nt*5/60+(1-1/7)*[0:30:nt]*5/60); set(h,'Yticklabel',num2cell([0:30:nt]*5/60));
xlabel('position [\mum]'); ylabel('normalized intensity [a.u.]');

end

