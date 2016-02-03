%% US Master Code

%% Start
clear; close all; clc;

%% Load Data
cd ./data/ % go into data directory
[M, NumbSamples, NumbElements, NumbLines, ...
    ElementSpacing, BeamSpacing, ...
    fs, c, FocusR, FocusT, t0, FNumb] = loadData();
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

%% Compute Center Elements in Aperture for All Beams
[numElements_HalfAperture, CenterElementNum]  = ComputeApertureElements( LateralDistanceMatrix, FocusR, FNumb, ElementSpacing );

%% Delay and Crop Samples using Truncation and Include only Elements in Aperture
DelayedCroppedSamples  = DelayandCropSamples( DistanceIndexMatrix, M, CenterElementNum, NumbSamples, numElements_HalfAperture, NumbLines );

%% Sum Samples Using Apodization

% %% Visualization
% figure
% hold on
% plot(BeamLocations,zeros(1,length(BeamLocations)),'k*')
% plot(ElementLocations,1/10*ones(1,length(ElementLocations)),'b*')
% plot(zeros(1,length(SampleLocations)),SampleLocations,'r.')
% plot([-2 2],[3 3], 'g-')
% axis([-2 2 0 8])


