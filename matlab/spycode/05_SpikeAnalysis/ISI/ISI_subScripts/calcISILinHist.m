% calcISILinHist.m
% by Valentina Pasquale - 2008-03-10
% ISI histogram computation for a single spike train (linear binning)
% ARGUMENTS:
% peakTrn: the peak train
% maxWin_s: maximum windom (x-scale) in s
% binSize_ms: bin size (in ms)
% sf: sampling rate
% RESULTS:
% bins: series of bins (linearly spaced)
% ISIlin_hist_norm: normalized linear histogram of ISI [ms]
% allISI: all inter-spike intervals [ms]
function [bins, ISIlin_hist_norm, allISI] = calcISILinHist(peakTrn, maxWin_s, binSize_ms, sf)
if size(peakTrn,1) < size(peakTrn,2)    % numRows < numCols
    peakTrn = peakTrn';                 % now column vector
end
% ISI COMPUTATION
ts = find(peakTrn);     % find timestamps
if numel(ts) > 1 % if there is at least two spikes
    % ********** Introdurre scelta parametro di soglia
    mfr = calcMFR(peakTrn, length(peakTrn)/sf, 0.1); % computes mfr (mfr=0 if it is below threshold th)
else
    allISI = [];
    bins = [];
    ISIlin_hist_norm = [];
    return    
end
if mfr   % if mfr is ~= 0 (i.e. > th)
    allISI = diff(ts)/sf*1000;                           % ISIs in [ms]
    maxWin_ms = maxWin_s*1000;                           % converts to ms
    nBins = ceil(maxWin_ms/binSize_ms);                  % rounds towards +inf
    bins = linspace(0,maxWin_ms,nBins);                  % equally spaced linear bins [0,binSize_ms,2*binSize_ms...]
    ISIlin_hist = histc(allISI,bins);                    % computes hist (bins is a vector of edges)
    areaISIlin_hist = sum(ISIlin_hist);
    if(areaISIlin_hist)
        ISIlin_hist_norm = ISIlin_hist./areaISIlin_hist;    % normalization
        ISIlin_hist_norm = ISIlin_hist_norm(:);
        bins = bins(:);
    else
        bins = [];
        ISIlin_hist_norm = [];
    end
else
    allISI = [];
    bins = [];
    ISIlin_hist_norm = [];
end