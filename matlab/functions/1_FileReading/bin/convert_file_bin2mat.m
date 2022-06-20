%--------------------------------------------------------
% Script to generate .mat files of file_trace_time seconds
% from binary 
%--------------------------------------------------------

%% Clear
    clear all
    close all
    clc

%% Path handling
    addpath('functions')

%% Get binary files
    binf_get_type = 'all';
    prev_path       = pwd();
    cd('/run/media/rbeaubois/JUZO/Work/PHD/mat/');
    [bin_fpath, nb_binf] = get_bin_files(binf_get_type);

%% Analysis from binary files
    file_trace_time     = 60; %seconds
    save_path           = uigetdir(pwd,'Select saving folder');
    cd(prev_path);
    save_data           = false;
    save_fig            = false;

    save_param      = struct( ...
        'path', save_path, ...
        'data', save_data, ...
        'fig',  save_fig ...
    );

    for i = 1:nb_binf
        [Signal, fname_no_ext, rec_param] = binshort2mat(bin_fpath(i), file_trace_time, save_param);
    end