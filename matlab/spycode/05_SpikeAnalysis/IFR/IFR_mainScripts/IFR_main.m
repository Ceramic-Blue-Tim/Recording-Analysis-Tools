% IFR_mainScript.m
% select input folder
PDfolder = uigetdir(pwd,'Select the folder that contains the PeakDetectionMAT files:');
if strcmp(num2str(PDfolder),'0')          % halting case
    warndlg('Select a folder!','!!Warning!!')
    return
end
% select output folder
[expFolderPath,PDFolderName] = fileparts(PDfolder);
[saveFolderName, overwriteFlag] = createResultFolder(expFolderPath, 'IFR');
if(isempty(saveFolderName))
    errordlg('Error creating output folder!','!!Error!!')
    return
end
% select user parameters for analysis
[guiHandle,flag,commonParameters,computParameters,saveParameters] = IFRAnalysis();
close(guiHandle)
if(strcmp(flag,'cancel'))
    return
end
% executes computation
[answer,errorStr] = IFR_trialCycle(PDfolder,saveFolderName,commonParameters,computParameters,saveParameters);
if answer
    warndlg('Computation successfully accomplished!','IFR')
end