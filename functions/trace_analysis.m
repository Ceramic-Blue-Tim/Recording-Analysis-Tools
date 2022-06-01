% @title      Analysis of a trace
% @file       trace_analysis.m
% @author     Tastuya Osaki, Romain Beaubois
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

function trace_analysis(f_type, fpath, rec_duration_secs, compute_param, save_param)
% | **Trace analysis (MED64)**
% |
% | **f_type** : file format for trace file 'mat' or 'bin'
% | **fpath** : path to trace file
% | **rec_duration_secs** : recording duration in seconds
% | **compute_param** : computation to perform for analysis
% | **save_param** : parameters for analysis saving
%
% Perform analysis of a trace : filter, spike detection, burst detection

%% Read trace file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Read binary file
    if strcmp(f_type, 'mat')
        tmp                 = load(fpath);
        Signal              = tmp.Signal;
        fname_no_ext        = tmp.fname_no_ext;
        rec_param           = tmp.rec_param; 
        clear tmp;
    elseif strcmp(f_type, 'bin')
        [Signal, fname_no_ext, rec_param]           = read_bin(fpath, rec_duration_secs);   % Signals of electrodes + name of file + recording parameters
    end

    % Filter signal
    [LP_Signal_fix, HP_Signal_fix, time_ms]     = filter_signal(rec_param.fs, rec_param.nb_chan, Signal);

%% Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Spike detection
    if compute_param.spike_detection
        visual_on       = 0;
        magnification   = 5; % magnification *STDEV
    
        [All_spikes_pos, All_spikes_neg, ...
        Mean_posspks_amp, Mean_negspks_amp, ... 
        Num_posspks, Num_negspks, ...
        All_interspike_interval_sec, Mean_interspike_interval_sec, All_spikes] ...
        = spike_detection(rec_param.fs, time_ms, rec_param.nb_chan, HP_Signal_fix, visual_on, magnification);
    end

    % Burst detection 
    if compute_param.burst_detection
        bin_win= 100; % msec
        burst_th=5;
        visual_on=0;
        
        [burst_locs, burst_spikes, ...
        All_interburst_interval_sec, Mean_burst_frequency, ...
        Stdev_interburst_interval,inter_burst_interval_CV] ...
        = burst_detection(rec_param.fs, time_ms, rec_param.nb_chan, LP_Signal_fix, HP_Signal_fix,All_spikes, bin_win, burst_th, visual_on);
    end

    % Analyze num for spike sorting
    if compute_param.spike_sorting        
        analyze_num = 500;
        [Pos_extracted_spikes, Neg_extracted_spikes]=spike_sorting(Fs, time_ms, num_electrode, All_spikes_pos, All_spikes_neg, HP_Signal_fix, analyze_num);
    end

    % Spike clustering
    if compute_param.spike_clustering
        cluster_num = 4;
        spike_clustering(Pos_extracted_spikes, cluster_num, num_electrode);

        % Plot spike clustering figure
        fig12 = figure;
        fig12.PaperUnits      = 'centimeters';
        fig12.Units           = 'centimeters';
        fig12.Color           = 'w';
        fig12.InvertHardcopy  = 'off';
        fig12.Name            = ''
        fig12.NumberTitle     = 'off'
        set(fig12,'defaultAxesXColor','k');
        [C1,lag1] = xcorr(LP_Signal_fix(:,1),LP_Signal_fix(:,2),'coeff');
        plot(lag1/Fs*1000,C1,'Color', 'black');
        grid on
        
        C_delay = finddelay(LP_Signal_fix(:,1),LP_Signal_fix(:,2))/Fs;
        txt = ['Conductive delay ' num2str(C_delay ) ' Sec'];
        annotation('textbox',[.9 .5 .2 .4],'String',txt, 'EdgeColor','none')
    end

    % Wavelet
    if compute_param.wavelet
        % Wavelet transformation
            LP_target=LP_Signal_fix(:,1);
            % <EDIT> >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  
            t1 = 300001;
            t2 = 900000;
            Downsample_rate=20;
            % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            tic
            wavelet_transformation(Fs, time_ms, 1, LP_target, Downsample_rate, t1, t2);
            toc
        
        % Wavelet coherence Signal vs Signal
            % <EDIT> >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  
            t1  = 1;
            t2  = 60000;
            e1  = 1;
            e2  = 6;
            Downsample_rate         = 20;
            PhaseDisplayThreshold   = 1;
            % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            tic
            wavelet_coherence(Fs, time_ms,LP_Signal_fix, Downsample_rate, t1, t2, e1, e2, PhaseDisplayThreshold)
            toc
    end

    % Brain wave analysis (frequency separation)
    if compute_param.brain_wave
        % Calculation range
        % <EDIT> >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  
        t1 = 1000000;
        t2 = 2000000;
        Downsample_rate = 1; % Down sampling can be used in 1-20 range (20000 Hz-1000 Hz)
        % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        tic
        frequency_separation(Fs, time_ms,num_electrode, LP_Signal_fix,Downsample_rate, t1, t2);
        toc
    end


%% Plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Raster plot (events against time)
    A=cell(rec_param.nb_chan, 1);
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

%% Saving %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Save figures
    if save_param.fig
        fig_path = sprintf("%s%s%s.fig", save_param.path, filesep, fname_no_ext);
        savefig(fig1,fig_path);
        jpg_path = sprintf("%s%s%s.jpg", save_param.path, filesep, fname_no_ext);
        saveas(fig1,jpg_path);
        close(fig1)
    end

    % Save data
    if save_param.data
        spike_detection_save_path = sprintf("%s%s%s_spike_detection.mat", save_param.path, filesep, fname_no_ext);
        % Spike detection
        if compute_param.spike_detection
            save(spike_detection_save_path, ...
                All_spikes_pos, ...
                All_spikes_neg, ...
                Mean_posspks_amp, ...
                Mean_negspks_amp, ...
                Num_posspks, ...
                Num_negspks, ...
                All_interspike_interval_sec, ...
                Mean_interspike_interval_sec, ...
                All_spikes ...
            );
        end

        burst_detection_save_path = sprintf("%s%s%s_burst_detection.mat", save_param.path, filesep, fname_no_ext);
        % Burst detection
        if compute_param.burst_detection
            save(burst_detection_save_path, ...
                burst_locs, ...
                burst_spikes, ...
                All_interburst_interval_sec, ...
                Mean_burst_frequency, ...
                Stdev_interburst_interval, ...
                inter_burst_interval_CV ...
            );
        end
    end
    
end