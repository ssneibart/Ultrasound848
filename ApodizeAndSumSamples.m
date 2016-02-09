function [ rfData, ApodizationProfile ] = ApodizeAndSumSamples( DelayedCroppedSamples )
%Applies apodization and summing to cropped and delayed samples

%% Extract Data Information
[NumSamp, NumEl, NumLines] = size(DelayedCroppedSamples);

%% Create Apodization Profile Sin Wave 
t = 0.5:1:NumEl-0.5;
A = 1000; % Amplitude of apodization
ApodizationProfile = A*sin(pi*t/NumEl); % half-sine wave with length equal to number of elements

%% Apply Apodization to Samples
ApodizationMatrix = repmat(ApodizationProfile,NumSamp,1,NumLines);
ApodizedSamples   = ApodizationMatrix.*DelayedCroppedSamples;

%% Sum Apodized Samples to get rfData
rfData = reshape(sum(ApodizedSamples,2),NumSamp,NumLines);

end

