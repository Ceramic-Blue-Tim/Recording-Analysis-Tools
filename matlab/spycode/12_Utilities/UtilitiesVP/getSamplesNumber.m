% getSamplesNumber.m
function [samples] = getSamplesNumber(folder)
% created by Luca Leonardo Bologna (Summer 2006)
% modified by Valentina Pasquale (October 2007)
% getSamplesNumber looks for a .mat file into the input folder, opens it
% and extracts the number of samples of a peak train.
% Inputs:   folder - generally the folder of a single trial (peak trains folder) 
% Output:   samples - number of samples
samples = [];
% startwd = pwd;
% cd(folder)
files = dirr(folder);
if isempty(files)
    error(['no .mat file in ', folder])
else
    filename = fullfile(folder,files(1).name);
    load(filename);
    samples = max(size(peak_train));
end
% cd(startwd)