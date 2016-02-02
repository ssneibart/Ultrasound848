function [M, NumbSamples, NumbElements, NumbLines, ElementSpacing, ...
          BeamSpacing, fs, c, FocusR, FocusT, t0, FNumb] = loadData()
%loadParams loads the PreParams for US Reconstruction
%   Running this function will output a vector PreParams
%   

%% Load Data
[M,NumbLines,NumbElements,NumbSamples] = readBinData('imageData_Focused.bin');

%% General Constants
c = 1540*100; % cm/s

%% Transducer Qualities
ElementSpacing = 0.0201; % cm

%% Image Qualities
BeamSpacing = 0.0177; % cm
fs = 40e6; % Hz
FocusR = 3; % cm
FocusT = 2.5; %cm
FNumb = 2;
t0 = 10; % index of t0

end

