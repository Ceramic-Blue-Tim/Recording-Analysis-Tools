% @title      Read raw file from MCS
% @file       read_raw.m
% @author     Romain Beaubois
% @date       24 Jun 2022
% @copyright
% SPDX-FileCopyrightText: © 2021 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Read binary files using hdr parameters files
% 
% @details
% > **06 Jul 2021** : file creation (RB)
% > **24 Jun 2022** : update file reading (RB)

function [t, Signal, fname_no_ext, rec_param] = read_raw(raw_fpath, rec_duration_secs)

        % Get file path
        [raw_dir, fname_no_ext, ~]  = fileparts(raw_fpath);

        % Open file
        raw_fid                     = fopen(raw_fpath, 'r', 'n', 'UTF-8');

        % Get recording parameters
            foffs               = 0;
            foffs               = foffs + length(fgetl(raw_fid)); % skip line
            foffs               = foffs + length(fgetl(raw_fid)); % skip line
            foffs               = foffs + length(fgetl(raw_fid)); % skip line

            % Sampling frequency
            line                = fgetl(raw_fid);
            foffs               = foffs + length(line);
            sampling_freq       = sscanf(line, "Sample rate = %d");

            % ADC zero
            line                = fgetl(raw_fid);
            foffs               = foffs + length(line);
            zero_ADC            = sscanf(line, "ADC zero = %d");

            % Conversion factor
            line                = fgetl(raw_fid);
            foffs               = foffs + length(line);
            conv_factor         = sscanf(line, "El = %fµV/AD");

            % Active channels
            line                = fgetl(raw_fid);
            foffs               = foffs + length(line);
            tmp_active_chans    = string(line);
            active_channels     = split(sscanf(tmp_active_chans, "Streams = %s"),';');
            
            foffs               = foffs + length(fgetl(raw_fid)); % skip line
    
        % Create structure with recordinf parameters
        rec_param = struct(... 
            'fs', sampling_freq,...
            'time_s', rec_duration_secs, ...
            'conv_f', conv_factor, ...
            'offset_ADC', zero_ADC, ...
            'active_chan', string(active_channels(2:end)), ...
            'nb_chan', length(active_channels)-1 ...
        );
    
        clear file_format session_start sampling_freq conv_factor active_channels

        fprintf(sprintf("[Loading] : %s\n", fname_no_ext));   % Display file selected
        [t, Signal] = rawshort2signal(raw_fid, foffs, rec_param);
        fclose(raw_fid);
    end