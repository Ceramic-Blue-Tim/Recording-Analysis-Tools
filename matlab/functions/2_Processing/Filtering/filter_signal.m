% @title      Filter raw data
% @file       filter_signal.m
% @author     Tatsuya Osaki, Romain Beaubois
% @date       20 Jul 2022
% @copyright
% SPDX-FileCopyrightText: © 2020 Tatsuya Osaki <osaki@iis.u-tokyo.ac.jp>
% SPDX-FileCopyrightText: © 2021 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Filter signal
% 
% @details
% > **19 Jun 2020** : file creation (TO)
% > **20 Jun 2022** : split time and signal to save memory (RB)

function [LP_Signal_fix, HP_Signal_fix]=filter_signal(Fs, num_electrode, t, Signal)
    Signal_fix      = zeros(length(t), num_electrode);
    HPt_Signal_fix  = zeros(length(t), num_electrode);

    parfor i=1:num_electrode
        baseline                = mean(Signal(:,i));
        Signal_fix(:, i)        = Signal(:, i) - baseline;
        LP_Signal_fix(:, i)     = lowpass(Signal_fix(:, i), 1000, Fs);
        HPt_Signal_fix(:, i)    = lowpass(Signal_fix(:, i), 3000, Fs);
        HP_Signal_fix(:, i)     = highpass(HPt_Signal_fix(:, i), 300, Fs);
    end

    clearvars HPt_Signal_fix Signal_fix;
end