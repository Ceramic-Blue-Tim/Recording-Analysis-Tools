% @title      Analysis of recordings from binary files (MED64)
% @file       binrec_analysis.m
% @author     Tatsuya Osaki, Romain Beaubois
% @date       06 Jul 2021
% @copyright
% SPDX-FileCopyrightText: © 2020 Tatsuya Osaki <osaki@iis.u-tokyo.ac.jp>
% SPDX-FileCopyrightText: © 2021 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Analysis of recordings from binary files (MED64)
% 
% @details
% > **19 Jun 2020** : file creation (TO)
% > **06 Jul 2021** : add bin recordings parameters fetching from hdr file (RB)


%% Clear
clear all
close all
clc

%% Path handling
addpath('functions')

%% Get binary files
binf_get_type = 'all';
[bin_fpath, nb_binf] = get_bin_files(binf_get_type);

%% Trace parameters
tic

trace_time      = 60;    % seconds
save_path       = uigetdir(pwd,'Select saving folder');
save_data       = false;
save_fig        = false;

save_param      = struct( ...
    'path', save_path, ...
    'data', save_data, ...
    'fig',  save_fig ...
);

analysis        = struct( ...
    'All_Interburst_interval',      zeros(64, nb_binf), ...
    'All_Interspike_interval',      zeros(64, nb_binf), ...    
    'Interburst_interval_CV',       zeros(64, nb_binf), ...
    'Mean_burst_frequency',         zeros(64, nb_binf), ...
    'Mean_interspike_interval',     zeros(64, nb_binf), ...
    'Mean_negsps_amp',              zeros(64, nb_binf), ...
    'Mean_posspks_amp',             zeros(64, nb_binf), ...
    'Stdev_interburst_interval',    zeros(64, nb_binf) ...
);

analysis.All_Interburst_interval = cell(64,5);
analysis.All_Interspike_interval = cell(64,5);

%%
for i = 1:nb_binf

    % Read signal for binary file
        [Signal, fname_no_ext, rec_param]           = read_bin(bin_fpath(i), trace_time);   % Signals of electrodes + name of file + recording parameters
        [LP_Signal_fix, HP_Signal_fix, time_ms]     = filter_signal(rec_param.fs, rec_param.nb_chan, Signal);
        clear Signal

    % Spike detection
        visual_on=0;
        magnification=5; % magnification *STDEV
        
        [All_spikes_pos, All_spikes_neg, ...
        Mean_posspks_amp, Mean_negspks_amp, ... 
        Num_posspks, Num_negspks, ...
        All_interspike_interval_sec, Mean_interspike_interval_sec, All_spikes] ...
        = spike_detection(rec_param.fs, time_ms, rec_param.nb_chan, HP_Signal_fix, visual_on, magnification);
    
    % Burst detection 
        bin_win= 100;%msec
        burst_th=5;
        visual_on=0;
        
        [burst_locs, burst_spikes, ...
        All_interburst_interval_sec, Mean_burst_frequency, ...
        Stdev_interburst_interval,inter_burst_interval_CV] ...
        = burst_detection(rec_param.fs, time_ms, rec_param.nb_chan, LP_Signal_fix, HP_Signal_fix,All_spikes, bin_win, burst_th, visual_on);

    % Spike Raster plot    
    A=cell(nb_chan, 1);
        for k=1:rec_param.nb_chan
            A{k}=rot90(All_spikes{k, 1});
        end
        fig1 = figure;
        fig1.PaperUnits      = 'centimeters';
        fig1.Units           = 'centimeters';
        fig1.Color           = 'w';
        fig1.InvertHardcopy  = 'off';
        fig1.Name            = ['Spike Rastor plot'];
        fig1.DockControls    = 'on';
        fig1.WindowStyle    = 'docked';
        fig1.NumberTitle     = 'off';
        set(fig1,'defaultAxesXColor','k');

        [x, y]=plotSpikeRaster(A);
        plot(x, y, '.');
        
        title = sprintf("%s%s%s.fig",save_path, filesep, fname_no_ext);
        savefig(fig1,title);
        title = sprintf("%s%s%s.jpg",save_path, filesep, fname_no_ext);
        saveas(fig1,title);
        close all
    
    analysis.All_Interburst_interval(:,i)        = All_interburst_interval_sec;
    analysis.All_Interspike_interval(:,i)        = All_interspike_interval_sec;
    analysis.Interburst_interval_CV(:,i)         = inter_burst_interval_CV;
    analysis.Mean_burst_frequency(:,i)           = Mean_burst_frequency;
    analysis.Mean_interspike_interval(:,i)       = Mean_interspike_interval_sec;
    analysis.Mean_negsps_amp(:,i)                = Mean_negspks_amp;
    analysis.Mean_posspks_amp(:,i)               = Mean_posspks_amp;
    analysis.Stdev_interburst_interval(:,i)      = Stdev_interburst_interval;
    
end

toc