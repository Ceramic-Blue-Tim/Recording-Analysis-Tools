function [outputMessage] = MAIN_multipleAvaIEI(expFolder, commonParameters, aVaIEIParameters)
% multaVaIEI.m
% created by Valentina Pasquale, 2006-2007

outputMessage = ['Folder ' expFolder ': '];
samplingFrequencyEdit = commonParameters{1,2};

% aVaIEI Parameters
aVaIEIBinEdit = aVaIEIParameters{1,4};
aVaIEIWinEdit = aVaIEIParameters{1,6};
aVaIEIYlimEdit = aVaIEIParameters{1,8};

% Processing
[foldNum, foldPath] = extractSpecFoldPath(expFolder,'.*PeakDetectionMAT.*');
if foldNum == 1
    start_folder = foldPath;
    multipleAvaIEI(start_folder, expFolder, samplingFrequencyEdit, aVaIEIBinEdit, aVaIEIWinEdit, aVaIEIYlimEdit)
end
