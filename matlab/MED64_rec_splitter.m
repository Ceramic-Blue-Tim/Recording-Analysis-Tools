% @title      Split for MED64 recordings
% @file       MED64_rec_splitter.m
% @author     Romain Beaubois
% @date       21 Jun 2022
% @copyright
% SPDX-FileCopyrightText: © 2022 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Viewer for recordings of MED64
% 
% @details
% > **21 Jun 2022** : file creation (RB)

%% Clear %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clear all
    close all
    clc

%% Path handling %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    addpath(genpath('functions'))

%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % <EDIT> >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  
        % Recording file format
            f_type          = 'bin';    % File format of trace
            f_get_type      = 'one';    % File analysis mode single 'one' or multiple 'all'
        
        % Recording split list
            split_list      = ["C1Exp1", "C1Exp2", "C1Exp4", "C1Exp5", "C1Exp6"]; % Recordings to split

        % Splitting sequence
            sequence_labels     = ["stim_off1", "stim_on1", "stim_off2", "stim_on2", "stim_off3"];
            sequence_duration   = [10, 10, 10, 10, 10];      % [s]
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    % Ask files to analyze to user
    prev_path       = pwd();
    [fpath, nb_f]   = get_files(f_get_type, f_type);

    % Remove file that aren't in list
    if strcmp(f_get_type, 'all')
        z = 1;
        for j = 1:nb_f
            found = false;
            for i = 1:length(split_list)
                % If match
                if strfind(fpath(j), split_list(i)) > 0
                    found = true;
                    break;
                end
            end

            if ~found
                rmv_id(z) = j;
                z = z + 1;
            end
        end
        if exist('rmv_id')
            fpath(rmv_id) = [];
            nb_f = nb_f - length(rmv_id);
        end
    end

    % Build sequence parameters structure
    sequence   = struct( ...
        'label',    sequence_labels,            ...
        'duration', sequence_duration,          ...
        'nb',       length(sequence_labels)     ...
    );

%% Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Compute analysis for all files
    for i = 1:nb_f
        % Split files
        split_bin_file(fpath(i), sequence);
    end


