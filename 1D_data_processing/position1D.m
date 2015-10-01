function [ p] = position1D( objective, p,x0,y0 )
%1D position from (x,y) applying Pythagoras (in µm)
%objective = magnification (4x,10x, ...)
%x0,y0 gives a reference, e.g. the capillary tip/ boundary to reservoir
pxInMicrons=13/objective; %13 µm per px
nt=length(p(:,1));
nd=length(p(1,:))/2;
newP=zeros(nt,nd);

for t=1:nt;
    for d=1:nd
        z=complex((p(t,2*d-1)-x0),(p(t,2*d)-y0)); % complex distance vector
        if angle(z)<=0 && angle(z)>pi % positive for positive y, so downwards
            sign=1;
        else
            sign=-1;
        end
        newP(t,d)=abs(z)*sign;
    end
end
p=newP*pxInMicrons;
end

