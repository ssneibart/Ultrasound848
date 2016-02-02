function [DistanceIndexMatrix] = DelayCalculator(BeamLocations, ElementLocations, Focus,dx)
%DelayCalculator Calculates the Delays associated with each element
%   For each line there is an associated delay for every element
%   This function outputs the index values of the delays associated with
%   the beam forming calculations.

[BeamLocationsMatrix,ElementLocationsMatrix] = meshgrid(BeamLocations,ElementLocations);
DistanceMatrix = ElementLocationsMatrix - BeamLocationsMatrix;
DistanceDifferenceMatrix = DistanceMatrix - Focus;
DistanceIndexMatrix = DistanceDifferenceMatrix./dx;

end

