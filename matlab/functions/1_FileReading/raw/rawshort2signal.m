% @title      Convert raw file (short 16 bits) to matlab array
% @file       rawshort2signal.m
% @author     Romain Beaubois
% @date       20 Jun 2022
% @copyright
% SPDX-FileCopyrightText: © 2020 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Convert raw file (short 16 bits) to matlab array
% 
% @details
% > **19 Jun 2020** : file creation (RB)
% > **24 Jun 2022** : add all trace reading from file size (RB)

function [t, signal]=rawshort2signal(fileID_raw, foffset, rec_param)

    % Set measurement duration
    if rec_param.time_s < 0
        % Get recording duration from file
            file_info               = dir(bin_filename);
            file_size               = file_info.bytes;
            nb_short_data           = file_size/2 - foffset; % short (16 bits) is 2 bytes
            nb_samples              = nb_short_data/rec_param.nb_chan;
            rec_time_ms             = nb_samples / rec_param.fs * 1e3;
            rec_param.time_s        = nb_samples / rec_param.fs;
    else
        % User specified duration of file
            nb_samples  = rec_param.time_s * rec_param.fs;
            rec_time_ms = rec_param.time_s * 1e3;
    end

    % Read binary file
    A                       = fread(fileID_raw,[rec_param.nb_chan+1 nb_samples], 'short', 'n');
    time_temp               = [rec_time_ms : -1e3/rec_param.fs : 0];
    time                    = rot90(time_temp); clear time_temp;
    time(rec_time_ms+1, :)  = [];

    % Rearrange data in the variable Signal
    trans_A                 = transpose(A); clear A;
    signal                  = (trans_A-rec_param.offset_ADC)*rec_param.conv_f; clear trans_A;
    t                       = time;

end