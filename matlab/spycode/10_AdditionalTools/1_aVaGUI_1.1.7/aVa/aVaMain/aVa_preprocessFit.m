
function [edges, histogramDataNorm] = aVa_preprocessFit(histogramData)
% created by Valentina Pasquale (September 2006)
% aVa_preprocessFit preprocesses the histogram data before fitting.
% Input:   histogramData - data to fit
% Outputs:  edges - xdata for the histogram
%           histogramDataNorm - histogram normalized

% cancel zero values at the end of the histogramData array
maxIndex = max(find(histogramData ~= 0));
histogramDataCut = histogramData(1:maxIndex)';
% normalize the array
edges = [1:1:maxIndex]';
normalizingFactor = sum(histogramDataCut);
histogramDataNorm = (1/normalizingFactor).*histogramDataCut;