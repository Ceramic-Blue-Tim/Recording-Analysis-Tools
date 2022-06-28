% IBEI_main.m
clear all
% close all
warning('off','signal:findpeaks:noPeaks')
% %%%%
% Select the source folder
BEFolder = uigetdir(pwd,'Select the BurstEvent files folder');
if strcmp(num2str(BEFolder),'0')
    errordlg('Selection Failed - End of Session', 'Error');
    return
end
% %%%%
% Select the parameters
[userParam, flag] = IBEI_getParam();
% create output folder
[BDFolderPath,BEFolderName] = fileparts(BEFolder);
IBEIFolder = createResultFolder(BDFolderPath, 'IBEIHistogramLOG');
if(isempty(IBEIFolder))
    return
end
% doing computation
[answer, errorStr] = IBEI_calcIBEILogHist(BEFolder, IBEIFolder, userParam);
if answer
    warndlg('Computation successfully accomplished!','ISI')
end