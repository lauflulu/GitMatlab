function [  ] = plotData(position,intensity)

[nt,nd]=size(intensity); %number of time steps, number of droplets

%% average position
meanPosition=zeros(nd,1);
for d=1:nd
    meanPosition(d,1)=nanmean(position(:,d));
end
pmean=meanPosition;

%% get switch-on time:
onTime=ones(nd,1)*nt;
th=.1; %threshold
for d=1:nd
    for t=2:nt
        if intensity(t,d)>th && onTime(d,1)==nt && intensity(t-1,d)<th
            onTime(d,1)=t;
        end
    end
end

%%delete datapoints 
meanPosition(onTime==nt)=[];
onTime(onTime==nt)=[];
onTime=onTime*5; %in minutes

%% plot
figure(1) % position vs. onTime
    plot(onTime,meanPosition,'r+')
    ylabel('position [\mum]')
    xlabel('time [min]')

figure(2) % time traces, colourmapped, threshold (fixed position)
    hold all
    map1=zeros(nd,3);
    for d=1:nd
        plot([1:nt]*5/60,intensity(:,d),'Color',[1-pmean(d)/max(pmean),.2,pmean(d)/max(pmean)])
        map1(d,:)=[(1-min(pmean)/max(pmean))*(nd-d)/(nd-1),.2,(min(pmean)/max(pmean)*(nd-d)+(d-1))/(nd-1)];
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
        plot(position(t,:),intensity(t,:),'.-','Color',[0,t/180,0])
        map(k,:)=[0,t/180,0];
        k=k+1;
    end
    colormap(map);
    h=colorbar; caxis([0,nt*5/60]); ylabel(h,'time [h]');
    set(h,'Ytick',1/14*nt*5/60+(1-1/7)*[0:30:nt]*5/60); set(h,'Yticklabel',num2cell([0:30:nt]*5/60));
    xlabel('position [\mum]'); ylabel('normalized intensity [a.u.]');

end

