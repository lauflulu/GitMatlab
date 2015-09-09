function [ bc ] = bcDirichlet( D,dt,dx,nx,UL,UR )
bc=zeros(nx-2,1); % concentration at boundary
bc(1)=D*dt*UL/dx^2; bc(nx-2)=D*dt*UR/dx^2; 

end

