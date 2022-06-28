% calcMFR.m
function mfr = calcMFR(peakTrn, acqTime, th)
nspikes = sum(peakTrn > 0);
mfr = nspikes/acqTime;
% all the channels whose mfr < 0.2 spikes/s are considered not active
mfr(mfr < th) = 0;