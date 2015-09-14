% Simulating the 1-D Diffusion equation (Fourier's equation) by the
...Finite Difference Method(a time march)
% Numerical scheme used is a first order upwind in time and a second order
...central difference in space (both Implicit and Explicit)

%% Specifying Parameters
width=400;       %width of the full system (µm)
D=1;             %Diffusion coefficient [µm²/s]
time=10*3600;      %simulated time (s)

nx=width;             %Number of steps in space(x) (1 µm)
dt=10;               %Width of each time step (10s)(resolution ~2 µm)
nt=time/dt;       %Number of time steps 
dx=width/(nx-1);         %Width of space step (200 µm)
x=0:dx:width;            %Range of x (0,2) and specifying the grid points
dtmax=(20*20)/(D*4*pi*pi);  %Stability criterion dt<(lmin^2/(Dv*4*pi*pi), for implicit)

%% if nothing is done here, the initial conditions will be u=0 everywhere (but at boundary)
u=zeros(nx,1);       %initialize concentration profile u
un=zeros(nx,1);      %initialize un
u=u+icAddDroplet(200,20,x,nx); %2x 40 µm droplets projected to 1D
%u=u+icAddSquare(1.0,0.2,x,nx); %a square wave


%% boundary conditions
bc=bcDirichlet(D,dt,dx,nx,0,0); %reservoir bcs
%bc=bcNeumann(D,dt,dx,nx,0,0); %(zero-)flux bcs

%% coefficient matrix for the implicit scheme
E=sparse(2:nx-2,1:nx-3,1,nx-2,nx-2); % 1st off-diagonal of 1s
A=E+E'-2*speye(nx-2);        %Dirichlet: matrix with 1s at off-diagonals and -2s at diagonal
%A(1,1)=-1; A(nx-2,nx-2)=-1; %Neumann:
C=speye(nx-2)-(D*dt/dx^2)*A;

%% Calculating the concentration profile for each time step
i=2:nx-1;
for it=0:nt
    un=u;
    threshold=ones(nx,1)*15/200;
    aboveTh=u-threshold>=0;
    h=plot(x,u,'b',x(aboveTh),threshold(aboveTh),'g.',x(~aboveTh),threshold(~aboveTh),'r.');
    axis([0 width 0 3])
    title({['1-D Diffusion with \nu =',num2str(D),' and t_{max} = ',num2str(dtmax)];['time(\itt) = ',num2str(dt*it)]})
    xlabel('Spatial co-ordinate (x) \rightarrow')
    ylabel('Transport property profile (u) \rightarrow')
    %threshold
    drawnow; 
    refreshdata(h)
    %Uncomment as necessary
    %-------------------
    %Implicit solution
    
    U=un;U(1)=[];U(end)=[];
    U=U+bc;
    U=C\U;
    u=[0;U;0];                      %Dirichlet [UL;U;UR]; 
    %u=[U(1)-UnL*dx;U;U(end)+UnR*dx]; %Neumann
    %}
    %-------------------
    %Explicit method with F.D in time and C.D in space
    %{
    u(i)=un(i)+(Dv*dt*(un(i+1)-2*un(i)+un(i-1))/(dx*dx));
    %}
end