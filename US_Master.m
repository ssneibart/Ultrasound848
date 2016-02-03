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

%% Compute Center Elements in Aperture for All Beams
[numElements_HalfAperture, CenterElementNum]  = ComputeApertureElements( LateralDistanceMatrix, FocusR, FNumb, ElementSpacing );

%% Delay and Crop Samples using Truncation and Include only Elements in Aperture
DelayedCroppedSamples  = DelayandCropSamples( DistanceIndexMatrix, M, CenterElementNum, NumbSamples, numElements_HalfAperture, NumbLines );

%% Sum Samples Using Apodization
% to do

%% Sum Elements With No Apodization
SummedRF = sum(DelayedCroppedSamples,2);
SummedRF = reshape(SummedRF,1949,41);
% % plot RF for beam 21
% figure
% plot(SummedRF(:,21))

%% Generate Ultrasound Image from RF Data
rfMatrix = SummedRF;
envDet = abs(hilbert(rfMatrix));
logComp = db(envDet);
colorLim = [0 50]; % set the range of values to scale into
dist = c/fs/2; %find the distance between each sample
avgLatmm = (min(ElementLocations)+max(ElementLocations))/2; % find the average lateral position
imagesc([min(ElementLocations)-avgLatmm max(ElementLocations)-avgLatmm ], [0 length(logComp(:,1))*dist], logComp, colorLim);
colormap(gray);
title('Phantom');
xlabel('mm');
ylabel('mm');

% %% Visualization
% figure
% hold on
% plot(BeamLocations,zeros(1,length(BeamLocations)),'k*')
% plot(ElementLocations,1/10*ones(1,length(ElementLocations)),'b*')
% plot(zeros(1,length(SampleLocations)),SampleLocations,'r.')
% plot([-2 2],[3 3], 'g-')
% axis([-2 2 0 8])
