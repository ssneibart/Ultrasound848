function [ IncludedApertureElements ] = ComputeApertureElements( LateralDistanceMatrix, FocusR, FNumb )
%Computes which elements to include for each beam location
%   Lateral Distance Matrix = lateral distance of elements to beam location
%   FocusR = receive focus
%   FNumb = F number = focus/aperture
aperture_size = FocusR/FNumb;

IncludedApertureElements = not(abs(sign(sign(-aperture_size/2 - LateralDistanceMatrix) + ...
    sign(aperture_size/2 - LateralDistanceMatrix))));

end

