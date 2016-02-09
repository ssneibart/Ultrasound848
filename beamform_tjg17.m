function [ b, x, z ] = beamform_tjg17( rf, acq_params )
%Beamformer for code derby
% variable descriptions can be found on code derby presentation outline

%% Extract Size from RF
[NumSamples,NumElements,NumLines]=size(rf);

%% Extract Acquisition Parameters from struct
c = 100*acq_params.c; % Convert o cm
fs = acq_params.fs;
t0 = acq_params.t0;
ElementLocations = 100*acq_params.rx_pos(:,1)'; % in cm
BeamLocations = 100*acq_params.tx_pos(:,1)'; % in cm

%% Derived Parameters
dx = c/fs; % Sample Length
ElementSpacing = ElementLocations(2)-ElementLocations(1);

%% Custom Parameters
FocusFractions = [1,2,3,4,5]*0.18; % where to focus rx beam
rxFocus = (dx*NumSamples/2)*FocusFractions; % rxFocus positions in cm
rxFocusSampleNumbers = round(NumSamples*FocusFractions);
FNumb = 2; % F = z/D (z = focus, D = aperture size)
NumIncludedSamples = round(0.92*NumSamples); % cut at 92% of samples, only works for values 81-98

%% Delay and Sum Beamforming

for i =1:5 % loop through rxFoci
    
    % Compute Delays
    [LateralDistanceMatrix, DistanceIndexMatrix] = DelayCalculator(BeamLocations, ElementLocations, rxFocus(i), dx);
    % Compute Aperture Elements to Include
    [numElements_HalfAperture, CenterElementNum]  = ComputeApertureElements( LateralDistanceMatrix, rxFocus(i), FNumb, ElementSpacing );
    % Delay and Crop Samples
    DelayedCroppedSamples = DelayandCropSamples_HardChop( DistanceIndexMatrix, rf, CenterElementNum, numElements_HalfAperture, NumIncludedSamples, NumLines );
    % Apodize and Sum
    rfData_MultiFoc(:,:,i) = ApodizeAndSumSamples( DelayedCroppedSamples );
    
end

%% Combine rfData from multiple rxFoci
rfData = Combine_rx_Focus_data(rfData_MultiFoc,rxFocusSampleNumbers);

%% ImageGeneration? 
% Bandpass Filter
Filt = bandpassfilter(rfData, fs/10,fs);
% Time Gain Compensation ( gain as a function of time or depth)
a = 0.0015;
Filtamp = TGC(Filt, a);
% Demodulation (Envelope Detection)
Envel = abs(hilbert(Filtamp));
% Log compression so that we can see the areas that we are looking at
x =0.6;
A = exp(x*log(Envel));
% colormap(gray)
% imagesc(A)

%% For later
b = A;
x = LateralDistanceMatrix;
z = DistanceIndexMatrix;

end

