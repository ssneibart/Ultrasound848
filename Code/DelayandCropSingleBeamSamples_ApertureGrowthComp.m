function [ DelayedCroppedSingleBeamSamples ] = DelayandCropSingleBeamSamples_ApertureGrowthComp( DistanceIndexMatrix, M, NumbSamples, NumbLines, c, fs, LateralDistanceMatrix, FocusR, FNumb, ElementSpacing, dx)
%Applies time delays and crops samples to give matrix with cropped and
%delayed samples

%% Find Cropping Amount in Number of Samples
% Cropping is applied such that 50% of the maximum time delay number of
% indices computed in the DistanceIndexMatrix is used as the cropping value
NumSamplesToCrop = floor(max(max(DistanceIndexMatrix))/2);

% Compute how many samples to include in cropped data
NumIncludedSamples = NumbSamples - NumSamplesToCrop;

%% Find Number of Included Elements in Aperture
% Compute aperture siz

% Compute number of elements in half of aperture
i = 1; for j = dx/2:dx/2:dx/2*NumIncludedSamples
g(i) =(j/FNumb)/ElementSpacing ;
i = i+1;
end
numElements_HalfAperture = ceil(g/2);

% Compute center element for each beam
[minDistanceElementtoBeam,CenterElementNum] = min(abs(LateralDistanceMatrix));

NumIncludedElementsAperture = 2*numElements_HalfAperture + 1;

%% Loop to Delay and Crop Samples for each Beam
%DelayedCroppedSingleBeamSamples = zeros(NumIncludedSamples,NumIncludedElementsAperture, NumbLines); % preallocate for speed
CenterBeam = ceil(NumbLines/2); % Center Beam is 21st line
for SampIndex = 1:NumIncludedSamples
for beamIndex = 1:NumbLines
    FirstApertureElement = CenterElementNum(beamIndex)-numElements_HalfAperture(SampIndex); % computes element number of first element included in aperture
    for ApertureElementIndex = 1:NumIncludedElementsAperture(SampIndex)
        delay = DistanceIndexMatrix(FirstApertureElement-1+ApertureElementIndex,beamIndex);
        
            DelayedCroppedSingleBeamSamples(SampIndex,ApertureElementIndex,beamIndex) = M(  delay+SampIndex, ...
                                                            FirstApertureElement-1+ApertureElementIndex,...
                                                            CenterBeam); 
                                                        
        end
    end

end
