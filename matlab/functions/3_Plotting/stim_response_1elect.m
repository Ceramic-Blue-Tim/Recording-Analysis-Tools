% @title      Stimulation response of one electrode
% @file       stim_response_1elect.m
% @author     Romain Beaubois
% @date       05 Jul 2022
% @copyright
% SPDX-FileCopyrightText: © 2022 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Stimulation response of one electrode
% * add stim offset handling
% 
% @details
% > **05 Jul 2022** : file creation (RB)

function stim_response_1elect(spike_detection_struct, exp_name, rec_param, sequence, stim)
    % Intermediate variables
    nb_el       = rec_param.nb_chan;  % Number of electrodes
    spikes      = cell(nb_el, 1);
    tstamp_sid  = stim.tstamp * (rec_param.fs/1e3);

    % Set figure
    fig = figure('Name', "Raster plot of all sequences with stim stamp");
    sgtitle(exp_name);

    for i = 1:sequence.nb
        subplot(sequence.nb, 1, i)

        % Plot one electrode analogic
        
        % Plot one electrode raster
        
        % Plot one stimulation stamp

        title(replace(sequence.label(i), '_', ' '));
    end
end