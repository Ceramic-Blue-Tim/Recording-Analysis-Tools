% @title      
% @file       
% @author     Romain Beaubois
% @date       27 Jun 2022
% @copyright
% SPDX-FileCopyrightText: © 2022 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief 
% 
% @details
% > **27 Jun 2022** : file creation (RB)

%% Clear %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
clc

%% Path handling %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath(genpath('../../functions'))

%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% <EDIT> >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  
    % Recording file format
        f_type          = 'bin';    % File format of trace
        f_get_type      = 'one';    % File analysis mode single 'one' or multiple 'all'

    % Trace paramaters
        trace_time      = -1;   % trace duration (s), -1 for full trace
    
    % Trace paramaters
        save_folder     = 'C1Exp1';   % name of folder containing recordings
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

% Ask files to analyze to user
prev_path       = pwd();
[fpath, nb_f]   = get_files(f_get_type, f_type);

% Ask save path to user if only one file
if strcmp(f_get_type, 'one') 
    save_path       = uigetdir(pwd,'Select saving folder');
    cd(prev_path);
else
    save_path = "";
end

% Build save parameters structure
save_param      = struct( ...
    'path',     save_path, ...
    'folder',   save_folder ...
);

%% Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute analysis for all files
for i = 1:nb_f
    % % Generate save path
    % if strcmp(f_get_type, 'all') 
    %     save_param.path = fileparts(fileparts(fpath(i))) + filesep + "analysis";
    %     mkdir(save_param.path);
    % end

    % Analyze trace
    binshort2mat(fpath(i), trace_time, save_param)
end