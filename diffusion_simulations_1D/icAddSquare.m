function [ u ] = icAddSquare( position, width, x,nx )
u=zeros(nx,1); %initialize
for i=1:nx
    if ((position-width/2.0<=x(i))&&(x(i)<=position+width/2.0))
        u(i)=1;
    else
        u(i)=0;
    end
end


end