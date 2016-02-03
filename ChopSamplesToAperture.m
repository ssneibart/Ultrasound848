function [ SamplesInAperture ] = ChopSamplesToAperture( M, IncludedApertureElements, NumbLines )
% Creates matrix size of bin data with only samples from elements that
% should be included for each beam
%  M = bin data with samples x elements x beams

% Expand aperture elements to 3d matrix
ExpandedApertureElements = repmat(IncludedApertureElements, 1, 1, NumbLines);

% Permute 3d matrix to match dimensions of bin data
ExpandedApertureElements = permute(ExpandedApertureElements,[3 1 2]);

% Compute samples in aperture by matrix element multiplication
SamplesInAperture = ExpandedApertureElements.*M;

end

