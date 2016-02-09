function [ b, x, z ] = beamform_tjg17_ssn6_bz45_jko11( rf, acq_params, bf_params )
%Beamformer for code derby
% variable descriptions can be found on code derby presentation outline

%% Extract Acquisition Parameters from Acquisition Parameters struct
c  = 100*acq_params.c; % cm/s
fs = acq_params.fs;
f0 = acq_params.f0;
t0 = acq_params.t0;
ElementLocations = 100*acq_params.rx_pos(:,1)'; % in cm
BeamLocations = 100*acq_params.tx_pos(:,1)'; % in cm
Focus = 10*acq_params.focus; % in cm

%% Extract Beamform Parameters from bf params struct
FocusFractions = bf_params.FocusFractions;
FNumb          = bf_params.FNumb;
Gain           = bf_params.Gain;
SampleFraction = bf_params.SampleFraction;

%% Time Delay and Extract Size from RF
% Only include samples after t0
% rf = rf(t0:end,:,:); % too slow not included
[NumSamples,NumElements,NumLines]=size(rf);

%% Derived Parameters
dx = c/fs; % Sample Length
ElementSpacing = ElementLocations(2)-ElementLocations(1);
BeamSpacing    = BeamLocations(2)   -BeamLocations(1);
rxFocus = (dx*NumSamples/2)*FocusFractions; % rxFocus positions in cm
rxFocusSampleNumbers = round(NumSamples*FocusFractions);
NumIncludedSamples = round(SampleFraction*NumSamples);

%% Delay and Sum Beamforming
% preallocate for speed
rfData_MultiFoc = zeros(NumIncludedSamples,NumLines,5);
for i =1:5 % loop through rxFoci
    % Compute Delays
    [LateralDistanceMatrix, DistanceIndexMatrix] = DelayCalculator(BeamLocations, ElementLocations, rxFocus(i), dx);
    % Compute Aperture Elements to Include
    [numElements_HalfAperture, CenterElementNum]  = ComputeApertureElements( LateralDistanceMatrix, Focus, FNumb, ElementSpacing );
    % Delay and Crop Samples
    DelayedCroppedSamples = DelayandCropSamples_HardChop( DistanceIndexMatrix, rf, CenterElementNum, numElements_HalfAperture, NumIncludedSamples, NumLines );
    % Apodize and Sum
    rfData_MultiFoc(:,:,i) = ApodizeAndSumSamples( DelayedCroppedSamples );
end

%% Combine rfData from multiple rxFoci
rfData = Combine_rx_Focus_data(rfData_MultiFoc,rxFocusSampleNumbers);

%% RF Processing
% Bandpass Filter
Filt = bandpassfilter(rfData, f0,fs);
% Time Gain Compensation ( gain as a function of time or depth)
Filtamp = TGC(Filt, Gain);
% Demodulation (Envelope Detection)
Envel = abs(hilbert(Filtamp));
% Log compression so that we can see the areas that we are looking at
b = 20*log10(Envel/max(Envel(:)));

%% Define Ranges
lateralRange = NumLines*BeamSpacing;
x = (-lateralRange/2:BeamSpacing:lateralRange/2)*10;

axialRangetime = size(b,1)/fs;
axialRangem = axialRangetime*c/2;
z  = (0:(1/fs)*c/2:axialRangem)*10; 

end

