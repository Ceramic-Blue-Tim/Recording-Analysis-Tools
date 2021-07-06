%--------------------------------------------------------
% Create raster plot from binary file (.raw)
%   > File has to be one trace
%
%--------------------------------------------------------

%% Clear
    clear all
    close all
    clc

%% Path handling
    addpath('functions')

%% Parameters ---------------------------------------------------------------------------------------
    trace_time      = 60;       % Recording time in seconds
    save_fig        = true;     % Save figures in user selected folder [true false]
    f_get_type      = 'all';    % Read one or all files from a folder [one all]
% ---------------------------------------------------------------------------------------------------

%% Analysis from binary files
    f_type          = 'raw';
   [fpath, nb_f]    = get_files(f_get_type, f_type);
    save_path       = uigetdir(pwd,'Select saving folder');
    save_data       = false;
   
    save_param      = struct( ...
        'path', save_path, ...
        'data', save_data, ...
        'fig',  save_fig ...
    ); 

    vmem_plot_en = false;
    
    for i = 1:nb_f
        % Read binary file
            if strcmp(f_type, 'mat')
                tmp                 = load(fpath);
                Signal              = tmp.Signal;
                fname_no_ext        = tmp.fname_no_ext;
                rec_param           = tmp.rec_param; 
                clear tmp;
            elseif strcmp(f_type, 'bin')
                [Signal, fname_no_ext, rec_param]           = read_bin(fpath(i), trace_time);   % Signals of electrodes + name of file + recording parameters
            elseif strcmp(f_type, 'raw')
                [Signal, fname_no_ext, rec_param]           = read_raw(fpath(i), trace_time);   % Signals of electrodes + name of file + recording parameters
            end

        % Filter signal
            [LP_Signal_fix, HP_Signal_fix, time_ms]     = filter_signal(rec_param.fs, rec_param.nb_chan, Signal);
    
%% Analysis

        % Spike detection
            visual_on=0;
            magnification=5; % magnification *STDEV
            
            [All_spikes_pos, All_spikes_neg, ...
            Mean_posspks_amp, Mean_negspks_amp, ... 
            Num_posspks, Num_negspks, ...
            All_interspike_interval_sec, Mean_interspike_interval_sec, All_spikes] ...
            = spike_detection(rec_param.fs, time_ms, rec_param.nb_chan, HP_Signal_fix, visual_on, magnification);
        
        % Burst detection 
    %         bin_win= 100; % msec
    %         burst_th=5;
    %         visual_on=0;
    %         
    %         [burst_locs, burst_spikes, ...
    %         All_interburst_interval_sec, Mean_burst_frequency, ...
    %         Stdev_interburst_interval,inter_burst_interval_CV] ...
    %         = burst_detection(rec_param.fs, time_ms, rec_param.nb_chan, LP_Signal_fix, HP_Signal_fix,All_spikes, bin_win, burst_th, visual_on);
%%
        % Raster plot (events against time)
            A=cell(rec_param.nb_chan, 1);
            for k=1:rec_param.nb_chan
                A{k}=rot90(All_spikes{k, 1});
            end
            fig1 = figure;
            fig1.PaperUnits     = 'centimeters';
            fig1.Units          = 'centimeters';
            fig1.Color          = 'w';
            fig1.InvertHardcopy = 'off';
            fig1.Name           = ['Spike Rastor plot'];
            fig1.DockControls   = 'on';
            fig1.WindowStyle    = 'docked';
            fig1.NumberTitle    = 'off';
            set(fig1,'defaultAxesXColor','k');

            [x, y]=plotSpikeRaster(A);
            plot(x, y, '.');
            xlabel('Time (s)')
            ylabel('Electrodes')
            title(sprintf("Raster plot %s", fname_no_ext),'Interpreter', 'none')
            xlim([0 Signal(end,1)*1e-3])
  
            %% Save    
            if save_param.fig
                fig_path = sprintf("%s%s%s.fig", save_param.path, filesep, fname_no_ext);
                savefig(fig1,fig_path);
                jpg_path = sprintf("%s%s%s.jpg", save_param.path, filesep, fname_no_ext);
                saveas(fig1,jpg_path);
                close(fig1)
            end

        %% Plots
        if vmem_plot_en
            fig_title = sprintf("Electrodes recording : %s", fname_no_ext);
            figure('Name', fig_title, 'NumberTitle','off');
            sgtitle(fig_title)
            for i = 1 : rec_param.nb_chan
                subplot(8, (round(rec_param.nb_chan/8)+1), i)
                plot(Signal(:,1)*1e-3, HP_Signal_fix(:,i));
                title(sscanf(rec_param.active_chan(i), "El_%d"))
                xlabel('Time (s)')
                ylabel('Amp (µV)')
                ylim([-50 50])
                xlim([0 Signal(end,1)*1e-3])
            end
        end
        
        close all;
    end