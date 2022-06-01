% @title      Analysis of recordings from MED64
% @file       MED64_rec_analysis.m
% @author     Tastuya Osaki, Romain Beaubois
% @date       06 Jul 2021
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

%% Clear %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clear all
    close all
    clc

%% Path handling %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    addpath('functions')

%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % <EDIT> >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  
        % Recording file format
            f_type          = 'bin';    % File format of trace
            f_get_type      = 'one';    % File analysis mode single 'one' or multiple 'all'

        % Trace paramaters
            trace_time      = -1;   % trace duration (s), -1 for full trace 
        
        % Analysis parameters
            compute_spike_detection     = true;     % Compute spike detection
            compute_burst_detection     = true;     % Compute burst detection
            compute_spike_sorting       = false;    % Compute spike sorting
            compute_spike_clustering    = false;    % Compute spike clustering
            compute_wavelet             = false;    % Compute wavelet related analysis
            compute_brainw_wave         = false;    % Compute brainw wave analysis

        % Saving parameters
            save_data       = true;    % Save processed data to .mat format
            save_fig        = true;    % Save figures
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    % Ask files to analyze to user
    prev_path       = pwd();
    [fpath, nb_f]   = get_files(f_get_type, f_type);

    % Ask save path to user
    save_path       = uigetdir(pwd,'Select saving folder');
    cd(prev_path);

    % Build save parameters structure
    save_param      = struct( ...
        'path', save_path, ...
        'data', save_data, ...
        'fig',  save_fig ...
    );

    % Build computation parameters structure
    compute_param   = struct( ...
        'spike_detection',      compute_spike_detection,    ...
        'burst_detection',      compute_burst_detection,    ...
        'spike_sorting',        compute_spike_sorting,      ...
        'spike_clustering',     compute_spike_clustering,   ...
        'wavelet',              compute_wavelet,            ...
        'brain_wave',           compute_brainw_wave         ...
    );

%% Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Compute analysis for all files
    for i = 1:nb_f
        % Analyze trace
        trace_analysis(f_type, fpath(i), trace_time, compute_param, save_param);
    end

%% Plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Example figure : Low pass filtered data 
        % figure
        % subplot(211)
        % plot(time_ms, LP_Signal_fix(:,3));
        % title('42')
        % subplot(212)
        % plot(Signal(:,1), Signal(:,4));
        % title('21')

    % Example figure : Low pass filtered data 
        % figure
        % plot(1e-3*Signal(:,1), Signal(:,4));
        % ylim([-5;5])
        
        % figure
        % plot(1e-3*Signal([20*20e3:30*20e3],1), Signal([20*20e3:30*20e3],4));
        % ylim([-5;5])

    % Example figure : Low pass filtered data 
    %     figure
    %     for i = 1:64
    %         subplot(8,8, i)
    %         plot(1e-4*time_ms, LP_Signal_fix(:,i));
    %         title(i)
    %         ylim([-5;5])
    % %         axis off
    % %         set(gca,'XColor', 'none','YColor','none')
    %     end