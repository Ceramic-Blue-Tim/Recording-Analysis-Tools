% MAIN_ComputeThreshold
% This script allow the user to calculate the threshold for each channel
% without starting the spike detection procedure.
% The variables for the threshold computation are editable from the GUI
% Additional checks for the correct folder/file management are provided

% by M. Chiappalone (March 23-24, 2010)

% -----------> INPUT FROM THE USER
[start_folder]= selectfolder('Select a single experimental phase (.mat files)');
if strcmp(num2str(start_folder),'0')
    errordlg('Selection Failed - End of Session', 'Error');
    return
end

% -----------> FOLDER MANAGEMENT
slashindex=strfind(start_folder, filesep);
cd (start_folder);

% check if the selected folder is correct
if isempty (strfind(lower(start_folder(slashindex(end):end)), 'mat_files'))
    cd ..
    matfilesfolder=pwd; % Folder which should containing the MAT files (after the check)
    slashindex=strfind(matfilesfolder, filesep);    
    if isempty (strfind(lower(matfilesfolder(slashindex(end):end)), 'mat_files'))
        errordlg('The selcted folder does not contain .mat files', 'Error');        
        return        
    else
        [exp_num]=find_expnum(lower(matfilesfolder), '_mat_files');
    end    
else
    matfilesfolder = start_folder; % folder containing all the MAT files
    matdir=dir;
    cd(matdir(3).name)% if the entire Mat Files folder was selected, the first phase is the default
    start_folder=pwd;
    [exp_num]=find_expnum(lower(matfilesfolder), '_mat_files');
end

cd(matfilesfolder) % Go to the MAT files folder
cd ..              % Go up one level
end_folder=pwd;    % Folder of the experiment
end_folderdir=dir; % Prepare to look for the presence of the thresh vector file
end_foldernum=length(dir);
clear matdir matfilesfolder slashindex

% --------------> COMPUTATION PHASE: Threshold evaluation
threshfile = strcat (exp_num,'_', 'thresh_vectorfile.mat');

if isempty(strmatch(threshfile, strvcat(end_folderdir(1:end_foldernum).name),'exact'))
    [threshfile]=ComputeThresholdGUI(exp_num, start_folder, end_folder); % thresh_vector is also into end_folder
else
    h=msgbox ('Threshold vector already present in the exp folder', 'End Of Session', 'warn');
    uiwait(h)
end
