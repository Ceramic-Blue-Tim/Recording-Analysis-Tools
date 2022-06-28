% MAIN_psth.m
% This script computes the PSTH files from the PeakDetection MAT files
% by Michela Chiappalone (18 Gennaio 2006, 16 Marzo 2006)

clr
[start_folder]= selectfolder('Select the PeakDetectionMAT_files folder');
if strcmp(num2str(start_folder),'0')
    errordlg('Selection Failed - End of Session', 'Error');
    return
end

% -----------> INPUT FROM THE USER
% values retrieved are not normalized
[fs, binsize, cancwin, psthend, cancelFlag]= uigetPSTHinfo2;

if cancelFlag
    errordlg('Selection Failed - End of Session', 'Error');
else

    [exp_num]=find_expnum(start_folder, '_PeakDetection');

    % -----------> FOLDER MANAGEMENT
    cd (start_folder);
    cd ..
    end_folder=pwd;
%     expFolder=pwd;
%     [end_folder, success] = createResultFolder(expFolder, 'PSTH');
%     clear success
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

    EndOfProcessing (start_folder, 'Successfully accomplished');
end
clear all
