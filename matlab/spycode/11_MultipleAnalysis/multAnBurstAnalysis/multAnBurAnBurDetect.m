function [ output_args ] = multAnBurAnBurDetect(start_folder, nspikes, ISImax, min_mbr, cwin, fs )
%MULTANBURANBURDETECT Summary of this function goes here
% Detailed explanation goes here
% Created by Luca Leonardo Bologna 25 February 2007

output_args='';
% -----------> INPUT FROM THE USER
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
%parameters passed must not be normalized
BurstDetection (start_folder, end_folder1, end_folder2, end_folder3, nspikes, ISImax, min_mbr, cwin, fs);
