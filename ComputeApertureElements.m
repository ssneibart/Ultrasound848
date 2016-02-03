function [ IncludedApertureElements ] = ComputeApertureElements( LateralDistanceMatrix, FocusR, FNumb )
%   Computes which elements to include for each beam location
%   Lateral Distance Matrix = lateral distance of elements to beam location
%   FocusR = receive focus
%   FNumb = F number = focus/aperture
%   IncludedApertureElements = logical matrix with values of 1 at rows
%   corresponding to transducer elements that should be included in
%   aperture at beam location specified by the column

aperture_size = FocusR/FNumb; % F = z/D

IncludedApertureElements = not(abs(sign(sign(-aperture_size/2 - LateralDistanceMatrix) + ...
    sign(aperture_size/2 - LateralDistanceMatrix))));

end

