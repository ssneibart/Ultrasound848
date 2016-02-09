%% US Master Code

%% Start
clear; close all; clc;

%% Load Data and Constants
cd ./data/ % go into data directory
[M,NumbLines,NumbElements,NumbSamples] = readBinData('imageData_Focused.bin');
[ElementSpacing] = readTransducerParams();
[BeamSpacing, fs, FocusR, FocusT, FNumb, t0] = readImageParams();
[c] = readConstants();
cd .. % go back to coding directory

%% Other Constants
F_bf = 2.5; % cm
bw = 0.55; 
x = 0.6; % compressive value
ReceiveAperture = FocusR/FNumb;
ReceiveDepth = 3; % cm

%% Time and Space Intervals
dt = 1/fs; % s
dx = c*dt; % cm 

%% Other
FocalIndex = FocusR./dx; % index

%% Spatial Location Calculations
[BeamLocations, ElementLocations, SampleLocations, SampleIndices] = SpatialLocator(BeamSpacing, NumbLines, ElementSpacing, NumbElements, dx, NumbSamples,t0);

%% Delay Calculations
[LateralDistanceMatrix, DistanceIndexMatrix] = DelayCalculator(BeamLocations, ElementLocations, FocusR,dx);

%% Delay Calculations for 5 Foci
MultiFocusPositionFractions = [0.18 0.36 0.54 0.72 0.90];
[MultiFocusDistanceIndexMatrix, MultiFocusPosition_cm, MultiFocusRangeSampleIndices] = MultiFocusDelayCalculator(LateralDistanceMatrix, MultiFocusPositionFractions, NumbSamples, dx);

%% Compute Center Elements in Aperture for All Beams
[numElements_HalfAperture, CenterElementNum]  = ComputeApertureElements( LateralDistanceMatrix, FocusR, FNumb, ElementSpacing );

%% Delay and Crop Samples using Truncation and Include only Elements in Aperture
DelayedCroppedSamples  = DelayandCropSamples( DistanceIndexMatrix, M, CenterElementNum, NumbSamples, numElements_HalfAperture, NumbLines );

%% Delay and Crop Samples for CenterLineData from Single Beam
%DelayedCroppedSingleBeamSamples = DelayandCropSingleBeamSamples( DistanceIndexMatrix, M, CenterElementNum, NumbSamples, numElements_HalfAperture, NumbLines );

%% Delay and Crop for CenterlineData using Aperture Growth (Extra Credit)
%DelayedCroppedSingleBeamApertureGrowthSamples = DelayandCropSingleBeamSamples_ApertureGrowthComp( DistanceIndexMatrix, M, NumbSamples, NumbLines, c, fs, LateralDistanceMatrix, FocusR, FNumb, ElementSpacing, dx);

%% Delay and Crop for Multiple rxFocus
% DelayedCroppedMultipleFocusSamples = DelayandCropMultipleFocusSamples(MultiFocusDistanceIndexMatrix,M, CenterElementNum, NumbSamples, numElements_HalfAperture, NumbLines, MultiFocusRangeSampleIndices );

%% Sum Samples Using Apodization
[rfData, apod_profile] = ApodizeAndSumSamples( DelayedCroppedSamples );

%% Constants for Image Generation
fc = 4*10^6; 
fs = 40*10^6;

%% Bandpass Filter 
Filt = bandpassfilter(rfData, fc,fs);

%% Time Gain Compensation ( gain as a function of time or depth)
a = 0.0015;
Filtamp = TGC(Filt, a);

%% Demodulation (Envelope Detection)
Envel = abs(hilbert(Filtamp));

%% Log compression s that we can see the areas that we are looking at
x =0.6;
A = exp(x*log(Envel));
% colorRange = [0 50];

% A = 20*log10(x*Envel/max(Envel(:)));
% colorRange=[-50 0]

colormap(gray)
imagesc(A) %, colorRange)

% %% Visualization
% figure
% hold on
% plot(BeamLocations,zeros(1,length(BeamLocations)),'k*')
% plot(ElementLocations,1/10*ones(1,length(ElementLocations)),'b*')
% plot(zeros(1,length(SampleLocations)),SampleLocations,'r.')
% plot([-2 2],[3 3], 'g-')
% axis([-2 2 0 8])
