% @title      Trace viewer
% @file       trace_view.m
% @author     Romain Beaubois
% @date       07 Jun 2022
% @copyright
% SPDX-FileCopyrightText: © 2022 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Trace viewer
% 
% @details
% > **07 Jun 2022** : file creation (RB)
% > **20 Jun 2022** : split time and signal from bin reading to save memory (RB)

function [t, raw_signal, lpf_signal, hpf_signal, rec_param] = trace_view(f_type, fpath, rec_duration_secs, plot_param)
% | **Trace view (MED64)**
% |
% | **f_type** : file format for trace file 'mat' or 'bin'
% | **fpath** : path to trace file
% | **rec_duration_secs** : recording duration in seconds
% | **plot_param** : plotting parameters for figures
%
% Plot the trace

%% Read trace file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Read binary file
    if strcmp(f_type, 'mat')
        tmp                 = load(fpath);
        Signal              = tmp.Signal;
        % Compatibility patch now that from bin t and singal are splitted
        t                   = Signal(:,1);
        Signal              = Signal(:, 2:end);
        fname_no_ext        = tmp.fname_no_ext;
        rec_param           = tmp.rec_param; 
        clear tmp;
    elseif strcmp(f_type, 'bin')
        [t, Signal, fname_no_ext, rec_param]    = read_bin(fpath, rec_duration_secs);   % Signals of electrodes + name of file + recording parameters
    end

    % Filter signal
    [LP_Signal_fix, HP_Signal_fix, time_ms]     = filter_signal(rec_param.fs, rec_param.nb_chan, t, Signal); clear t;

%% Plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Plot activity of all electrodes
    if plot_param.activity_all
        fig_activity_all = figure('visible', 'off');
        % fig_activity_all.PaperUnits         = 'centimeters';
        % fig_activity_all.Units              = 'centimeters';
        fig_activity_all.Color              = 'w';
        % fig_activity_all.InvertHardcopy     = 'off';
        fig_activity_all.Name               = ['Activity all channels'];
        % fig_activity_all.DockControls       = 'on';
        % fig_activity_all.WindowStyle        = 'docked';
        fig_activity_all.NumberTitle        = 'off';
        for i = 1:rec_param.nb_chan
            subplot(round(sqrt(rec_param.nb_chan)), ceil(sqrt(rec_param.nb_chan)), i)
            plot(1e-3*Signal(:,1), LP_Signal_fix(:,i));
            title(i)
            xlabel('Time (ms)');
            ylabel('Amplitude (mV)');
            if plot_param.activity_time_range(1) > -1
                xlim(plot_param.activity_time_range)
            end
            ylim([-2;2])
    %         axis off
    %         set(gca,'XColor', 'none','YColor','none')
        end
    end

    % Plot only one electrode
    if plot_param.activity_one > -1
        fig_activity_one = figure;
        fig_activity_one.Name               = ['Activity one channel'];
        fig_activity_one.NumberTitle        = 'off';
            % plot(1e-3*Signal(:,1), LP_Signal_fix(:,plot_param.activity_one));
            plot(1e-3*Signal(:,1), Signal(:,plot_param.activity_one));
            title(plot_param.activity_one)
            xlabel('Time (ms)');
            ylabel('Amplitude (mV)');
            if plot_param.activity_time_range(1) > -1
                xlim(plot_param.activity_time_range)
            end
    end
    
    t           = 1e-3*Signal(:,1);
    raw_signal  = Signal(:, 2:end);
    lpf_signal  = LP_Signal_fix;
    hpf_signal  = HP_Signal_fix;
end