function [ DelayedCroppedSamples ] = DelayandCropSamples_HardChop( DistanceIndexMatrix, rf, CenterElementNum, numElements_HalfAperture, NumIncludedSamples, NumLines )
%Applies time delays and crops samples to give matrix with cropped and
%delayed samples using chopping parameter NumIncludedSamples and aperture
%info with time delay matrix

%% Find Number of Included Elements in Aperture
NumIncludedElementsAperture = 2*numElements_HalfAperture + 1;

%% Loop to Delay and Crop Samples for each Beam
DelayedCroppedSamples = zeros(NumIncludedSamples,NumIncludedElementsAperture, NumLines); % preallocate for speed
for beamIndex = 1:NumLines
    FirstApertureElement = CenterElementNum(beamIndex)-numElements_HalfAperture; % computes element number of first element included in aperture
    for ApertureElementIndex = 1:NumIncludedElementsAperture
        delay = DistanceIndexMatrix(FirstApertureElement-1+ApertureElementIndex,beamIndex);
        for SampIndex = 1:NumIncludedSamples
            DelayedCroppedSamples(SampIndex,ApertureElementIndex,beamIndex) = rf(  delay+SampIndex, ...
                                                            FirstApertureElement-1+ApertureElementIndex,...
                                                            beamIndex); 
        end
    end

end

