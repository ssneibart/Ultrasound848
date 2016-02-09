%% Dynamic Receive Focusing

%% Start
clear; clc

%% Load Data and Constants
cd ./data/ % go into data directory
[M,NumLines,NumElements,NumSamples] = readBinData('imageData_Focused.bin');
[ElementSpacing] = readTransducerParams();
[BeamSpacing, fs, FocusR, FocusT, FNum, t0] = readImageParams();
[c] = readConstants();
cd .. % go back to coding directory

%% Image Generation Constants
x = 0.6; % Log Compression value
a = 0.0015; % Gain value

%% Time and Space Intervals
dt = 1/fs; % s
dx = c*dt; % cm

%% Custom Parameters
FocusFractions = [1,2,3,4,5]*0.18; % where to focus rx beam
rxFocus = (dx*NumSamples/2)*FocusFractions; % rxFocus positions in cm
rxFocusSampleNumers = round(NumSamples*FocusFractions);
NumIncludedSamples = round(0.92*NumSamples); % cut at 92% of samples, only works for values 81-98

%% Spatial Location Calculations
[BeamLocations, ElementLocations, SampleLocations, SampleIndices] = SpatialLocator(BeamSpacing, NumLines, ElementSpacing, NumElements, dx, NumSamples,t0);

%% Delay and Sum Beamforming

for i =1:5 % loop through rxFoci
    
    % Compute Delays
    [LateralDistanceMatrix, DistanceIndexMatrix] = DelayCalculator(BeamLocations, ElementLocations, rxFocus(i), dx);
    % Compute Aperture Elements to Include
    [numElements_HalfAperture, CenterElementNum]  = ComputeApertureElements( LateralDistanceMatrix, FocusR, FNum, ElementSpacing );
    % Delay and Crop Samples
    DelayedCroppedSamples = DelayandCropSamples_HardChop( DistanceIndexMatrix, M, CenterElementNum, numElements_HalfAperture, NumIncludedSamples, NumLines );
    % Apodize and Sum
    [ rfData_MultiFoc(:,:,i), ApodizationProfile ] = ApodizeAndSumSamples( DelayedCroppedSamples );
    
end

%% Combine rfData from multiple rxFoci
rfData = Combine_rx_Focus_data(rfData_MultiFoc,rxFocusSampleNumers);

%% Bandpass Filter 
Filt = bandpassfilter(rfData, fs/10 ,fs); % fc = fs/10

%% Time Gain Compensation ( gain as a function of time or depth)
Filtamp = TGC(Filt, a);

%% Demodulation (Envelope Detection)
Envel = abs(hilbert(Filtamp));

%% Log compression s that we can see the areas that we are looking at
A = exp(x*log(Envel));

%% Ranges 
lateralRange = NumLines*BeamSpacing;
lateral = (-lateralRange/2:BeamSpacing:lateralRange/2)*10;

axialRangetime = size(A,1)*dt;
axialRangem = axialRangetime*c/2;
axial  = (0:dt*c/2:axialRangem)*10; 

%% Image Formation 
figure(1)
colormap(gray)
imagesc(lateral,axial,A) % colorRange)
ylabel('Axial (mm)')
xlabel('Lateral (mm)')
axis image