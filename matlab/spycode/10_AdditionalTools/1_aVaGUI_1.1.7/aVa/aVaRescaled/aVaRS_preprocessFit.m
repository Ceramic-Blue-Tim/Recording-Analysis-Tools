function [edges, histogramDataNorm] = aVaRS_preprocessFit(histogramData)
% created by Valentina Pasquale, Maggio 2007
% preprocessing of histogram data before fitting
% inputs:   histogramData - data to fit
% outputs:  edges - x values for the histogram
%           histogramDataNorm - histogram normalized
% cancel zero values at the end of the histogramData array
histogramDataNorm = cell(1,1);
edges = cell(1,1);
% average different scaling -->
% (1,1); (1,2); (2,1); (2,2);
% (3,1); (3,2); (3,3); (3,4);
% (4,1); (4,2); (4,3); (4,4);
% (5,1); (5,2); (5,3); (5,4);
histogramDataAveraged = cell(1,1);
temp = [histogramData{1,1}; histogramData{1,2}; histogramData{2,1}; histogramData{2,2}];
histogramDataAveraged{1,1} = mean(temp,1);
temp = [histogramData{3,1}; histogramData{3,2}; histogramData{3,3}; histogramData{3,4}];
histogramDataAveraged{2,1} = mean(temp,1);
temp = [histogramData{4,1}; histogramData{4,2}; histogramData{4,3}; histogramData{4,4}];
histogramDataAveraged{3,1} = mean(temp,1);
temp = [histogramData{5,1}; histogramData{5,2}; histogramData{5,3}; histogramData{5,4}];
histogramDataAveraged{4,1} = mean(temp,1);

for ii = 1:(size(histogramDataAveraged,1))
    if(~isempty(histogramDataAveraged{ii}))
        maxIndex = max(find(histogramDataAveraged{ii} ~= 0));
        histogramDataCut = histogramDataAveraged{ii}(1:maxIndex)';
        % normalize the array
        edges{ii} = (1:1:maxIndex)';
        normalizingFactor = sum(histogramDataCut);
        histogramDataNorm{ii} = (1/normalizingFactor).*histogramDataCut;
    else
        edges{ii} = [];
        histogramDataNorm{ii} = [];
    end
end