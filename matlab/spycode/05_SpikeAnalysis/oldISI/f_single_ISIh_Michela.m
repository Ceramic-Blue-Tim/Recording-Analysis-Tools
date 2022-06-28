function [bins,n_norm,max_y,meanISI,stdISI] = f_single_ISIh_Michela(spikes,fc,max_x,bin_samp)
% Computes the Inter-Spike Interval Histograms of the input spikes.

% max_x = maximum value of ISI considered [s]
% fc = sampling frequency [Hz]
% bin_samp = number of samples in a bin

warning off all

bin_size = bin_samp/fc;                 % Size of the bin [s]
bins = (bin_size/2):bin_size:max_x;     % ISI bins
Nbins = length(bins);                   % Number of bins

tspikes = find(spikes ~= 0)/fc;
ISI = diff(tspikes);    % Inter-spike-intervals [sec]

if ~isempty(ISI)    
    ISI_to_plot = ISI(ISI <= max_x);  % ISI <= max ISI visualized
    meanISI = mean(ISI_to_plot);
    stdISI = std(ISI_to_plot);
    [n] = hist(ISI_to_plot,bins);
    n_norm = n/sum(n); % ISI histogram normalized
    max_y = max(n_norm);    
else    
    n_norm = zeros(1,Nbins);
    meanISI = 0;
    stdISI = 0;
    max_y = NaN;
end