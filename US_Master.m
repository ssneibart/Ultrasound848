%% US Master Code
% Single Receive Focus beamforming

%% Start
clear; clc %close all; clc;

%% Load Data and Constants
cd ./data/ % go into data directory
% Choose Plane Wave for Focused Data
%[M,NumLines,NumElements,NumSamples] = readBinData('imageData_PlaneWave.bin');
[M,NumLines,NumElements,NumSamples] = readBinData('imageData_Focused.bin');
[ElementSpacing] = readTransducerParams();
[BeamSpacing, fs, FocusR, FocusT, FNum, t0] = readImageParams();
[c] = readConstants();
cd .. % go back to coding directory

%% Other Constants
bw = 0.55;   % fractional bandwidth for BPF
x = 0.6;     % compressive value
fc = 4*10^6; % center frequency
a = 0.0015;  % gain

%% Time and Space Intervals
dt = 1/fs; % s
dx = c*dt; % cm 

%% Spatial Location Calculations
[BeamLocations, ElementLocations, SampleLocations, SampleIndices] = SpatialLocator(BeamSpacing, NumLines, ElementSpacing, NumElements, dx, NumSamples,t0);

%% Delay Calculations
[LateralDistanceMatrix, DistanceIndexMatrix] = DelayCalculator(BeamLocations, ElementLocations, FocusR,dx);

%% Compute Center Elements in Aperture for All Beams
[numElements_HalfAperture, CenterElementNum]  = ComputeApertureElements( LateralDistanceMatrix, FocusR, FNum, ElementSpacing );

%% Choose Delay and Sum Method for Sections A, E, Extra Credit
%Part A
%Delay and Crop Samples using Truncation and Include only Elements in Aperture
DelayedCroppedSamples  = DelayandCropSamples( DistanceIndexMatrix, M, CenterElementNum, NumSamples, numElements_HalfAperture, NumLines );

%Part E
%Delay and Crop Samples for CenterLineData from Single Beam
%DelayedCroppedSingleBeamSamples = DelayandCropSingleBeamSamples( DistanceIndexMatrix, M, CenterElementNum, NumSamples, numElements_HalfAperture, NumLines );

%Extra Credit
%Delay and Crop for CenterlineData using Aperture Growth (Extra Credit)
%DelayedCroppedSingleBeamApertureGrowthSamples = DelayandCropSingleBeamSamples_ApertureGrowthComp( DistanceIndexMatrix, M, NumSamples, NumLines, c, fs, LateralDistanceMatrix, FocusR, FNum, ElementSpacing, dx);

%% Sum Samples Using Apodization
% Toggle apodization in ApodizeAndSumSamples.m function
% Choose Delayed and Cropped Samples for A,E,Extra Credit as above
[rfData, ApodizationProfile] = ApodizeAndSumSamples( DelayedCroppedSamples );

%% Bandpass Filter 
Filt = bandpassfilter(rfData, fc,fs);

%% Time Gain Compensation ( gain as a function of time or depth)
Filtamp = TGC(Filt, a);

%% Demodulation (Envelope Detection)
Envel = abs(hilbert(Filtamp));

%% Log compression (fixes dynamic range)
A = exp(x*log(Envel));

%% Ranges (for plotting)
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

%% Plot Apodization Profile
figure(2)
plot(ApodizationProfile)