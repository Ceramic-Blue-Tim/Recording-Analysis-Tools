% @title      Split binary file
% @file       split_bin_file.m
% @author     Romain Beaubois
% @date       29 Jun 2022
% @copyright
% SPDX-FileCopyrightText: © 2022 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Split a binary file according to sequence
% 
% @details
% > **21 Jun 2022** : file creation (RB)
% > **29 Jun 2022** : add creation of split info file (RB)

function split_bin_file(bin_fpath, sequence)

    %% Get recording parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Path and file handling
        [bin_dir, fname_no_ext, ~]  = fileparts(bin_fpath); % Get path to bin directory
        hdr_dir                     = bin_dir;   % .hdr and .bin files in same directory
        hdr_fpath                   = sprintf("%s%s%s.hdr", hdr_dir, filesep, fname_no_ext); % Generate .hdr path file
        hdr_fid                     = fopen(hdr_fpath); % Open file

    % Read hdr file
        sscanf(fgetl(hdr_fid), "File Format Version, %d");
        sscanf(fgetl(hdr_fid), "Session Start Time, %s");
        sampling_freq       = sscanf(fgetl(hdr_fid), "Sampling freq (Hz), %d");
        conv_factor         = sscanf(fgetl(hdr_fid), "Conversion factor: short to mV, %lf");
        active_channels     = split(string(fgetl(hdr_fid)),',');

    % Close hdr file
        fclose(hdr_fid);

    % Create recording parameters structure
        rec_param = struct(... 
            'fs', sampling_freq,...
            'conv_f', conv_factor, ...
            'nb_chan', length(active_channels)-1 ...
        );
        clear file_format session_start sampling_freq conv_factor active_channels

    %% Split binary file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % File handling
            fprintf(sprintf("[Splitting] : %s\n", fname_no_ext));   % Display file selected
            fileID_bin              = fopen(bin_fpath);
            file_info               = dir(bin_fpath);
            file_size               = file_info.bytes;
            file_nb_short_data      = file_size/2; % short (16 bits) is 2 bytes
            file_nb_samples         = file_nb_short_data/rec_param.nb_chan;
            cnt_read_smamples       = 0;
    
        % Read file according to sequence
            % For all sequences
            for i = 1:sequence.nb
                % For last sequence
                if i == sequence.nb
                    % Remain samples > required samples : read nb_required
                    if (file_nb_samples - cnt_read_smamples) > sequence.duration(i)
                        nb_samples_to_read  = sequence.duration(i) * rec_param.fs;
                    % Remain samples < required samples : read nb_remaining (truncate)
                    else
                        nb_samples_to_read  = file_nb_samples - cnt_read_smamples;
                    end
                % For other sequences
                else
                    nb_samples_to_read  = sequence.duration(i) * rec_param.fs; % Read samples
                end
                
                % Read data from file
                rdata               = fread(fileID_bin, rec_param.nb_chan*nb_samples_to_read, 'short=>short', 'n');

                % Open output file
                fpath_splitbin      = sprintf("%s%s%s_%s.bin", bin_dir, filesep, fname_no_ext, sequence.label(i));
                fileID_splitbin     = fopen(fpath_splitbin, 'w');

                % Write data in file
                fwrite(fileID_splitbin, rdata, 'short');
                fprintf(sprintf("[Saved] : Sequence %s to file %s_%s\n", sequence.label(i), fname_no_ext, sequence.label(i)));   % Display file selected

                % Duplicate hdr file
                new_hdr_fpath = sprintf("%s%s%s_%s.hdr", hdr_dir, filesep, fname_no_ext, sequence.label(i));
                copyfile(hdr_fpath,new_hdr_fpath);

                % Update number of samples read
                cnt_read_smamples = cnt_read_smamples + nb_samples_to_read;

                % Close output split file
                fclose(fileID_splitbin);
            end

            % Close file
            fclose(fileID_bin);
    
    %% Create sequence information file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Handling information file
            fpath_seq_info  = sprintf("%s%s%s.txt", bin_dir, filesep, fname_no_ext); % Generate file path
            fid_seq_info    = fopen(fpath_seq_info, 'w'); % Open file in write mode
            sep             = ';';
        
        % Write number of sequences
            fprintf(fid_seq_info, "nb" + sep);
            fprintf(fid_seq_info, string(sequence.nb));
            fprintf(fid_seq_info, "\n");
        
        % Write labels of sequences
            fprintf(fid_seq_info, "label" + sep);
            for i = 1:sequence.nb
                fprintf(fid_seq_info, sequence.label(i));
                if i < sequence.nb
                    fprintf(fid_seq_info, sep);
                end
            end
            fprintf(fid_seq_info, "\n");
        
        % Write duration in seconds of sequences
            fprintf(fid_seq_info, "duration_s" + sep);
            for i = 1:sequence.nb
                fprintf(fid_seq_info, string(sequence.duration(i)));
                if i < sequence.nb
                    fprintf(fid_seq_info, sep);
                end
            end
end