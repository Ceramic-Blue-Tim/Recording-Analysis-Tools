% MAIN_burstdetection.m
% This script operates the Burst Detection algorithm on the PeakDetection MAT files
% by Michela Chiappalone (17 Marzo 200, 12 Gennaio 2007)

clr
[start_folder]= selectfolder('Select the PeakDetectionMAT_files folder');
if strcmp(num2str(start_folder),'0')
    errordlg('Selection Failed - End of Session', 'Error');
    return
end

% -----------> INPUT FROM THE USER
[nspikes, ISImax, min_mbr, cwin, fs, cancelFlag]= uigetBURSTinfo; % Get parameters from user

if cancelFlag
     errordlg('Selection Failed - End of Session', 'Error');
    return
end
[exp_num]=find_expnum(start_folder, '_PeakDetection'); % Experiment number

% -----------> FOLDER MANAGEMENT
cd (start_folder);
cd ..
expfolder=pwd;
burstfoldername = strcat ('BurstDetectionMAT_', num2str(nspikes), ...
    '-', num2str(ISImax), 'msec'); % Burst files here
[burst_folder]=createresultfolder(expfolder, exp_num, burstfoldername); % Save path
[end_folder1]=createresultfolder(burst_folder, exp_num, 'BurstDetectionFiles');
[end_folder2]=createresultfolder(burst_folder, exp_num, 'BurstEventFiles');
[end_folder3]=createresultfolder(burst_folder, exp_num, 'OutBSpikesFiles');
clear burstfoldername expfolder

cd (start_folder)

% --------------> COMPUTATION PHASE: Burst Detection
BurstDetection (start_folder, end_folder1, end_folder2, end_folder3, nspikes, ISImax, min_mbr, cwin, fs)

EndOfProcessing (start_folder, 'Successfully accomplished');

clear all
