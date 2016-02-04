function [ DelayedCroppedSingleBeamSamples ] = DelayandCropSingleBeamSamples_SN( DistanceIndexMatrix, M, CenterElementNum, NumbSamples, numElements_HalfAperture, NumbLines )
%Applies time delays and crops samples to give matrix with cropped and
%delayed samples

%% Find Cropping Amount in Number of Samples
% Cropping is applied such that 50% of the maximum time delay number of
% indices computed in the DistanceIndexMatrix is used as the cropping value
NumSamplesToCrop = floor(max(max(DistanceIndexMatrix))/2);

% Compute how many samples to include in cropped data
NumIncludedSamples = NumbSamples - NumSamplesToCrop;

%% Find Number of Included Elements in Aperture
NumIncludedElementsAperture = 2*numElements_HalfAperture + 1;

%% Loop to Delay and Crop Samples for each Beam
DelayedCroppedSingleBeamSamples = zeros(NumIncludedSamples,NumIncludedElementsAperture, NumbLines); % preallocate for speed
CenterBeam = ceil(NumbLines/2); % Center Beam is 21st line
N = M(:,:,21);
FirstApertureElement = CenterElementNum - numElements_HalfAperture;
beamIndex = [1:41];
delay = DistanceIndexMatrix(FirstApertureElement,beamIndex);

for beamIndex = 1:NumbLines
    FirstApertureElement = CenterElementNum(beamIndex)-numElements_HalfAperture; % computes element number of first element included in aperture
    for ApertureElementIndex = 1:NumIncludedElementsAperture
        delay = DistanceIndexMatrix(FirstApertureElement,beamIndex);
        for SampIndex = 1:NumIncludedSamples
            DelayedCroppedSingleBeamSamples(SampIndex,ApertureElementIndex,beamIndex) = M(  delay-1+SampIndex, ...
                                                            FirstApertureElement-1+ApertureElementIndex,...
                                                            CenterBeam); 
                                                        
        end
    end

end
