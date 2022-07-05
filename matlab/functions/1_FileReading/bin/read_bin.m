% @title      Read binary file using hdr parameters
% @file       read_bin.m
% @author     Romain Beaubois
% @date       20 Jun 2022
% @copyright
% SPDX-FileCopyrightText: © 2021 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Read binary files using hdr parameters files
% 
% @details
% > **06 Jul 2021** : file creation (RB)
% > **20 Jun 2022** : update file reading (RB)
% > **05 Jul 2022** : add function for hdr file reading (RB)

function [t, Signal, fname_no_ext, rec_param] = read_bin(bin_fpath, rec_duration_secs)

    % Get parameters from hdr files
        [bin_dir, fname_no_ext, ~] = fileparts(bin_fpath);
        hdr_dir             = bin_dir;   % .hdr and .bin files in same directory
        hdr_fpath           = fullfile(hdr_dir, fname_no_ext + ".hdr");
        rec_param           = read_hdr(hdr_fpath);
        rec_param.time_s    = rec_duration_secs;
        
    % Load signal from binary file
        fprintf(sprintf("[Loading] Recording : %s\n", fname_no_ext));   % Display file selected
        [t, Signal] = binshort2signal(bin_fpath, rec_param);
end