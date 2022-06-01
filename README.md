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

## Documentation

(WIP) Documentation is provided in ```docs/```

## Repository structure

(WIP) A changelog is kept at ```docs/CHANGELOG.MD```.

## Issues and Contributing

> WIP

## Contributors

* Tatsuya Osaki (2020-2022)
* Romain Beaubois (2020-)