% Plot_image_correlogram.m
% by Michela Chiappalone (22 Giugno 2006, 8 Febbraio 2007)

function [Cpar, maxv, maxi]= computeCdi0cluster(r_table, cluster, nbins, fs)

r_cluster=r_table(cluster,1);               % Select the right electrodes
x=length(r_cluster{1,1});                   % Length of the correlogram [samples]

cc = reshape (cell2mat(r_cluster), x, 15)'; % Reshape the cell array
center = median(1:x);                       % Center of the correlogram
[maxv, maxi] = max(cc, [], 2);              % Peak amplitude [uVolt] and position [samples]

[r, c] = size(maxi);
ccpeak = zeros(r, 1);
for i=1:r % Cycle on all the elctrodes
    if (maxi(i)-nbins)>0
        ccpeak(i,1) = sum(cc(i, (maxi(i)-nbins):(maxi(i)+nbins)));
    end
end

Cpar= ccpeak;
maxi = (maxi-center)*1000/fs;               % Peak latency from zero [msec]

% cc_peak=cc(:, center-nbins:center+nbins); % --> old code: peak around zero
% Cpar=sum(cc_peak, 2);                     % --> old code: peak around zero

