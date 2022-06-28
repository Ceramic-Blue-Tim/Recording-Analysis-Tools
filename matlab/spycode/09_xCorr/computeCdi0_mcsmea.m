% Plot_image_correlogram.m
% by Michela Chiappalone (22 Giugno 2006)
% modified by Luca Leonardo Bologna (11 June 2007)
%modified Ilaria Colombi
%   - in order to handle the 64 channels of the MED64 Panasonic system
function [Cpar, maxv, maxi]= computeCdi0_mcsmea(r_table, nbins, fs)

elNum=64;
% elNum = 60;
mcmea_electrodes = GlobalsParams.DEFAULT_ELECTRODES_LAYOUT;
 

r_mea=r_table(mcmea_electrodes,1);           % Select the right electrodes
% x=length(r_mea{1,1});     
x=length(r_mea{find(~cellfun(@isempty,r_mea),1)});% Length of the correlogram [samples]
% cc = reshape (cell2mat(r_mea), x, elNum)'; % Reshape the cell array
cc = reshape (cell2mat(r_mea), x, elNum)'; % Reshape the cell array
center=median(1:x);                     % Center of the correlogram

[maxv, maxi]=max(cc,[],2);              % Peak amplitude [uVolt] and position [samples]
[r, c] = size(maxi);
ccpeak = zeros(r, 1);
for i=1:r  % Cycle on all the elctrodes
    if (maxi(i)-nbins)>0
        ccpeak(i,1) = sum(cc(i, (maxi(i)-nbins):(maxi(i)+nbins)));
    end
end
Cpar= ccpeak;
maxi = (maxi-center)*1000/fs;           % Peak latency from zero [msec]