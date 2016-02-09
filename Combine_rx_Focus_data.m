function [ combined_rfData ] = Combine_rx_Focus_data( rfData_MultiFoc,rxFocusSampleNumbers )
%combines rf data from multiple rx focus positions with sample numbers of
%rx focus as guide

%% Extract Info from rfData
[NumSamp, NumLines, NumrxFocus] = size(rfData_MultiFoc);

%% Compute Zones for rx Foci
for i = 1:4
ZoneSampleBounds(i) = round(mean([rxFocusSampleNumbers(i),rxFocusSampleNumbers(i+1)]));
end

%% Compute Zones as Matrices
Zones = zeros(NumSamp, NumLines, NumrxFocus);
% Compute Zones
Zones(1:ZoneSampleBounds(1),:,1)=1;
Zones(ZoneSampleBounds(1)+1:ZoneSampleBounds(2),:,2)=1;
Zones(ZoneSampleBounds(2)+1:ZoneSampleBounds(3),:,3)=1;
Zones(ZoneSampleBounds(3)+1:ZoneSampleBounds(4),:,4)=1;
Zones(ZoneSampleBounds(4)+1:end,:,5)=1;

%% Combine rfData using zones and matrix addition
combined_rfData = rfData_MultiFoc(:,:,1).*Zones(:,:,1) + ...
                  rfData_MultiFoc(:,:,2).*Zones(:,:,2) + ...
                  rfData_MultiFoc(:,:,3).*Zones(:,:,3) + ...
                  rfData_MultiFoc(:,:,4).*Zones(:,:,4) + ...
                  rfData_MultiFoc(:,:,5).*Zones(:,:,5) ;
    
end

