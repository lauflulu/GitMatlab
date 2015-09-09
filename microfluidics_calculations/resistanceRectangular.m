function [ R ] = resistanceRectangular( w,h,L,mu )
%RESISTANCECIRCULAR calculates the flow resistance of a rectangular tube,
% using an analytical equation for low aspect ration w~h, up to 0.001 
%accuracy (assuming laminar flow)
% w: width (µm), h: height (µm), L length (mm), mu dyn. viscosity (N*s/m^2), 
%flowR: flow resistance (N*s/m^5)

sumTanhNew=0;
sumTanhOld=1;
n=1;
while abs(sumTanhNew-sumTanhOld)>0.001
    sumTanhOld=sumTanhNew;
    sumTanhNew=sumTanhOld+tanh(n*pi*w/2/h)/n^5;
    n=n+2;
end
R=12*mu*L/w/h^3/(1-h/w*192/pi^5*(sumTanhNew))*10^21;
end

