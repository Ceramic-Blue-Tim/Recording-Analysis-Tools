% MAIN_mat2pkd_PTSD_autThComp.m
% Script for managing MAT files (previously converted from DAT) and
% converting them into PEAK DETECTION files. The novelty of the sw is that the PD is made by a user-set inspection
% window and the absolute position of the peak is saved, instead of having the peak always in the same
% position of the window. In this way, the timing of each spike is maintained.

% by Michela Chiappalone (17 Gennaio 2006, 7 Febbraio 2006) March 2010 
% modified by Mauro Gandolfo (28 Ottobre 2006)
% modified by Pieter Laurens (year 2009), to add mex file
% modified by Valentina Pasquale (year 2009), to add automatic threshold computation
% modified by Michela Chiappalone (March 2010), to debug the entire code


% -----------> INPUT FROM THE USER
[mat_folder]= selectfolder('Select the .mat files folder');
slashindex=strfind(mat_folder, filesep);

if strcmp(num2str(mat_folder),'0')
    errordlg('Wrong selection - End of Session', 'Error');
    return
elseif isempty (strfind(lower(mat_folder(slashindex(end):end)), 'mat_files'))
    errordlg('Wrong selection - End of Session', 'Error');
    return
else
    cd (mat_folder);
    mat_folder=pwd; % Folder containing the MAT files
end

% [plp, rp, art_thresh_analog, art_thresh_elec, art_dist, nstd, fs, cancelFlag]= uigetRTSDinfo; 
[plp, rp, alignmentFlag, art_thresh_analog, art_thresh_elec, art_dist, nstd, fs, w_pre, w_post, interpolation, cancelFlag]= uigetRTSDinfo_VP;

if cancelFlag
    errordlg('Operation aborted by user', 'Error')
    return
else    
    %% -----------> FINAL FOLDER MANAGEMENT
    [exp_num] = find_expnum(lower(mat_folder), '_mat_files');
    threshfile = strcat (exp_num,'_', 'thresh_vectorfile.mat');

    cd (mat_folder);
    cd ..
    exp_folder=pwd;   % Folder of the experiment
    pkd_folder = strcat(exp_num, '_PeakDetectionMAT_PLP', num2str(plp*1000/fs),'ms_RP', num2str(rp*1000/fs),'ms');
    warning off MATLAB:MKDIR:DirectoryExists
    mkdir (pkd_folder) % Directory for peak detection MAT files is created
    cd (pkd_folder)
    pkd_folder= pwd;   % Save the path for subfoldername2

    
    %% --------------> COMPUTATION PHASE 1: Threshold evaluation
    cd(exp_folder)
    exp_folderdir = dir;
    exp_foldernum = length(dir);
    
    if isempty(strmatch(threshfile, strvcat(exp_folderdir(1:exp_foldernum).name),'exact'))

        button = questdlg('Automatic threshold computation?');
        if strcmp(button,'Yes')
            thresh_vector = [];
        else if strcmp(button,'No')
                h=msgbox(strvcat('Threshold file is missing','The panel for calculating the threshold will appear'),'Warning', 'warn');
                uiwait(h)
                [threshfile] = ComputeThresholdGUI(exp_num, mat_folder, exp_folder);
                load(threshfile); % thresh_vector is loaded
            else if isempty(button) || strcmp(button,'Cancel')
                    clear all
                    return
                end
            end
        end
    else
        load(threshfile); % thresh_vector is now loaded
    end
    
    %--------------> COMPUTATION PHASE 2: From MAT to PKD
    % new with MEX file, PL 05/09
    if( ~ispc ) % Check if the operation is launched under Windows
        fprintf('not a pc, mex file may not work.\nconsider making matlab compile under MacOS, or use spikemanager <1.5.5.\n')
    end
    
    % Spike Detection is launched...
%     peak_detection_PTSD_mex_autThComp (plp, rp, fs, art_thresh_analog, art_thresh_elec, art_dist, ...
%         thresh_vector, nstd, mat_folder, pkd_folder)
    peak_detection_PTSD_mex_autThComp_VP (plp, rp, alignmentFlag, fs, art_thresh_analog, art_thresh_elec, art_dist, ...
        thresh_vector, nstd, w_pre, w_post, interpolation, mat_folder, pkd_folder)

    EndOfProcessing (mat_folder, 'Successfully accomplished');
end