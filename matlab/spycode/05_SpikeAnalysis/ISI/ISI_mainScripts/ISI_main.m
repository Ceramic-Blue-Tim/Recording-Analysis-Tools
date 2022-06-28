% ISI_main
warning('off','signal:findpeaks:noPeaks')
% Select the source folder
PDFolder = uigetdir(pwd,'Select the PeakDetectionMAT files folder');
if strcmp(num2str(PDFolder),'0')
    errordlg('Selection Failed - End of Session', 'Error');
    return
end
% select parameters
[guiHandle, answer, commonParam, computParam, saveParam] = ISIHist();
close(guiHandle)
% create output folder
[expFolderPath,PDFolderName] = fileparts(PDFolder);
if strcmp(computParam.type,'lin')
    % linear binning
    ISIFolder = createResultFolder(expFolderPath, 'ISIHistogramLIN');
    if(isempty(ISIFolder))
        return
    end
    [flag, errorStr] = ISI_calcISILin(PDFolder, ISIFolder, commonParam, ...
        computParam, saveParam);
else if strcmp(computParam.type,'log')
        % logarithmic binning
        ISIFolder = createResultFolder(expFolderPath, 'ISIHistogramLOG');
        if(isempty(ISIFolder))
            return
        end
        [answer, errorStr] = ISI_calcISILog(PDFolder, ISIFolder, ...
            commonParam, computParam, saveParam);
    end
end
if answer
    warndlg('Computation successfully accomplished!','ISI')
end