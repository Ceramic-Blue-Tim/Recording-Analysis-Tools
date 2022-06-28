
function [fitObject, gofObject, edgesFit, fitEval] = aVa_fitting(edges, histogramDataNorm, flagExpBin)
% created by Valentina Pasquale (September, 2006)
% Inputs:   edges - edges of the histogram (xdata)
%           histogramDataNorm - data to fit with power-law
%           flagExpBin - 1 for exponential binning, 0 for linear binning
% Outputs:  fitObject - output of the CurveFittingToolbox
%           gofObject - goodness of fit
%           edgesFit - x values for the fit
%           fitEval - y values for the fit
if(isscalar(histogramDataNorm) || isempty(histogramDataNorm)) % no fitting if there is only one point
    fitObject = [];
    gofObject = [];
    edgesFit = [];
    fitEval = [];
    return
else
    if(flagExpBin)
        maxValue = max(histogramDataNorm);
        xmin = 2;               % exclude the first data point
        xmax = max(edges);
        ymin = 0.001*maxValue;
        ymax = maxValue;
        outValues = excludedata(edges,histogramDataNorm,'box',[xmin xmax ymin ymax]);
        if(~isscalar(histogramDataNorm(~outValues)) && ~isempty(histogramDataNorm(~outValues))) % no fitting if there is only one point
            [fitObject,gofObject] = fit(edges,histogramDataNorm,'power1','exclude',outValues);
            firstInd = log2(xmin)+1;
            if ~isempty(find(outValues(firstInd:end) == 1))
                edgesFit = edges(firstInd:min(find(outValues(firstInd:end) == 1)));
            else
                edgesFit = edges(firstInd:end);
            end
            fitEval = feval(fitObject,edgesFit);
        else
            fitObject = [];
            gofObject = [];
            edgesFit = [];
            fitEval = [];
            return
        end
    else    
        maxValue = max(histogramDataNorm);
        xmin = 2;           % exclude the first data point
        xmax = max(size(histogramDataNorm));
        ymin = 0.001*maxValue;
        ymax = maxValue;
        outValues = excludedata(edges,histogramDataNorm,'box',[xmin xmax ymin ymax]);
        if(~isscalar(histogramDataNorm(~outValues)) && ~isempty(histogramDataNorm(~outValues))) % no fitting if there is only one point
            [fitObject,gofObject] = fit(edges,histogramDataNorm,'power1','exclude',outValues);
            if ~isempty(find(outValues(xmin:end) == 1))
                edgesFit = edges(xmin:min(find(outValues(xmin:end) == 1)));
            else
                edgesFit = edges(xmin:end);
            end
            fitEval = feval(fitObject,edgesFit);
        else
            fitObject = [];
            gofObject = [];
            edgesFit = [];
            fitEval = [];
            return
        end
    end
end