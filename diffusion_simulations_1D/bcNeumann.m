function [ bc ] = bcNeumann( D,dt,dx,nx,UnL,UnR  )
bc=zeros(nx-2,1); % concentration at boundary
bc(1)=-UnL*D*dt/dx; bc(nx-2)=UnR*Dv*dt/dx;  %Neumann B.Cs
end

