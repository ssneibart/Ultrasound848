%% US Master Code
% Help Information

%% Start
clear; close all; clc;

%% Load Data
cd ./data/
[M, NumbSamples, NumbElements, NumbLines, ...
    ElementSpacing, BeamSpacing, ...
    fs, c, Focus] = loadData();

F_bf = 2.5; % cm
bw = 0.55; 
x = 0.6; % compressive value

ReceiveAperture = F_bf/2;
ReceiveDepth = 3; % cm

cd ..

%% Constants
ElementSpacing = 0.0201; % cm
NumbElements = 192;
NumbLines = 41;
BeamSpacing = 0.0177; % cm
fs = 40e6; % Hz
SampleElements = length(M);

c = 1452; % m/s
F_bf = 2.5; % cm
bw = 0.55; 
x = 0.6; % compressive value

ReceiveAperture = F_bf/2;
ReceiveDepth = 3; % cm

Focus = 3; % cm

%% Processing
dt = 1/fs;
dx = c*dt*100; % cm 
FocalIndex = 0.03./dx; % index

%% Hard Code
BeamLocations = (-BeamSpacing*((NumbLines-1)/2):BeamSpacing:BeamSpacing*((NumbLines-1)/2));
ElementLocations = ((-NumbElements./2*ElementSpacing)+1/2*ElementSpacing:ElementSpacing:NumbElements./2*ElementSpacing-1/2*ElementSpacing);
SampleLocations = 0:dx:dx*(length(M)-11);
SampleIndexes = 10:1:SampleElements;
Width = 20;

%% Final
Delay = zeros(1,20);
disp(size(M(:,:,21)));
Vq = interp2(M(:,:,21),1:192,FocalIndex);

[X,Y] = meshgrid(BeamLocations,ElementLocations); % Can cut down element locations
D = Y-X; % Columns are associated with the beamlocation and the rows are associated with which element

Distance = sqrt(D.^2 + Focus.^2);
DistanceDifference = Distance - 3;
DistanceIndex = DistanceDifference./dx;
TimeDelay = DistanceDifference./c./100;

%% Visualization
figure
hold on
plot(BeamLocations,zeros(1,length(BeamLocations)),'k*')
plot(ElementLocations,1/10*ones(1,length(ElementLocations)),'b*')
plot(zeros(1,length(SampleLocations)),SampleLocations,'r.')
plot([-2 2],[3 3], 'g-')
axis([-2 2 0 8])


