function [ numElements_HalfAperture, CenterElementNum ] = ComputeApertureElements( LateralDistanceMatrix, FocusR, FNumb, ElementSpacing )
%   Computes center element for each beam and number of elements to include
%   in aperture
%   Lateral Distance Matrix = lateral distance of elements to beam location
%   FocusR = receive focus
%   FNumb = F number = focus/aperture
%   IncludedApertureElements = logical matrix with values of 1 at rows
%   corresponding to transducer elements that should be included in
%   aperture at beam location specified by the column

% Compute aperture size
aperture_size = FocusR/FNumb; % F = z/D

% Compute number of elements in half of aperture
numElements_HalfAperture = floor((aperture_size/ElementSpacing)/2);

% Compute center element for each beam
[minDistanceElementtoBeam,CenterElementNum] = min(abs(LateralDistanceMatrix));

end

