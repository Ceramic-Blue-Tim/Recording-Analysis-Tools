% @title      Create sequence information file for recordings
% @file       MED64_rec_sequencer.m
% @author     Romain Beaubois
% @date       04 Jul 2022
% @copyright
% SPDX-FileCopyrightText: © 2022 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Create sequence information file for recordings
% 
% @details
% > **04 Jul 2022** : file creation (RB)

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
        split_list      = ["C1Exp1", "C1Exp2", "C1Exp4", "C1Exp5", "C1Exp6"]; % Experiments to associate with information file

    % Splitting sequence
        sequence_label              = ["stim_off1", "stim_on1", "stim_off2", "stim_on2", "stim_off3"]; % Label for each sequence
        sequence_duration_s         = [5*60, 5*60, 5*60, 5*60, 5*60]; % Duration of sequences [s]
        electrodes_stim             = [39:8:63 40:8:64]; % Stimulated electrodes
        electrodes_no_stim_close    = [37:8:61 38:8:62]; % Stimulated electrodes
        electrodes_no_stim_far      = [33:8:57 34:8:58]; % Stimulated electrodes
        stim_width                  = 50; % Width of stimulation [ms]
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


% Temporary structure
el_list = struct(...
    'stim',             electrodes_stim, ...
    'no_stim_close',    electrodes_no_stim_close, ...
    'no_stim_far',      electrodes_no_stim_far ...
);

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

%% Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute analysis for all files
for i = 1:nb_f
    % Split files
    [dir_path, exp_name, ~] = fileparts(fpath(i));
    gen_exp_params(dir_path, exp_name, sequence_label, sequence_duration_s, el_list, stim_width);
end