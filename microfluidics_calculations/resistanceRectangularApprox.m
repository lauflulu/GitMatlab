function [ R ] = resistanceRectangularApprox( w,h,L,mu )
%RESISTANCECIRCULAR calculates the flow resistance of a rectangular tube,
% using an analytical equation for high aspect ration w>>h (assuming laminar flow)
% w: width (µm), h: height (µm), L: length (mm), mu: dyn. viscosity (N*s/m^2)
% flowR: flow resistance (N*s/m^5)

R=12*mu*L/w/h^3*10^21;
end

