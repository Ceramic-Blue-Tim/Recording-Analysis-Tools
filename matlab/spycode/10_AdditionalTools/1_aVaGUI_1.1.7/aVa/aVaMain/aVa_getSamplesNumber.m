
function [samplesNum] = aVa_getSamplesNumber(startingFolder,fileType)
% created by Luca Leonardo Bologna (Summer 2006)
% modified by Valentina Pasquale (September 2006)
% aVa_getSamplesNumber browses the folder until a .mat file is found (into
% the PeakDetection files folder), opens it and extracts the number of
% samples of a peak train.
% Inputs:   startingFolder - generally the Peak Detection files folder
%           fileType - generally .mat 
% Output:   samplesNum - number of samples
[Files,Bytes,Names] = dirr(startingFolder,strcat(filesep,'.',fileType),'name');
if isempty(Names)
    error(strcat('no .mat file in ', startingFolder, ' and its subdirectories'))
end
load(Names{1});
samplesNum = max(size(peak_train));
