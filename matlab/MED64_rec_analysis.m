% @title      Analysis of recordings from MED64
% @file       MED64_rec_analysis.m
% @author     Tatsuya Osaki, Romain Beaubois
% @date       02 Jun 2022
% @copyright
% SPDX-FileCopyrightText: © 2020 Tatsuya Osaki <osaki@iis.u-tokyo.ac.jp>
% SPDX-FileCopyrightText: © 2021 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Analysis of recordings from MED64
% 
% @details
% > **19 Jun 2020** : file creation (TO)
% > **06 Jul 2021** : add bin recordings parameters fetching from hdr file (RB)
% > **02 Jun 2022** : clean script, update user parameters, add fetch of all binaries in a folder, automatic folder creation for saving (RB)

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

        % Trace paramaters
            trace_time      = -1;   % trace duration (s), -1 for full trace 
        
        % Analysis parameters
            compute_spike_detection     = true;     % Compute spike detection
            compute_burst_detection     = false;     % Compute burst detection
            % compute_spike_sorting       = false;    % Compute spike sorting
            % compute_spike_clustering    = false;    % Compute spike clustering
            % compute_wavelet             = false;    % Compute wavelet related analysis
            % compute_brainw_wave         = false;    % Compute brainw wave analysis

        % Saving parameters
            save_path_sel   = 'auto';   % Choice of save path ('auto' or 'user')
            save_data       = true;    % Save processed data to .mat format
            save_fig        = false;    % Save figures
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    % Ask files to analyze to user
    prev_path       = pwd();
    [fpath, nb_f]   = get_files(f_get_type, f_type);

    % Ask save path to user if only one file
    if strcmp(save_path_sel, 'user')
        save_path       = uigetdir(pwd,'Select saving folder');
        cd(prev_path);
    else
        save_path       = "";
    end

    % Build computation parameters structure
    compute_param   = struct( ...
        'spike_detection',      compute_spike_detection,    ...
        'burst_detection',      compute_burst_detection,    ...
        'spike_sorting',        compute_spike_sorting,      ...
        'spike_clustering',     compute_spike_clustering,   ...
        'wavelet',              compute_wavelet,            ...
        'brain_wave',           compute_brainw_wave         ...
    );

    % Build save parameters structure
    save_param      = struct( ...
        'path', save_path, ...
        'data', save_data, ...
        'fig',  save_fig ...
    );

%% Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Compute analysis for all files
    for i = 1:nb_f
        % Generate save path
        if strcmp(save_path_sel, 'auto') 
            save_param.path = fileparts(fileparts(fpath(i))) + filesep + "analysis";
            mkdir(save_param.path);
        end

        % Analyze trace
        trace_analysis(f_type, fpath(i), trace_time, compute_param, save_param);
    end