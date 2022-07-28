<!-- ##### Overview ##### -->
# Overview

Matlab functions to analyze recordings mainly from MEA. Currently supported system are **MED64** and **MCS**.

<!-- ##### Features ##### -->
# :mag_right: Features

:heavy_check_mark: Spike detection
:heavy_check_mark: Burst detection
:construction: Spike sorting
:construction: Spike clustering
:construction: Wavelet
:construction: Brain wave analysis

<!-- ##### Support ##### -->
# :wrench: Requirements

## Software

* Matlab 2014.b and older

## Data format

* **MED64**
  * .bin
  * .mat
* **MCS**
  * .raw
  * .mat

<!-- ##### Getting started ##### -->
# :beginner: Getting started

## :open_file_folder: Script index

* ```MED64_rec_sequencer.m``` : generate experiment information file about recording
* ```MED64_rec_analysis.m``` : perform analysis of recording
* ```MED64_rec_plotter.m``` : plot figures from analysis
* ```MED64_rec_viewer.m``` : view recording
* ```MED64_rec_splitter.m``` : split recording for smaller RAM usage when loading

## Generate experiment information file for recordings

* Edit script ```MED64_rec_sequencer.m``` as below :

``` Matlab
    % Recording file format
        f_type          = 'bin';    % File format of trace
        f_get_type      = 'one';    % File analysis mode single 'one' or multiple 'all'
    
    % Recording split list
        split_list      = ["C1Exp1", "C1Exp2", "C1Exp4", "C1Exp5", "C1Exp6"]; % Experiments to associate with information file

    % Splitting sequence
        sequence_label      = ["stim_off1", "stim_on1", "stim_off2", "stim_on2", "stim_off3"];  % Label for each sequence
        sequence_duration_s = [5*60, 5*60, 5*60, 5*60, 5*60];      % Duration of sequences [s]
        stim_electrodes     = [39, 40, 47, 48, 55, 56, 63, 64]; % Stimulated electrodes
        stim_width          = 50; % Width of stimulation [ms]
``` 

## Run analysis on MED64 recording stored as .bin file

* Edit script ```MED64_rec_analysis.m``` as below :

``` Matlab
% Recording file format
    f_type          = 'bin';    % File format of trace
    f_get_type      = 'one';    % File analysis mode single 'one' or multiple 'all'
```

* Set analysis parameters

``` Matlab
% Analysis parameters
    compute_spike_detection     = true;     % Compute spike detection
    compute_burst_detection     = true;     % Compute burst detection
    compute_spike_sorting       = false;    % Compute spike sorting
    compute_spike_clustering    = false;    % Compute spike clustering
    compute_wavelet             = false;    % Compute wavelet analysis
    compute_brainw_wave         = false;    % Compute brain wave analysis
```

* Run script
* Specify binary file(s) to analyze
* Specify output folder

## Run analysis of a folder of MED64 recording stored as .bin file

* Edit script ```MED64_rec_analysis.m``` as below :

``` Matlab
% Recording file format
    f_type          = 'bin';    % File format of trace
    f_get_type      = 'all';    % File analysis mode single 'one' or multiple 'all'

% Trace paramaters
    trace_time      = -1;   % trace duration (s), -1 for full trace 

% Analysis parameters
    compute_spike_detection     = true;     % Compute spike detection
    compute_burst_detection     = true;     % Compute burst detection
    compute_spike_sorting       = false;    % Compute spike sorting
    compute_spike_clustering    = false;    % Compute spike clustering
    compute_wavelet             = false;    % Compute wavelet related analysis
    compute_brainw_wave         = false;    % Compute brainw wave analysis

% Plotting parameters
    plot_raster                 = true;         % Plot raster
    plot_activity_all           = true;         % Plot activity of all electrodes
    plot_activity_one           = -1;           % Plot activity of one electrode (-1 : disabled)
    plot_activity_time_range    = [0 ; 1e3];    % Activity time range plotted (s) ([-1;0] : all trace)

% Saving parameters
    save_data       = true;    % Save processed data to .mat format
    save_fig        = true;    % Save figures
```

* Run script
* Specify binary file(s) to analyze
* All data will be stored in the folder ```../analysis/```

## Structure information
``` Matlab
    % Recording parameters
    rec_param = struct(... 
        'format',       % File format
        'start_t',      % Start time
        'fs',           % Sampling frequency
        'time_s',       % Recording time to read (s)
        'conv_f',       % Conversion factor
        'active_chan',  % List of active channels
        'nb_chan',      % Number of channels
    );

    % Sequence information
    sequence = struct(...
        'label',        % List of label for sequences
        'duration_s',   % List of duration for sequences (s)
        'nb',           % Number of sequences
    );

    % Stimulation information
    stim = struct(...
        'electrodes',   % List of electrodes stimulated
        'width',        % Width of stimulation (ms)
        'tstamp',       % Stimulation time stamp for all recording (ms)
    );

    % Spike detection
    spike_detection_struct = struct(... 
        'sequence_label',       % Sequence label
        'sequence_duration_s',  % Sequence duration (s)
        'all_spikes',           % All spikes locations
        'all_pos_spikes',       % All positive spikes locations
        'all_neg_spikes',       % All negative spikes locations
        'nb_pos_spikes',        % Number of positive spikes
        'nb_neg_spikes',        % Number of negative spikes
        'mean_amp_pos_spikes',  % Mean amplitude of positive spikes
        'mean_amp_neg_spikes',  % Mean amplitude of negative spikes
        'all_ISI_secs',         % All ISI (s)
        'mean_ISI',             % Mean ISI
        'raster_x',             % Raster plot x axis
        'raster_y',             % Raster plot y axis
    );

    % Burst detection
    burst_detection_struct = struct(... 
        'sequence_label',       % Sequence label
        'sequence_duration_s',  % Sequence duration (s)
        'burst_locs',           % Burst locations (s)
        'burst_spikes',         % Burst spikes
        'all_IBI_s',            % All IBI (s)
        'dev_IBI',              % Deviation IBI
        'cv_IBI',               % Coefficient of variation IBI
        'burst_mean_freq',      % Mean frequency bursts (Hz)
    );
``` 

## Documentation

(WIP) Documentation is provided in ```docs/```

## Repository structure

(WIP) A changelog is kept at ```docs/CHANGELOG.MD```.

## Issues and Contributing

> WIP

## Contributors

* Tatsuya Osaki (2020-2022)
* Romain Beaubois (2020-)