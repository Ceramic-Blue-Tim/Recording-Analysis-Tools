function [ outputMessage ] =multAnPsthPsthLatency(start_folder,fs, binsize, cancwin, psthend)
%multAnPsthPsthLatency( input_args )
%MULTANPSTHPSTHLATENCY Summary of this function goes here
%   Detailed explanation goes here
% Created by Luca Leonardo Bologna 1 March 2007

outputMessage='';
[exp_num]=find_expnum(start_folder, '_PeakDetection');
% -----------> FOLDER MANAGEMENT
cd (start_folder);
cd ..
end_folder=pwd;
% expFolder=pwd;
% [end_folder, success] = createResultFolderNoUserQuestion(expFolder, 'PSTH');
% clear success
psthfoldername1 = strcat ('PSTHfiles_bin', num2str(binsize),...
    '-', num2str(psthend),'msec');   % Save the PSTH files here
psthfoldername2 = strcat ('PSTHresults_bin', num2str(binsize),...
    '-', num2str(psthend),'msec'); % Save additional PSTH features (latency, etc.) here
[psthfiles_folder]=createresultfolder(end_folder, exp_num, psthfoldername1);
[psthresults_folder]=createresultfolder(end_folder, exp_num, psthfoldername2);
clear psthfoldername1 psthfoldername2
cd (start_folder)
% --------------> COMPUTATION PHASE: Calculate PSTH
computePSTH(exp_num, fs, binsize, cancwin, psthend, start_folder, psthfiles_folder, psthresults_folder);
end
