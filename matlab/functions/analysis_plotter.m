% @title      Plot figures from analysis
% @file       analysis_plotter.m
% @author     Romain Beaubois
% @date       07 Jul 2022
% @copyright
% SPDX-FileCopyrightText: © 2022 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Plot figures from analysis
% 
% @details
% > **07 Jul 2022** : file creation (RB)

function analysis_plotter(fpath, plot_param, save_param)
% | **Plot figures generated from analysis of MED64 recordings**
% |
% | **fpath** : path to trace file
% | **plot_param** : parameters for plotting
% | **save_param** : parameters for analysis saving
%
% Perform analysis of a trace : filter, spike detection, burst detection

fprintf(">>> %s\n", datetime('now'))

%% Get data from file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Experiment information of recording from .mat file
    [dir, exp_name, ~] = fileparts(fpath);
    fprintf("[Plotting] %s\n", exp_name);
    fpath_exp_params = fullfile(dir, exp_name + ".mat");
    if isfile(fpath_exp_params)
        fprintf("[Loading] Experiment information file from : %s\n", fpath_exp_params);
        [sequence, stim] = read_exp_params(fpath_exp_params);
    else
        warning("Information file for experiment %s not found", exp_name);
    end

    % Recording parameters from .hdr file
    hdr_path    = fullfile(dir, exp_name + ".hdr");
    rec_param   = read_hdr(hdr_path);

    % Analysis
    dir_analysis            = fullfile(fileparts(dir), "analysis");
    fpath_spike_detection   = fullfile(dir_analysis, exp_name + "_spike_detection.mat");
    fpath_burst_detection   = fullfile(dir_analysis, exp_name + "_burst_detection.mat");
    
    % Load spike detection
    if isfile(fpath_spike_detection)
        fprintf("[Loading] Spike detection analysis : %s\n", exp_name);
        load(fpath_spike_detection, 'spike_detection_struct');
    else
        warning("Spike detection analysis for experiment %s not found", exp_name)
    end

    % Load burst detection
    if isfile(fpath_burst_detection)
        fprintf("[Loading] Burst detection analysis : %s\n", exp_name);
        load(fpath_burst_detection, 'burst_detection_struct');
    else
        warning("Burst detection analysis for experiment %s not found", exp_name)
    end


%% Plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Create single sequence if no information file
    % if ~isfile(fpath_exp_params)
    %     sequence = struct(...
    %         'label',        ["full"], ...
    %         'duration_s',   [length(t)], ...
    %         'nb',           1 ...
    %     );
    % end

    raster_sequence_stim_elect(spike_detection_struct, exp_name, rec_param, sequence, stim);
    % raster_sequence_stim_stamp(spike_detection_struct, exp_name, rec_param, sequence, stim);
    stim_response(spike_detection_struct, exp_name, rec_param, sequence, stim);
    stim_response_1elect(fpath, spike_detection_struct, exp_name, rec_param, sequence, stim);


%% Saving %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % % Save data 
    % if save_param.fig
    %     fprintf("[Saving] Figures : %s\n", exp_name);

    %     % Spike detection
    %     if compute_param.spike_detection
    %         spike_detection_save_path = sprintf("%s%s%s_spike_detection.mat", save_param.path, filesep, fname_no_ext);
    %         fprintf("[Saved] Spike detection of %s at %s\n", exp_name, spike_detection_save_path);
    %         save(spike_detection_save_path, 'spike_detection_struct');
    %     end

    %     % Burst detection
    %     if compute_param.burst_detection
    %         burst_detection_save_path = sprintf("%s%s%s_burst_detection.mat", save_param.path, filesep, fname_no_ext);
    %         fprintf("[Saved] Burst detection of %s at %s\n", exp_name, burst_detection_save_path);
    %         save(burst_detection_save_path, 'burst_detection_struct');
    %     end
    % end

    fprintf("====================================================================================================\n");
    
end