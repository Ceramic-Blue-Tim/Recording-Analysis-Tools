% @title      Split binary file
% @file       split_bin_file.m
% @author     Romain Beaubois
% @date       21 Jun 2022
% @copyright
% SPDX-FileCopyrightText: © 2022 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Split a binary file according to sequence
% 
% @details
% > **21 Jun 2022** : file creation (RB)

function split_bin_file(bin_fpath, sequence)

    % Get parameters from hdr files
    [bin_dir, fname_no_ext, ~] = fileparts(bin_fpath);
    hdr_dir             = bin_dir;   % .hdr and .bin files in same directory
    hdr_fpath           = sprintf("%s%s%s.hdr", hdr_dir, filesep, fname_no_ext);

    hdr_fid             = fopen(hdr_fpath);
    sscanf(fgetl(hdr_fid), "File Format Version, %d");
    sscanf(fgetl(hdr_fid), "Session Start Time, %s");
    sampling_freq       = sscanf(fgetl(hdr_fid), "Sampling freq (Hz), %d");
    conv_factor         = sscanf(fgetl(hdr_fid), "Conversion factor: short to mV, %lf");
    active_channels     = split(string(fgetl(hdr_fid)),',');

    rec_param = struct(... 
        'fs', sampling_freq,...
        'conv_f', conv_factor, ...
        'nb_chan', length(active_channels)-1 ...
    );

    clear file_format session_start sampling_freq conv_factor active_channels
    
    fclose(hdr_fid);
    
    % Load signal from binary file
    fprintf(sprintf("[Splitting] : %s\n", fname_no_ext));   % Display file selected

    % Open file
    fileID_bin              = fopen(bin_fpath);
    file_info               = dir(bin_fpath);
    file_size               = file_info.bytes;
    file_nb_short_data      = file_size/2; % short (16 bits) is 2 bytes
    file_nb_samples         = file_nb_short_data/rec_param.nb_chan;
    cnt_read_smamples       = 0;
    
    for i = 1:sequence.nb
        % Handle the case where trace end isn't perfectly timed
        if i == sequence.nb
            if (file_nb_samples - cnt_read_smamples) > sequence.duration(i) % Read to remain samples that are more than required
                nb_samples_to_read  = sequence.duration(i) * rec_param.fs;
            else
                nb_samples_to_read  = file_nb_samples - cnt_read_smamples; % Read to remain samples that are less than required
            end
        else
            nb_samples_to_read  = sequence.duration(i) * rec_param.fs; % Read samples
        end
        
        % Read data from file
        rdata               = fread(fileID_bin,[rec_param.nb_chan nb_samples_to_read], 'short', 'n');
        
        % Open output file
        fpath_splitbin      = sprintf("%s%s%s_%s.bin", bin_dir, filesep, fname_no_ext, sequence.label(i));
        fileID_splitbin     = fopen(fpath_splitbin, 'w');

        % Write data in file
        fwrite(fileID_splitbin, rdata);
        fprintf(sprintf("[Saved] : Sequence %s to file %s_%s\n", sequence.label(i), fname_no_ext, sequence.label(i)));   % Display file selected

        % Duplicate hdr file
        new_hdr_fpath = sprintf("%s%s%s_%s.hdr", hdr_dir, filesep, fname_no_ext, sequence.label(i));
        copyfile(hdr_fpath,new_hdr_fpath);

        % Update number of samples read
        cnt_read_smamples = cnt_read_smamples + nb_samples_to_read;
        fclose(fileID_splitbin);
    end

    % Close file
    fclose(fileID_bin);

end