function [ rfData, ApodizationProfile ] = ApodizeAndSumSamples( DelayedCroppedSamples )
%Applies apodization and summing to cropped and delayed samples

%% Extract Data Information
[NumSamp, NumEl, NumLines] = size(DelayedCroppedSamples);

%% Create Apodization Profile Sin Wave
% half-sine wave with length equal to number of elements
t = 0.5:1:NumEl-0.5;
A = 1000; % Amplitude of apodization

%ApodizationProfile = A*sin(pi*t/NumEl); % Profile 1
ApodizationProfile = A*sin(pi*(t+1.5*NumEl)/NumEl/4); % Profile 2
%ApodizationProfile = ones(1,NumEl); % Flat Apodization

%% Apply Apodization to Samples
ApodizationMatrix = repmat(ApodizationProfile,NumSamp,1,NumLines);
ApodizedSamples   = ApodizationMatrix.*DelayedCroppedSamples;

%% Sum Apodized Samples to get rfData
rfData = reshape(sum(ApodizedSamples,2),NumSamp,NumLines);

end