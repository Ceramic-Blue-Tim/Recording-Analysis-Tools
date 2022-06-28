function [outputMessage] = MAIN_multipleAva(expFolder, commonParameters, aVaParameters)
% MAIN_multipleAva.m
% Multiple Neuronal Avalanches detection algorithm (aVa)
% created by Valentina Pasquale, 2006-2007
outputMessage = ['Folder ' expFolder ': '];
samplingFrequencyEdit = commonParameters{1,2};

% aVa Parameters
aVabinValuesEdit = aVaParameters{1,4};
aVaexpBinningFlagEdit = aVaParameters{1,6};

% Processing
[ foldNum, foldPath ] = extractSpecFoldPath( expFolder,'.*PeakDetectionMAT.*');
if foldNum == 1
    start_folder = foldPath;
    multipleAva(start_folder, expFolder, samplingFrequencyEdit, aVabinValuesEdit, aVaexpBinningFlagEdit)
end