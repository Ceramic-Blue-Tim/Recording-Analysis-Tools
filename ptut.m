%% Clear
    clear all   % Clear all variables from workspace
    close all   % Close all windows open (figures, ...)
    clc         % Clear command window

%% Path handling
    addpath('functions');   % Add the folder containing functions to path

%% Get binary files
    [mat_file, mat_dir] = uigetfile('*.mat','Select mat file to analyze'); % Select mat file
    mat_fpath           = sprintf("%s%s",mat_dir,mat_file);     % File path
    [mat_dir, fname_no_ext, ~] = fileparts(mat_fpath);

%% Analysis from binary files
    % File reading parameters
        trace_time      = 60;                                       % seconds, recording file duration
        save_path       = uigetdir(pwd,'Select saving folder');     % Ask for saving path
        save_data       = false;                                    % Enable storage of data (.mat)
        save_fig        = false;                                    % Save figures (.fig/.jpg)

        save_param      = struct( ...
            'path', save_path, ...
            'data', save_data, ...
            'fig',  save_fig ...
        );

    %-- All computation in one function
%         % Compute reading and analysis of the bin files
%             for i = 1:nb_binf
%                 bin_trace_analysis(bin_fpath(i), trace_time, save_param);
%             end

    %-- Computation in top script
%         [Signal, LP_Signal_fix, HP_Signal_fix, rec_param] = load(mat_fpath);
        recording = load(mat_fpath);
        % recording.Signal is "raw" signal (filtered by recording device)
        % recording.LP_Signal_fix is low passed filtered signal
        % recording.HP_Signal_fix is high passed filtered signal
        % recording.rec_param is struct of recording parameters
        % recording.time_s is time vector
        
        Signal = recording.Signal;
        LP_Signal_fix = recording.LP_Signal_fix;
        HP_Signal_fix = recording.HP_Signal_fix;
        rec_param = recording.rec_param;
        time_ms = recording.time_ms;
        clear recording;

%% Analysis in main script
    % Spike detection
        visual_on=0;
        magnification=5; % magnification *STDEV
        
        [All_spikes_pos, All_spikes_neg, ...
        Mean_posspks_amp, Mean_negspks_amp, ... 
        Num_posspks, Num_negspks, ...
        All_interspike_interval_sec, Mean_interspike_interval_sec, All_spikes] ...
        = spike_detection(rec_param.fs, time_ms, rec_param.nb_chan, HP_Signal_fix, visual_on, magnification);
    
    % Burst detection 
        bin_win= 100; % msec
        burst_th=5;
        visual_on=0;
        
        [burst_locs, burst_spikes, ...
        All_interburst_interval_sec, Mean_burst_frequency, ...
        Stdev_interburst_interval,inter_burst_interval_CV] ...
        = burst_detection(rec_param.fs, time_ms, rec_param.nb_chan, LP_Signal_fix, HP_Signal_fix,All_spikes, bin_win, burst_th, visual_on);

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
  
        if save_param.fig
            title = sprintf("%s%s%s.fig",save_path, filesep, fname_no_ext);
            savefig(fig1,title);
            title = sprintf("%s%s%s.jpg",save_path, filesep, fname_no_ext);
            saveas(fig1,title);
        end
        
%% Some variables handling

Signal(:,1); % All time values
Signal(:,63); % All electrode 63 values
plot(Signal(:,1), Signal(:,63)) % Plot signal of electrode 63

nb_row = 8;
nb_col = 8;
for i = 1 : rec_param.nb_chan
    subplot(nb_row, nb_col, i);
    plot(Signal(:,1), Signal(:,i+1));
    % add titles for axis,figure,plot, ... cf plot2D in matlab help
end

 
 
 
 
 
