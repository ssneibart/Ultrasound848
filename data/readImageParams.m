function [BeamSpacing, fs, FocusR, FocusT, FNumb, t0] = readImageParams()
%readImageParams Loads the parameters associated with the image taken
%   Pretty much just that

%% Beam Qualities
BeamSpacing = 0.0177; % cm

%% Acquisition
fs = 40e6; % Hz
FNumb = 2;
t0 = 10; % start reading t(0) at index of 10

%% Focus
FocusR = 3; % cm
FocusT = 2.5; %cm
end

