function [ R ] = resistanceCircular( r,L,mu )
%RESISTANCECIRCULAR calculates the flow resistance of a circular tube,
% using the Hagen-Poiseuille equation (assuming laminar flow)
% r: radius (µm), L length (mm), mu viscosity (N*s/m^2), 
%flowR: flow resistance (N*s/m^5)
R=8*L*mu/pi()/r^4*10^21;
end

