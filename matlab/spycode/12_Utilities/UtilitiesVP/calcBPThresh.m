% calcBPThresh.m
function [BPTh] = calcBPThresh(tsBE, perc)
% tsBE: timestamps of burst events in [samples]
% perc: percentile value of BP to consider in [samples]
BP = diff(tsBE);
% calculates the required percentile
BPTh = round(prctile(BP,perc));