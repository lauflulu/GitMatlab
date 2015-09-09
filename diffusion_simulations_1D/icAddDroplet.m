function [ u ] = icAddDroplet( position, radius, x,nx )
u=zeros(nx,1); %initialize
for i=1:nx
    if ((position-radius<=x(i))&&(x(i)<=position+radius))
        u(i)=(radius^2-(position-x(i))^2)/radius^2;
    else
        u(i)=0;
    end
end


end

