% Simulating the 1-D Diffusion equation (Fourier's equation) by the
...Finite Difference Method(a time march)
% Numerical scheme used is a first order upwind in time and a second order
...central difference in space (both Implicit and Explicit)

%% Specifying Parameters
width=400;       %width of the full system (µm)
D=1;             %Diffusion coefficient [µm²/s]
time=10*3600;      %simulated time (s)

nx=width/4;             %Number of steps in space(x) (1 µm)
dt=10;               %Width of each time step (10s)(resolution ~2 µm)
nt=time/dt;       %Number of time steps 
dx=width/(nx-1);         %Width of space step (200 µm)
x=0:dx:width;            %Range of x (0,2) and specifying the grid points
dtmax=(20*20)/(D*4*pi*pi);  %Stability criterion dt<(lmin^2/(Dv*4*pi*pi), for implicit)
beta=D*dt/dx^2; %dimensionless diffusion parameter

%% if nothing is done here, the initial conditions will be u=0 everywhere (but at boundary)
u=zeros(nx,1);       %initialize concentration profile u
%u=u+icAddDroplet(200,20,x,nx); %2x 40 µm droplets projected to 1D
%u=u+icAddSquare(1.0,0.2,x,nx); %a square wave

%% boundary conditions
UL=1;UR=0;
bc=bcDirichlet(D,dt,dx,nx,UL,UR); %reservoir bcs
%bc=bcNeumann(D,dt,dx,nx,0,0); %(zero-)flux bcs

%% coefficient matrix for the Crank-Nicholson scheme A*U_n+1=B*U_n
E=sparse(2:nx,1:nx-1,1,nx,nx); % 1st off-diagonal of 1s
A=-beta*E-beta*E'+2*(1+beta)*speye(nx);  %Dirichlet (only U is modified): matrix with 1s at off-diagonals and -2s at diagonal
%A(1,1)=-1; A(nx-2,nx-2)=-1; %Neumann:
B=beta*E+beta*E'+2*(1-beta)*speye(nx);


%% Calculating the concentration profile for each time step
i=2:nx-1;
for it=0:nt
    
    threshold=ones(nx,1)*15/200;
    aboveTh=u-threshold>=0;
    h=plot(x,u,'b',x(aboveTh),threshold(aboveTh),'g.',x(~aboveTh),threshold(~aboveTh),'r.');
    axis([0 width 0 3])
    title({['1-D Diffusion with \nu =',num2str(D),' and \beta = ',num2str(beta)];['time(\itt) = ',num2str(dt*it)]})
    xlabel('Spatial co-ordinate (x) \rightarrow')
    ylabel('Transport property profile (u) \rightarrow')
    %threshold
    drawnow; 
    refreshdata(h)
    %Uncomment as necessary
    %-------------------
    %Implicit solution
    %B(1,:)=0; B(nx,:)=0;
    %B(1,1)=1;B(nx,nx)=1; 
    %u(1)=UL;u(nx)=UR;
    u=A\B*u;
    u(1)=u(1)+beta*UL;u(nx)=u(nx)+beta*UR;
    %u=[U(1)-UnL*dx;U;U(end)+UnR*dx]; %Neumann
end