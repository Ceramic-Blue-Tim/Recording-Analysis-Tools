
function [edges, histogramDataNorm] = aVaIMT_preprocessFit(histogramData)
% created by Valentina Pasquale, Settembre (2006)
% preprocessing of histogram data before fitting
% inputs:   histogramData - data to fit
% outputs:  edges - x values for the histogram
%           histogramDataNorm - histogram normalized
% cancel zero values at the end of the histogramData array
histogramDataNorm = cell(1,1);
edges = cell(1,1);
for ii = 1:max(size(histogramData))
    maxIndex = max(find(histogramData{ii} ~= 0));
    histogramDataCut = histogramData{ii}(1:maxIndex)';
    % normalize the array
    edges{ii} = (1:1:maxIndex)';
    normalizingFactor = sum(histogramDataCut);
    histogramDataNorm{ii} = (1/normalizingFactor).*histogramDataCut;
end
