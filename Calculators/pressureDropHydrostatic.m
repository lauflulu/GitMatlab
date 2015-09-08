function [ dP ] = pressureDropHydrostatic( rho,h )
%PRESSUREDROPHYDROSTATIC computes the hydrostatic pressure dP (mbar)
% given the fluids density rho (g/ml) and height h (mm)
g=9.81; %m/s^2
dP=rho*g*h/100;
end

