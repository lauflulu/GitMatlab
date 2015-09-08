function [ Q ] = flowRate( R,dP )
%FLOWRATE computes the flow rate Q(µl/h=10^-9*3600*m^3/s), 
%given the pressure drop dP (mbar) and the channels
%resistance R (N*s/m^5=10e-2*mbar/m^3)

Q=dP*100/R*3600*10^9;
end

