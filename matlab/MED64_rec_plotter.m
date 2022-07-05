% @title      Plot figures from MED64 recording analysis
% @file       MED64_rec_plotter.m
% @author     Romain Beaubois
% @date       07 Jun 2022
% @copyright
% SPDX-FileCopyrightText: © 2022 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Plot figures from MED64 recording analysis
% 
% @details
% > **07 Jul 2022** : file creation (RB)

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
        
        % Plotting parameters
            plot_raster     = true;     % Plot raster

        % Saving parameters
            save_path_sel   = 'auto';   % Choice of save path ('auto' or 'user')
            save_data       = false;    % Save processed data to .mat format
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


    % Build plotting parameters structure
    plot_param   = struct( ...
        'raster', plot_raster ...
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
        analysis_plotter(fpath(i), plot_param, save_param);
    end

%% Plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % % Select time stamp file
    % [file_name, file_dir]   = uigetfile('*.csv','Select time stamp file');   % Select file
    % fpath                   = sprintf("%s%s",file_dir,file_name);
    % tstamp                  = tstamp2array(fpath);
    % tstamp_sid              = tstamp * (rec_param.fs/1e3); % time stamp in sample id

    % % Create stim pattern
    % stim_state = zeros(length(t), 1);
    % stim_state(tstamp_sid)  = 1;

    % if length(stim_state) > length(t) % in case time stamp is longer than recording
    %     stim_state = stim_state(1:length(t));
    % end

    % e = 36;
    % % Plot with stim as plot of one electrode
    % figure;
    % yyaxis left
    % plot(t, raw_signal(:,e));
    % hold on
    % yyaxis right
    % plot(t, stim_state);
    
    % % Plot with stim as plot of one electrode
    % padded_tstamp   = [tstamp/1e3 ; zeros(length(t)-length(tstamp),1)];
    % stim_state      = double((padded_tstamp>0));
    % figure;
    % yyaxis left
    % plot(t, raw_signal(:,e));
    % hold on
    % yyaxis right
    % scatter(padded_tstamp, stim_state, 5, 'filled');

    % % Plot raster with area for stimulation
    % figure;
    % stim_width  = 50;   % [ms]
    % wavelength  = 470;  % [nm]
    % stim_color  = '#00a9ff'; % https://academo.org/demos/wavelength-to-colour-relationship/

    % fig_stim_width = stim_width*1e-3*rec_param.fs;
    % for i = 1:length(tstamp_sid)
    %     if tstamp_sid(i)+fig_stim_width < length(t)
    %         area([t(tstamp_sid(i)) t(tstamp_sid(i)+fig_stim_width)], [rec_param.nb_chan rec_param.nb_chan], 'FaceColor', stim_color, 'EdgeColor', stim_color)
    %     end
    %     hold on
    % end
    % scatter(raster_x, raster_y, 5, 'filled', 'r')


