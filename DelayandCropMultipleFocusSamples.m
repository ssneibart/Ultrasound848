function [ DelayedCroppedMultipleFocusSamples ] = DelayandCropMultipleFocusSamples( MultiFocusDistanceIndexMatrix, M, CenterElementNum, NumbSamples, numElements_HalfAperture, NumbLines , MultiFocusRangeSampleIndices )
%Applies time delays and crops samples to give matrix with cropped and
%delayed samples

%% Find Cropping Amount in Number of Samples
% Cropping is applied such that 25% of the maximum time delay number of
% indices computed in the Distance Index Matrix is used as the cropping value
NumSamplesToCrop = floor(max(max(max(MultiFocusDistanceIndexMatrix)))/4);

% Compute how many samples to include in cropped data
NumIncludedSamples = NumbSamples - NumSamplesToCrop;

%% Find Number of Included Elements in Aperture
NumIncludedElementsAperture = 2*numElements_HalfAperture + 1;

%% Loop to Delay and Crop Samples for each Beam
DelayedCroppedMultipleFocusSamples = zeros(NumIncludedSamples,NumIncludedElementsAperture, NumbLines); % preallocate for speed
for beamIndex = 1:NumbLines
    FirstApertureElement = CenterElementNum(beamIndex)-numElements_HalfAperture; % computes element number of first element included in aperture
    for ApertureElementIndex = 1:NumIncludedElementsAperture
        for SampIndex = 1:NumIncludedSamples
            % Determine which rxFocus to use based on depth
            if isempty(find(MultiFocusRangeSampleIndices<SampIndex));
                rxFocusNum = 1;
            else
                rxFocusNum = max(find(MultiFocusRangeSampleIndices<SampIndex))+1;

            end
           
            % Compute Delay based on rxFocus for given sample
            delay = MultiFocusDistanceIndexMatrix(FirstApertureElement-1+ApertureElementIndex,beamIndex,rxFocusNum);                   
             
            % Compute DelayedCropped Samples for Given Delay 
            DelayedCroppedMultipleFocusSamples(SampIndex,ApertureElementIndex,beamIndex) = M(  delay+SampIndex, ...
                                                            FirstApertureElement-1+ApertureElementIndex,...
                                                            beamIndex); 
        end
    end

end

