function [sigma1, sigma3, sigma4] = calcBranchParam2(pattern)
% This function is programmed according to the aVaGUI ver.1.1.6 (and
% forward) pattern: array 1x(n*64), where n is the avalanche lifetime

% sigma1 is computed as the ratio between the number of descendants d and
% the number of ancestors a ONLY in the first two bins of the avalanche

% sigma2 is computed as the ratio between the number of descendants d and
% the number of ancestors a ONLY in the first 2 bins of the avalanche, but
% taking into account ONLY avalanches with a single ancestor; otherwise is
% zero and then excluded from further analysis

% sigma3 is computed as the average value of the ratio between the number 
% of descendants d and the number of ancestors a in ALL PAIRS OF SUCCESSIVE 
% BINS in an avalanche

% sigma4 is computed as the ratio between the number of electrodes 
% descendants d and the number of electrodes ancestors a 
% ONLY in the first two bins of the avalanche

% avalanches of a single bin are excluded (i.e. sigma is zero)

numElec = 64;
dur = length(pattern)/numElec;
if(dur == 1)
    sigma1 = NaN;
%     sigma2 = NaN;
    sigma3 = NaN;
    sigma4 = NaN;
else
    pattReshaped = reshape(pattern,numElec,dur);
    % working on spikes
    pattSizes = sum(pattReshaped,1);
    sigma1 = round(pattSizes(2)/pattSizes(1));
%     if pattSizes(1) == 1
%         sigma2 = round(pattSizes(2)/pattSizes(1));
%     else
%         sigma2 = NaN;
%     end
    s = round(pattSizes(2:end)./pattSizes(1:end-1));
    sigma3 = round(mean(s));
    % working on electrodes
    pattFirst2Bins = pattReshaped(:,1:2);
    pattFirst2Bins(pattFirst2Bins(:,1)~=0,2) = 0;
    pattSizes2 = sum(pattFirst2Bins,1);
    sigma4 = round(pattSizes2(2)/pattSizes2(1));
end