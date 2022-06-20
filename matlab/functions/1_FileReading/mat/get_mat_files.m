function [mat_fpath, nb_mat] = get_mat_files(get_type)

    % Select one binary file
    if strcmp(get_type, 'one')
        [mat_file, mat_dir] = uigetfile('*.mat','Select .mat file to analyze'); % Select .mat file
        mat_fpath           = sprintf("%s%s",mat_dir,mat_file);     % File path
        nb_mat              = 1;                                    % Get number of binary files in directory
    % Select all binary files in a folder
    elseif strcmp(get_type, 'all')
        mat_dir             = uigetdir(pwd, 'Select folder for .mat files'); % Select .mat file directory
        mat_files           = dir(fullfile(mat_dir, '*.mat'));      % Get all .mat files in folder
        mat_fpath           = strings(size(mat_files));             % Array for files names
        nb_mat              = size(mat_files,1);                    % Get number of .mat files in directory
        for i = 1:nb_mat
            mat_fpath(i) = sprintf("%s%s%s", mat_files(i).folder, filesep, mat_files(i).name);
        end
    end
    
end