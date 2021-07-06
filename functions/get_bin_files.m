function [bin_fpath, nb_bin] = get_bin_files(get_type)

    % Select one binary file
    if strcmp(get_type, 'one')
        [bin_file, bin_dir] = uigetfile('*.bin','Select binary file to analyze'); % Select binary file
        bin_fpath           = sprintf("%s%s",bin_dir,bin_file);     % File path
        nb_bin              = 1;                                    % Get number of binary files in directory
    % Select all binary files in a folder
    elseif strcmp(get_type, 'all')
        bin_dir             = uigetdir(pwd, 'Select folder for binary files'); % Select binary file directory
        bin_files           = dir(fullfile(bin_dir, '*.bin'));      % Get all binaries files in folder
        bin_fpath           = strings(size(bin_files));             % Array for files names
        nb_bin              = size(bin_files,1);                    % Get number of binary files in directory
        for i = 1:nb_bin
            bin_fpath(i) = sprintf("%s%s%s", bin_files(i).folder, filesep, bin_files(i).name);
        end
    end
    
end