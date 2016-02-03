%% US Master Code
% Help Information

%% Start
clear; close all; clc;

%% Load Data
cd ./data/
[M, NumbSamples, NumbElements, NumbLines, ...
    ElementSpacing, BeamSpacing, ...
    fs, c, FocusR, FocusT, t0, FNumb] = loadData();

%% Other Constants
cd ..

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

%% Compute Aperture Elements to Include for All Beams
IncludedApertureElements = ComputeApertureElements(LateralDistanceMatrix, FocusR, FNumb);

%% Compute Included Samples in Aperture
SamplesInAperture = ChopSamplesToAperture( M, IncludedApertureElements, NumbSamples ); % no delays applied yet

%% 


%% Other
% Vq = interp2(M(:,:,21),1:192,FocalIndex);

% %% Visualization
% figure
% hold on
% plot(BeamLocations,zeros(1,length(BeamLocations)),'k*')
% plot(ElementLocations,1/10*ones(1,length(ElementLocations)),'b*')
% plot(zeros(1,length(SampleLocations)),SampleLocations,'r.')
% plot([-2 2],[3 3], 'g-')
% axis([-2 2 0 8])


