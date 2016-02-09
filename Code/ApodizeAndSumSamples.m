function [ rfData, ApodizationProfile ] = ApodizeAndSumSamples( DelayedCroppedSamples )
%Applies apodization and summing to cropped and delayed samples

%% Extract Data Information
[NumSamp, NumEl, NumLines] = size(DelayedCroppedSamples);

%% Create Apodization Profile
ApodizationProfile = ones(1,NumEl); % equal weighting

%% Apply Apodization to Samples
ApodizationMatrix = repmat(ApodizationProfile,NumSamp,1,NumLines);
ApodizedSamples   = ApodizationMatrix.*DelayedCroppedSamples;

%% Sum Apodized Samples to get rfData
rfData = reshape(sum(ApodizedSamples,2),NumSamp,NumLines);

end

