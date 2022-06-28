function structIEI = aVaIEI_mainProcessing(IEIbin, IEIwin, fs, activity)

% created by Valentina Pasquale (January 2007)
% input:    IEIbin: IEI bin width [msec]
%           IEIwin: IEI window [msec]
%           fs: sampling frequency
%           activity: matrix containing all the spike trains [number of samples * number of electrodes]
% output:   ieiEdges: IEI histogram edges [msec]
%           ieiHistogramNorm: IEI histogram (with params IEIbin, IEIwin and unit area)

% ------------- VARIABLES INITIALIZATION ---------------
% sumActivity = zeros(size(activity,1),1);                % matrix of the summed activity of all the electrodes
ieiEdges = [IEIbin:IEIbin:IEIwin]';                     % histogram edges [msec]
ieiHistogram = zeros(length(ieiEdges),1);               % IEI histogram

% ------------ PROCESSING ---------------
spikeTS = find(activity ~= 0);                       % indices of non-zero elements
spikeMult = activity(spikeTS);                       % number of spikes in every TS
clear activity
%ieiValues = zeros(size(spikeData,1)-1,1);
%ieiMult = zeros(size(spikeData,1)-1,1);
ieiValues = diff(spikeTS(:,1));                         % IEI values [samples]
%ieiMult = diag(spikeMult*spikeMult',1);                % IEI multiplicity
temp = [spikeMult(2:end);0];
ieiMult = spikeMult.*temp;
ieiMult = ieiMult(1:end-1);
ieiHistogram = aVaIEI_hist(ieiValues,ieiMult,ieiEdges); % IEI histogram
mIeiEdges = ieiEdges*(1000/fs);                         % ieiEdges [ms]
ieiHistogramNorm = ieiHistogram./sum(ieiHistogram);     % normalization
ieiMean = sum(mIeiEdges.*ieiHistogramNorm);             % IEI mean
ieiMedian = aVaIEI_median(mIeiEdges, ieiHistogramNorm); % IEI median
[fitIEI,gofIEI] = fit(mIeiEdges,ieiHistogramNorm,'power1');
fittedIEI = feval(fitIEI,mIeiEdges);
tau = fitIEI.b;
% this is a structure which collect all the results of the IEI calculation
% Content:
%   edges:        histogram edges array
%   histogram:    IEI histogram values
%   mean:         IEI mean
%   median:       IEI median
%   fitting:      power law fitting (cftoolbox object)
%   gof:          goodness of fitting parameters
%   fitValues:    evaluation of fitting
%   tau:          exponent of the power law fitting fitting
structIEI = struct('edges',mIeiEdges,'histogram',ieiHistogramNorm,'mean',ieiMean,'median',ieiMedian,'fitting',fitIEI,'gof',gofIEI,'fitValues',fittedIEI,'tau',tau);
