% Simulating the 1-D Diffusion equation (Fourier's equation) by the
...Finite Difference Method(a time march) changeds
% Numerical scheme used is a first order upwind in time and a second order
...central difference in space (both Implicit and Explicit)

%%
%Specifying Parameters
nx=100;              %Number of steps in space(x)
nt=200;              %Number of time steps 
dt=1;                %Width of each time step
dx=1/(nx-1);         %Width of space step
x=0:dx:1;            %Range of x (0,2) and specifying the grid points
u=zeros(nx,1);       %Preallocating u
un=zeros(nx,1);      %Preallocating un
Dv=1;                %Diffusion coefficient/viscosity
beta=Dv*dt/(dx*dx);  %Stability criterion (0<=beta<=0.5, for explicit)
UL=1;                %Left Dirichlet B.C
UR=0;                %Right Dirichlet B.C
UnL=1;               %Left Neumann B.C (du/dn=UnL) 
UnR=1;               %Right Neumann B.C (du/dn=UnR) 

%%
%Initial Conditions: A square wave -> is set to zero for all x
for i=1:nx
    if ((0<=x(i))&&(x(i)<=0.0))
        u(i)=0;
    else
        u(i)=0;
    end
end

%%
%B.C vector 
bc=zeros(nx-2,1); % concentration at boundary
bc(1)=Dv*dt*UL/dx^2; bc(nx-2)=Dv*dt*UR/dx^2;  %Dirichlet B.Cs
%bc(1)=-UnL*Dv*dt/dx; bc(nx-2)=UnR*Dv*dt/dx;  %Neumann B.Cs
%Calculating the coefficient matrix for the implicit scheme (?)
E=sparse(2:nx-2,1:nx-3,1,nx-2,nx-2); % sparse - big matrix efficient calculator
A=E+E'-2*speye(nx-2);        %Dirichlet B.Cs speye - speye(n) is a n x n identity matrix created with sparse
%A(1,1)=-1; A(nx-2,nx-2)=-1; %Neumann B.Cs
D=speye(nx-2)-(vis*dt/dx^2)*A;

%%
%Calculating the velocity profile for each time step
i=2:nx-1;
for it=0:nt
    un=u;
    h=plot(x,u);       %plotting the velocity profile
    axis([0 2 0 3])
    title({['1-D Diffusion with \nu =',num2str(vis),' and \beta = ',num2str(beta)];['time(\itt) = ',num2str(dt*it)]})
    xlabel('Spatial co-ordinate (x) \rightarrow')
    ylabel('Transport property profile (u) \rightarrow')
    drawnow; 
    refreshdata(h)
    %Uncomment as necessary
    %-------------------
    %Implicit solution
    
    U=un;U(1)=[];U(end)=[];
    U=U+bc;
    U=D\U;
    u=[UL;U;UR];                      %Dirichlet
    %u=[U(1)-UnL*dx;U;U(end)+UnR*dx]; %Neumann
    %}
    %-------------------
    %Explicit method with F.D in time and C.D in space
    %{
    u(i)=un(i)+(vis*dt*(un(i+1)-2*un(i)+un(i-1))/(dx*dx));
    %}
end