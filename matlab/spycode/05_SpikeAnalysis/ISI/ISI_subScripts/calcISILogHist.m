% calcISILogHist.m
% by Valentina Pasquale - 2008-03-10
% ISI histogram computation for a single spike train (logarithmic binning)
% ARGUMENTS:
% peakTrn: the peak train
% nBinsPerDec: number of bins per decade
% sf: sampling frequency
% RESULTS:
% bins: series of bins (logarithmically spaced)
% ISIlog_hist_norm: normalized logarithmic histogram of ISI
% allISI: all inter-spike intervals
function [bins, ISIlog_hist_norm, allISI] = calcISILogHist(peakTrn, nBinsPerDec, sf)
if size(peakTrn,1) < size(peakTrn,2)    % numRows < numCols
    peakTrn = peakTrn';                 % now column vector
end
% ISI COMPUTATION
ts = find(peakTrn);     % find timestamps
if numel(ts) > 1 % if there is at least two spikes
    % ********** Introdurre scelta parametro di soglia
    mfr = calcMFR(peakTrn, length(peakTrn)/sf, 0); % computes mfr (mfr=0 if it is below threshold th)
else
    allISI = [];
    bins = [];
    ISIlog_hist_norm = [];
    return    
end
if mfr   % if mfr is ~= 0 (i.e. > th)
    allISI = diff(ts)/sf*1000;                     % ISIs in [ms]
    maxWin = ceil(log10(max(allISI)));             % [ms]; rounded to the nearest decade towards +inf
    bins = logspace(0,maxWin,maxWin*nBinsPerDec);    % equally spaced logarithmic bins
    ISIlog_hist = histc(allISI,bins);                     % computes hist
    ISIlog_hist_area = sum(ISIlog_hist);
    if ISIlog_hist_area
        ISIlog_hist_norm = ISIlog_hist./ISIlog_hist_area;    % normalization    
        ISIlog_hist_norm = ISIlog_hist_norm(:);
        bins = bins(:);
    else
        ISIlog_hist_norm = [];
        bins = [];        
    end
else
    allISI = [];
    bins = [];
    ISIlog_hist_norm = [];
end