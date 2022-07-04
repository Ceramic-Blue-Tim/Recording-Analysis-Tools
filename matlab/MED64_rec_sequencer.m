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
        sequence_label      = ["stim_off1", "stim_on1", "stim_off2", "stim_on2", "stim_off3"]; % Label for each sequence
        sequence_duration_s = [5*60, 5*60, 5*60, 5*60, 5*60]; % Duration of sequences [s]
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

%% Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute analysis for all files
for i = 1:nb_f
    % Split files
    [dir_path, exp_name, ~] = fileparts(fpath(i));
    gen_exp_params(dir_path, exp_name, sequence_label, sequence_duration_s);
end