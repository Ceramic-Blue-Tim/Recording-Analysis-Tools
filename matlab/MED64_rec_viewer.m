% @title      Viewer for MED64 recordings
% @file       MED64_rec_viewer.m
% @author     Romain Beaubois
% @date       07 Jun 2022
% @copyright
% SPDX-FileCopyrightText: © 2022 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Viewer for recordings of MED64
% 
% @details
% > **07 Jun 2022** : file creation (RB)

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
            trace_time      = 1;   % trace duration (s), -1 for full trace 
        
        % Plotting parameters
            plot_raster                 = true;         % Plot raster
            plot_activity_all           = true;         % Plot activity of all electrodes
            plot_activity_one           = 36;           % Plot activity of one electrode (-1 : disabled)
            plot_activity_time_range    = [-1 ; 0];    % Activity time range plotted (s) ([-1;0] : all trace)

        % Saving parameters
            save_data       = false;    % Save processed data to .mat format
            save_fig        = false;    % Save figures
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    % Ask files to analyze to user
    prev_path       = pwd();
    [fpath, nb_f]   = get_files(f_get_type, f_type);

    % Ask save path to user if only one file
    if strcmp(f_get_type, 'one') 
        save_path       = uigetdir(pwd,'Select saving folder');
        cd(prev_path);
    else
        save_path = "";
    end

    % Build plotting parameters structure
    plot_param   = struct( ...
        'raster',               plot_raster,         ...
        'activity_all',         plot_activity_all,   ...
        'activity_one',         plot_activity_one,   ...
        'activity_time_range',  plot_activity_time_range   ...
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
        if strcmp(f_get_type, 'all') 
            save_param.path = fileparts(fileparts(fpath(i))) + filesep + "analysis";
            mkdir(save_param.path);
        end

        % Analyze trace
        [t, raw_signal, lpf_signal, hpf_signal, rec_param] = trace_view(f_type, fpath(i), trace_time, plot_param);
    end

%% Plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Select time stamp file
    [file_name, file_dir]   = uigetfile('*.csv','Select time stamp file');   % Select file
    fpath                   = sprintf("%s%s",file_dir,file_name);
    tstamp                  = tstamp2array(fpath);
    tstamp_sid              = tstamp * (rec_param.fs/1e3); % time stamp in sample id

    % Create stim pattern
    stim_state = zeros(length(t), 1);
    stim_state(tstamp_sid)  = 1;

    if length(stim_state) > length(t) % in case time stamp is longer than recording
        stim_state = stim_state(1:length(t));
    end

    e = 36;
    % Plot with stim as plot of one electrode
    figure;
    yyaxis left
    plot(t, raw_signal(:,e));
    hold on
    yyaxis right
    plot(t, stim_state);
    
    % Plot with stim as plot of one electrode
    padded_tstamp   = [tstamp/1e3 ; zeros(length(t)-length(tstamp),1)];
    stim_state      = double((padded_tstamp>0));
    figure;
    yyaxis left
    plot(t, raw_signal(:,e));
    hold on
    yyaxis right
    scatter(padded_tstamp, stim_state, 5, 'filled');


