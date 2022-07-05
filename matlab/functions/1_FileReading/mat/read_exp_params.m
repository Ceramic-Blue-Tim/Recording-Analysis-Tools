% @title      Read experiments parameters
% @file       read_exp_params.m
% @author     Romain Beaubois
% @date       01 Jul 2022
% @copyright
% SPDX-FileCopyrightText: © 2022 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Read experiment parameters
% 
% @details
% > **01 Jul 2022** : file creation (RB)

function [exp_sequences, exp_stim] = read_exp_params(fpath)
    exp_params      = load(fpath);
    exp_sequences   = exp_params.sequence;
    exp_stim        = exp_params.stim;
end