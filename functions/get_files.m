% @title      Get files path
% @file       get_files.m
% @author     Romain Beaubois
% @date       02 Jun 2022
% @copyright
% SPDX-FileCopyrightText: © 2021 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Get files path
% 
% @details
% > **06 Jul 2021** : file creation (RB)
% > **02 Jun 2022** : add recursive search of files in folder (/!\ ver>2016) (RB)

function [fpath, nb_files] = get_files(get_type, file_type)
    % generate file extension
    files_ext       = sprintf("*.%s", file_type);
    files_ext_all   = sprintf("**/*.%s", file_type);
    % Select one binary file
    if strcmp(get_type, 'one')
        [file_name, file_dir]   = uigetfile(files_ext,'Select files to analyze');   % Select file
        fpath                   = sprintf("%s%s",file_dir,file_name);               % File path
        nb_files                = 1;                                                % Get number of files in directory
    % Select all binary files in a folder
    elseif strcmp(get_type, 'all')
        file_dir             = uigetdir(pwd, 'Select folder of files to analyse');  % Select file directory
        all_files           = dir(fullfile(file_dir, files_ext_all));               % Get all files in folder
        fpath               = strings(size(all_files));                             % Array for files names
        nb_files            = size(all_files,1);                                    % Get number of binary files in directory
        for i = 1:nb_files
            fpath(i) = sprintf("%s%s%s", all_files(i).folder, filesep, all_files(i).name);
        end
    end
    
end