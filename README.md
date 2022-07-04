<!-- ##### Overview ##### -->
# Overview

Matlab functions to analyze recordings mainly from MEA

<!-- ##### Features ##### -->
# Features

* Spike detection
* Burst detection
* Spike sorting
* Spike clustering
* Wavelet
* Brain wave analysis

<!-- ##### Support ##### -->
# Support

## Software
* Matlab 2014.b and older

<!-- ##### Getting started ##### -->
# Getting started

## Generate experiment information file for recordings

* Edit script ```MED64_rec_sequencer.m``` as below :
* 
``` Matlab
    % Recording file format
        f_type          = 'bin';    % File format of trace
        f_get_type      = 'one';    % File analysis mode single 'one' or multiple 'all'
    
    % Recording split list
        split_list      = ["C1Exp1", "C1Exp2", "C1Exp4", "C1Exp5", "C1Exp6"]; % Experiments to associate with information file

    % Splitting sequence
        sequence_label      = ["stim_off1", "stim_on1", "stim_off2", "stim_on2", "stim_off3"];  % Label for each sequence
        sequence_duration_s = [5*60, 5*60, 5*60, 5*60, 5*60];      % Duration of sequences [s]
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

## Documentation

(WIP) Documentation is provided in ```docs/```

## Repository structure

(WIP) A changelog is kept at ```docs/CHANGELOG.MD```.

## Issues and Contributing

> WIP

## Contributors

* Tatsuya Osaki (2020-2022)
* Romain Beaubois (2020-)