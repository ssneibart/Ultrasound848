function [BeamLocations, ElementLocations, SampleLocations, SampleIndices] = SpatialLocator(BeamSpacing, NumbLines, ElementSpacing, NumbElements, dx, NumbSamples, t0)
%SpatialLocator Defines the location discrete points
%   Using the number of elements, element spacing, and symmetry 

BeamLocations = (-BeamSpacing*((NumbLines-1)/2):BeamSpacing:BeamSpacing*((NumbLines-1)/2));
ElementLocations = ((-NumbElements./2*ElementSpacing)+1/2*ElementSpacing:ElementSpacing:NumbElements./2*ElementSpacing-1/2*ElementSpacing);
SampleLocations = 0:dx:dx*(NumbSamples-(t0+1));
SampleIndices = 10:1:NumbSamples;

end

