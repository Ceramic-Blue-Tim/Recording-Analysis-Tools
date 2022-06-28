% MAIN_mat2pkdOK.m
% Script for managing MAT files (previously converted from DAT) and
% converting them into PEAK DETECTION files. The novelty of the sw is that the PD is made by a user-set inspection
% window and the absolute position of the peak is saved, instead of having the peak always in the same
% position of the window. In this way, the timing of each spike is maintained.

% by Michela Chiappalone (17 Gennaio 2006, 7 Febbraio 2006, Giugno 2010)

% -----------> INPUT FROM THE USER
[start_folder]= selectfolder('Select the .mat files folder');
if isempty (start_folder)
    return
end
slashindex=strfind(start_folder, filesep);
[pdwin, art_thresh, art_dist, nstd, fs, cancelFlag]= uigetPDinfo; % pdwin & art_dist [number of samples]

if cancelFlag
    return
else
    %% -----------> FOLDER MANAGEMENT
    cd (start_folder);
    
    % the following IF is necessary if the user has selected a specific
    % phase and not the entire Mat Files directory
    if isempty (strfind(lower(start_folder(slashindex(end):end)), 'mat_files'))
        cd ..        
    end
    
    start_folder=pwd;   % Folder containing the MAT files
    matdir=dir;
    cd(matdir(3).name)  % if the entire Mat Files folder was selected, the first phase is the default
    firstmatfolder=pwd; % First folder of the Mat_files
    
    [exp_num]=find_expnum(lower(start_folder), '_mat_files');
    threshfile = strcat (exp_num,'_', 'thresh_vectorfile.mat');
    cd .. % Mat_files folder
    cd .. % Experiment folder   
    end_folder = pwd;   % Folder of the experiment
    
    subfoldername2 = strcat(exp_num, '_PeakDetectionMAT_', num2str(pdwin*1000/fs),'msec');
    warning off MATLAB:MKDIR:DirectoryExists
    mkdir (subfoldername2) % Directory for peak detection MAT files is created
    cd (subfoldername2)
    PeakDetectionFolder= pwd;   % Save the path for subfoldername2 
    

    %% --------------> COMPUTATION PHASE 1: Threshold evaluation
    cd(end_folder)
    end_folderdir=dir;
    end_foldernum=length(dir);
    if isempty(strmatch(threshfile, strvcat(end_folderdir(1:end_foldernum).name),'exact'))
        msgbox(strvcat('Threshold file is missing',...
            'The panel for calculating the threshold will appear'),'Warning', 'warn')
        uiwait
        [threshfile]=ComputeThresholdGUI(exp_num, firstmatfolder, end_folder); % thresh_vector is also into end_folder
    end
    load(threshfile); % thresh_vector is now loaded

    %% --------------> COMPUTATION PHASE 2: From MAT to PKD
    peak_detectionOK (pdwin, fs, art_thresh, art_dist, thresh_vector, start_folder, PeakDetectionFolder)

    EndOfProcessing (start_folder, 'Successfully accomplished');
end

