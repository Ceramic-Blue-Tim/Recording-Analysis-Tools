function [bins, histogramDataRebinned] = aVa_expBinning(histogramData)
% created by Valentina Pasquale (September 2006)
% aVa_expBinning rebins the array of the histogramData (result of the
% linear binning) according to an exponential binning (base 2).
% Input:    histogramData - array of the histogram data
% Outputs:  bins - exponential bins (2, 4, 8, 16, etc.)
%           histogramDataRebinned - array of the histogram data converted
%                                   according to the exponential binning
bingrowth = 2;
maxValue = max(size(histogramData));       % max limit
bins(1) = 1;
i = 1;
while(bins(i) < maxValue)
    bins(i+1) = bins(i)*bingrowth;
    i = i+1;
end
histogramDataRebinned = zeros(max(size(bins)),1);
histogramDataRebinned(1) = histogramData(1);
for j = 2:max(size(bins)) 
    if(bins(j)>maxValue)
        histogramDataRebinned(j) = sum(histogramData(bins(j-1)+1:maxValue));
    else
        histogramDataRebinned(j) = sum(histogramData(bins(j-1)+1:bins(j)));
    end
end 
bins = bins';

