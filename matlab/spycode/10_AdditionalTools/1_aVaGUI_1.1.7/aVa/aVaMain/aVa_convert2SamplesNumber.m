function [binSamplesWidth, numberOfBins, remainder] = aVa_convert2SamplesNumber(binWidth, fs, samplesNumber)
% created by Valentina Pasquale (September 2006)
% Inputs:   binWidth [ms]
%           fs - sampling frequency [Hz]
%           samplesNumber - total number of samples
% Outputs:  binSamplesWidth - number of samples in each bin
%           numberOfBins - total number of bins
%           remainder - number of samples remainder
scalingFactor = 1000;                                   % scaling factor between ms and s
binSamplesWidth = binWidth*fs/scalingFactor;            % Amplitude of the window in number of samples
numberOfBins = floor(samplesNumber/binSamplesWidth);    % Number of windows
remainder = rem(samplesNumber, binSamplesWidth);        % remainder
