function Y = bandpassfilter(X,fc,fs)
% the function will bandpass filter the variable x given the center
% frequency fc, the will filter out all but the 50% bandwidth of the center
% frequency, 
% Y will be bandpass filtered array same length as X

order = 1;

bandwidth = 0.5*fc;
flo = fc - bandwidth/2;
fhi = fc + bandwidth/2;


[b,a] = butter(order,[flo fhi]/fs,'bandpass');


Y = filter(b,a,X,[],1);

