% @title      Read hdr file (MED64 recording parameters)
% @file       read_hdr.m
% @author     Romain Beaubois
% @date       05 Jul 2022
% @copyright
% SPDX-FileCopyrightText: © 2022 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Read hdr file (MED64 recording parameters)
% 
% @details
% > **05 Jul 2022** : file creation (RB)

function rec_param = read_hdr(fpath)
    hdr_fid             = fopen(fpath);
    file_format         = sscanf(fgetl(hdr_fid), "File Format Version, %d");
    session_start       = sscanf(fgetl(hdr_fid), "Session Start Time, %s");
    sampling_freq       = sscanf(fgetl(hdr_fid), "Sampling freq (Hz), %d");
    conv_factor         = sscanf(fgetl(hdr_fid), "Conversion factor: short to mV, %lf");
    active_channels     = split(string(fgetl(hdr_fid)),',');

    rec_param = struct(... 
        'format', file_format,...
        'start_t', session_start,...
        'fs', sampling_freq,...
        'time_s', 0, ...
        'conv_f', conv_factor, ...
        'active_chan', double(active_channels(2:end)), ...
        'nb_chan', length(active_channels)-1 ...
    );
    
    fclose(hdr_fid);
end