function [ vMean ] = flowRate2meanVelocity( Q,w,h )
%FLOWRATE2MEANVELOCITY computes mean velocity vMean (µm/h) from flow rate Q (µl/h)
%given channel dimensions w,h (µm)
A=w*h;
vMean=Q*10^9/A;
end

