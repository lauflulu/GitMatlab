function [ meanInt] = meanIntensity( radius, intensitySum )
%MEANINTENSITY computes meanIntensity

meanInt=intensitySum./(radius.^2*pi);

end

