% @title      Plot raster plots of all sequences
% @file       raster_sequence_stim_elect.m
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

function raster_sequence_stim_elect(spike_detection_struct, exp_name, rec_param, sequence, stim)
    % Intermediate variables
    nb_el       = rec_param.nb_chan;  % Number of electrodes
    spikes      = cell(nb_el, 1);
    
    % Set figure
    fig = figure('Name', "Raster plot of all sequences", 'NumberTitle','off');
    sgtitle(exp_name);

    for i = 1:sequence.nb
        subplot(sequence.nb, 1, i)

        % % Raster plot function
        %     for k = 1:nb_el
        %         spikes{k} = rot90(spike_detection_struct(i).all_spikes{k, 1});
        %     end
        %     plotSpikeRaster(spikes,'PlotType', 'scatter', 'GenFigure', true); % using raster plot figure
        
        % Custom
        for j = 1:nb_el
            x = spike_detection_struct(i).all_spikes{j, 1};
            y = spike_detection_struct(i).all_spikes{j, 2};

            if find(stim.electrodes == j)
                plot(x, y, '.r', 'MarkerSize', 1)
            else
                plot(x, y, '.k', 'MarkerSize', 1)
            end

            hold on
        end

        title(replace(sequence.label(i), '_', ' '));
    end
end