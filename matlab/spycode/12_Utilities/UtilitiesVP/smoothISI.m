% smoothISI.m
% by Valentina Pasquale, April 2008
% Smoothes histograms according to the moving average algorithm (window =
% 3) (i.e. LPF)
% ARGUMENTS:
% ISI: cell array of ISI histograms
% OUTPUT:
% ISISmoothed: cell array of smoothed hist
function [ISISmoothed] = smoothISI(ISI,method,span)
ISISmoothed = cell(length(ISI),1);
for i = 1:length(ISI)
    if ~isempty(ISI{i,1})
        ISISmoothed{i,1} = smooth(ISI{i,1},span,method);
    end
end