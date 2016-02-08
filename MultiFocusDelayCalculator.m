function [MultiFocusDistanceIndexMatrix, MultiFocusPosition_cm] = MultiFocusDelayCalculator(LateralDistanceMatrix, MultiFocusPositionFractions, NumbSamples, dx)
%DelayCalculator Calculates the Delays associated with each element
%   MultiFocusPositions is a vector with % of where to focus on receive
%   that is 5 elements long (e.g. [0.18 0.36 0.54 0.72 0.90] would focus at
%   18%, 36%, ..., 90% of samples in depth with first focus covering depth
%   of 0-27%, 27-45%, 45-63%, etc

%% Convert Focus Position Fractions to Distances in CM
MultiFocusPosition_cm = MultiFocusPositionFractions*NumbSamples*dx/2; 

%% Loop through focus positions to find delays
% preallocate size
[NumEl, numBeam] = size(LateralDistanceMatrix);
MultiFocusDistanceIndexMatrix = zeros(NumEl,numBeam,length(MultiFocusPosition_cm));

% Loop to find delays
for idx = 1:length(MultiFocusPosition_cm)
    Focus = MultiFocusPosition_cm(idx);
    DistanceMatrix = sqrt(LateralDistanceMatrix.^2+Focus.^2);
    DistanceDifferenceMatrix = DistanceMatrix - Focus;
    MultiFocusDistanceIndexMatrix(:,:,idx) = round(DistanceDifferenceMatrix./dx);
end



end
