% @title      Analysis of a trace
% @file       trace_analysis.m
% @author     Tatsuya Osaki, Romain Beaubois
% @date       06 Jul 2021
% @copyright
% SPDX-FileCopyrightText: © 2020 Tatsuya Osaki <osaki@iis.u-tokyo.ac.jp>
% SPDX-FileCopyrightText: © 2021 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Analysis of a trace
%   * spike detection
%   * burst detection
% 
% @details
% > **19 Jun 2020** : file creation (TO)
% > **06 Jul 2021** : add bin recordings parameters fetching from hdr file (RB)
% > **01 Jun 2022** : add header, comments and update to last version from Tatsuya (RB)
% > **02 Jun 2022** : add plotting parameters (RB)
% > **20 Jun 2022** : split time and signal from bin reading to save memory (RB)
% > **07 Jul 2022** : add check for experiment parameters (RB)

function trace_analysis(f_type, fpath, rec_duration_secs, compute_param, plot_param, save_param)
% | **Trace analysis (MED64)**
% |
% | **f_type** : file format for trace file 'mat' or 'bin'
% | **fpath** : path to trace file
% | **rec_duration_secs** : recording duration in seconds
% | **compute_param** : computation to perform for analysis
% | **plot_param** : plotting parameters for figures
% | **save_param** : parameters for analysis saving
%
% Perform analysis of a trace : filter, spike detection, burst detection

%% Check experiment information of recording %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Experiment information of recording
    [dir, exp_name, ~] = fileparts(fpath);
    fpath_exp_params = fullfile(dir, exp_name + ".mat");
    if isfile(fpath_exp_params)
        sequence = read_exp_params(fpath_exp_params);
    end

%% Read trace file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Read binary file
    if strcmp(f_type, 'bin')
        [t, Signal, fname_no_ext, rec_param]    = read_bin(fpath, rec_duration_secs);   % Signals of electrodes + name of file + recording parameters
    elseif strcmp(f_type, 'raw')
        [t, Signal, fname_no_ext, rec_param]    = read_raw(fpath, rec_duration_secs);   % Signals of electrodes + name of file + recording parameters
    end

    % Filter signal
    [LP_Signal_fix, HP_Signal_fix]              = filter_signal(rec_param.fs, rec_param.nb_chan, t, Signal);

%% Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Get sample range for sequences
    [id_start, id_stop] = get_seq_id_range(rec_param.fs, sequence, length(t));

    for i = 1:sequence.nb
        % Spike detection
        if compute_param.spike_detection
            visual_on       = 0;
            magnification   = 5; % magnification *STDEV
        
            spike_detection_struct(i) = spike_detection(rec_param.fs, t(id_start(i):id_stop(i)), rec_param.nb_chan, HP_Signal_fix((id_start(i):id_stop(i)),:), visual_on, magnification);
        end

        % % Burst detection 
        % if compute_param.burst_detection
        %     bin_win= 100; % msec
        %     burst_th=5;
        %     visual_on=0;
            
        %     [burst_locs, burst_spikes, ...
        %     All_interburst_interval_sec, Mean_burst_frequency, ...
        %     Stdev_interburst_interval,inter_burst_interval_CV] ...
        %     = burst_detection(rec_param.fs, t, rec_param.nb_chan, LP_Signal_fix, HP_Signal_fix,All_spikes, bin_win, burst_th, visual_on);
        % end
    end

%% Saving %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Save data
    if save_param.data
        spike_detection_save_path = sprintf("%s%s%s_spike_detection.mat", save_param.path, filesep, fname_no_ext);
        % Spike detection
        if compute_param.spike_detection
            save(spike_detection_save_path, 'spike_detection_struct');
        end

        % burst_detection_save_path = sprintf("%s%s%s_burst_detection.mat", save_param.path, filesep, fname_no_ext);
        % % Burst detection
        % if compute_param.burst_detection
        %     save(burst_detection_save_path, ...
        %         'burst_locs', ...
        %         'burst_spikes', ...
        %         'All_interburst_interval_sec', ...
        %         'Mean_burst_frequency', ...
        %         'Stdev_interburst_interval', ...
        %         'inter_burst_interval_CV' ...
        %     );
        % end
    end
    
end