function [ vMean ] = flowRate2meanVelocity( Q,w,h )
%FLOWRATE2MEANVELOCITY computes mean velocity vMean (�m/h) from flow rate Q (�l/h)
%given channel dimensions w,h (�m)
A=w*h;
vMean=Q*10^9/A;
end

