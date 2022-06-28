function [fitObject, gofObject, edgesFit, fitEval, slopes] = aVaIMT_fitting(edges, histogramDataNorm)
% created by Valentina Pasquale, Settembre (2006)
% inputs:   histogramData - data to fit with power-law
% outputs:  fitObject - output of the CurveFittingToolbox
%           gofObject - goodness of fit
%           edgesFit - x values for the fit
%           fitEval - y values for the fit
%           flagExpBin - 1 for exponential binning, 0 for linear binning
fitObject = cell(1,1);
gofObject = cell(1,1);
edgesFit = cell(1,1);
fitEval = cell(1,1);
slopes = cell(1,1);
for ii = 1:length(histogramDataNorm)
    if(~isempty(histogramDataNorm{ii}))
        maxValue = max(histogramDataNorm{ii});
        xmin = 2;           % exclude first two data point
        xmax = max(size(edges{ii}));
        ymin = 0.001*maxValue;
        ymax = maxValue;
        outValues = excludedata(edges{ii},histogramDataNorm{ii},'box',[xmin xmax ymin ymax]);
        [fitObject{ii},gofObject{ii}] = fit(edges{ii},histogramDataNorm{ii},'power1','exclude',outValues);
        if ~isempty(find(outValues(xmin:end) == 1))
            edgesFit{ii} = edges{ii}(xmin:min(find(outValues(xmin:end) == 1)));
        else
            edgesFit{ii} = edges{ii}(xmin:end);
        end
        fitEval{ii} = feval(fitObject{ii},edgesFit{ii});
        slopes{ii} = fitObject{ii}.b;
    else
        fitObject{ii} = [];
        gofObject{ii} = [];
        edgesFit{ii} = [];
        fitEval{ii} = [];
        slopes{ii} = [];
    end
end
