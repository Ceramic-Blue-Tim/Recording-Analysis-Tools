% @title      Plot raster plots of all sequences
% @file       raster_sequence_no_stim.m
% @author     Romain Beaubois
% @date       05 Jul 2022
% @copyright
% SPDX-FileCopyrightText: © 2022 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Plot raster plots of all sequences
% 
% @details
% > **05 Jul 2022** : file creation (RB)

function raster_sequence_no_stim(spike_detection_struct, exp_name, rec_param, sequence, varargin)
    nb_el = rec_param.nb_chan;  % Number of electrodes
    spikes = cell(nb_el, 1);
    for k= 1:nb_el
        spikes{k} = rot90(spike_detection_struct.all_spikes{k, 1});
    end
    
    fh = figure('Name', "yes");
    sgtitle(exp_name);
    for i = 1:sequence.nb
        subplot(1, sequence.nb, i)
        plotSpikeRaster(spikes, 'FigHandle', fh ,'GenFigure', true);
        title(replace(sequence.label(i), '_', ' '));
    end
end