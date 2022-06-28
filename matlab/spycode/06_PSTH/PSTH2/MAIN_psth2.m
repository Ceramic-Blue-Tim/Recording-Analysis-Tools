% MAIN_psth.m
% This script computes the PSTH files from the PeakDetection MAT files
% by Michela Chiappalone (18 Gennaio 2006, 16 Marzo 2006)

clr
[peak_folder]= selectfolder('Select the PeakDetectionMAT_files folder');
if strcmp(num2str(peak_folder),'0')
    errordlg('Selection Failed - End of Session', 'Error');
    return
end

% -----------> INPUT FROM THE USER
% values retrieved are not normalized
[fs, bin_ms, blank_ms, win_ms, cancelFlag]= uigetPSTHinfo2;

if cancelFlag
    errordlg('Selection Failed - End of Session', 'Error');
else
    slash_idx = strfind(peak_folder,filesep);
    underscore_idx = strfind(peak_folder(slash_idx(end)+1:end),'_');
    exp_name  = peak_folder( slash_idx(end) + 1 : slash_idx(end) + underscore_idx(1) - 1 );
    base_folder = peak_folder(1:slash_idx(end));
    psth_folder = fullfile(base_folder,sprintf('%s_PSTH_win=%dms',exp_name,round(1000*win_ms/fs)));
    mkdir(psth_folder);
    
    % --------------> COMPUTATION PHASE: Calculate PSTH
    computePSTH2(peak_folder,psth_folder, bin_ms, win_ms, blank_ms, fs);
end
clear all
