% calcISIstat.m
% by Valentina Pasquale, April 2008
% Given all the ISIs detected, it computes the mean, the standard deviation
% and the standard error for every channel
% ARGUMENTS:
% allISI: cell arrays containing the ISIs for all channels
% OUTPUT:
% ISIstat: 1st col: mean; 2nd col: std; 3rd col: stderror.
function [ISIstat] = calcISIstat(allISI)
nChan = length(allISI);
ISIstat = zeros(nChan,3);
for i = 1:nChan
    if ~isempty(allISI{i,1})
        ISIstat(i,1) = mean(allISI{i,1});
        ISIstat(i,2) = std(allISI{i,1});
        ISIstat(i,3) = stderror(ISIstat(i,1),allISI{i,1});
    end
end