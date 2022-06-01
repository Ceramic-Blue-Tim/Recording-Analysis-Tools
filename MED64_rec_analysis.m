% @title      Analysis of recordings from MED64
% @file       MED64_rec_analysis.m
% @author     Romain Beaubois
% @date       06 Jul 2021
% @copyright
% SPDX-FileCopyrightText: © 2021 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Analysis of recordings from MED64
% 
% @details
% > **06 Jul 2021** : file creation (RB)

%% Clear
    clear all
    close all
    clc

%% Path handling
    addpath('functions')

%% Get files
    f_type          = 'bin';
    f_get_type      = 'one';
    prev_path       = pwd();
    [fpath, nb_f]   = get_files(f_get_type, f_type);

%% Analysis from binary files
    trace_time      = 60;    % seconds
    save_path       = uigetdir(pwd,'Select saving folder');
%     cd(prev_path);
    save_data       = false;
    save_fig        = false;
    compute         = true;
   
    save_param      = struct( ...
        'path', save_path, ...
        'data', save_data, ...
        'fig',  save_fig ...
    ); 

    for i = 1:nb_f
        trace_analysis(f_type, fpath(i), trace_time, save_param, compute);

    % Read binary file
        if strcmp(f_type, 'mat')
            tmp                 = load(fpath);
            Signal              = tmp.Signal;
            fname_no_ext        = tmp.fname_no_ext;
            rec_param           = tmp.rec_param; 
            clear tmp;
        elseif strcmp(f_type, 'bin')
            [Signal, fname_no_ext, rec_param]           = read_bin(fpath, trace_time);   % Signals of electrodes + name of file + recording parameters
        end

        % Filter signal
            [LP_Signal_fix, HP_Signal_fix, time_ms]     = filter_signal(rec_param.fs, rec_param.nb_chan, Signal);

    end

%% 
    figure
    subplot(211)
%     plot(Signal(:,1), Signal(:,3));
    plot(time_ms, LP_Signal_fix(:,3));
    title('42')
    subplot(212)
    plot(Signal(:,1), Signal(:,4));
    title('21')
%%
    figure
    plot(1e-3*Signal(:,1), Signal(:,4));
    ylim([-5;5])
    
    figure
    plot(1e-3*Signal([20*20e3:30*20e3],1), Signal([20*20e3:30*20e3],4));
    ylim([-5;5])

%%
    figure
    for i = 1:64
        subplot(8,8, i)
        plot(1e-4*time_ms, LP_Signal_fix(:,i));
        title(i)
        ylim([-5;5])
%         axis off
%         set(gca,'XColor', 'none','YColor','none')
    end