% plotSpikeBurstNetBurst.m
% by Valentina Pasquale, December 2008

% %%%%%%%%%%%
clear all
%close all
% %%%%%%%%%%%
% Select the source folder
PDFolder = uigetdir(pwd,'Select the PeakDetectionMAT files folder');
if strcmp(num2str(PDFolder),'0')
    errordlg('Selection Failed - End of Session', 'Error');
    return
end
[expFolderPath, PDFolderName] = fileparts(PDFolder);
% Select the source folder (#2)
BDFolder = uigetdir(expFolderPath,'Select the BurstDetection files folder');
if strcmp(num2str(BDFolder),'0')
    errordlg('Selection Failed - End of Session', 'Error');
    return
end
% Select the source folder (#3)
NBFolder = uigetdir(expFolderPath,'Select the NetworkBurstDetectionFiles folder');
if strcmp(num2str(NBFolder),'0')
    errordlg('Selection Failed - End of Session', 'Error');
    return
end
% output folder
[BDFolderPath, NBFolderName] = fileparts(NBFolder);
[saveFolderName, overwriteFlag] = createResultFolder(BDFolderPath, 'plotSpikeBurstNetBurst');
if(isempty(saveFolderName))
    errordlg('Error creating output folder!','!!Error!!')
    return
end
% user parameters
[userParam, flag] = plotSpikeBurstNetBurst_getParam();
if ~flag
    errordlg('Selection Failed - End of Session', 'Error');
else
    [flag2] = plotSpikeBurstNetBurst_plotFunction(PDFolder, BDFolder, NBFolder, saveFolderName, userParam);
    if(flag2)
        msgbox('plotSpikeBurstNetBurst', 'End Of Session', 'warn')
    else
        errordlg('Saving failed: end of session','Error')
    end
end