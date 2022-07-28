% @title      Plot raster plots of all sequences with time stamp
% @file       raster_sequence_stim_stamp.m
% @author     Romain Beaubois
% @date       05 Jul 2022
% @copyright
% SPDX-FileCopyrightText: © 2022 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Plot raster plots of all sequences
% * add stim offset handling
% * split tstamp and offset
% 
% @details
% > **05 Jul 2022** : file creation (RB)

function raster_sequence_stim_stamp(spike_detection_struct, exp_name, rec_param, sequence, stim)
    % Intermediate variables
    nb_el       = rec_param.nb_chan;  % Number of electrodes
    spikes      = cell(nb_el, 1);
    tstamp_sid  = stim.tstamp * (rec_param.fs/1e3);
    t           = 0 : 1e3/rec_param.fs : rec_param.time_s*1e3;

    % Set figure
    fig = figure('Name', "Raster plot of all sequences with stim stamp", 'NumberTitle','off');
    sgtitle(exp_name);

    for i = 1:sequence.nb
        subplot(sequence.nb, 1, i)

        % Time stamp area
        stim_color  = '#00a9ff'; % https://academo.org/demos/wavelength-to-colour-relationship/

        fig_stim_width = stim.width*1e-3*rec_param.fs;
        for z = 1:length(tstamp_sid)
            if tstamp_sid(z) + fig_stim_width < length(t)
                area([t(tstamp_sid(z)) t(tstamp_sid(z)+fig_stim_width)], [rec_param.nb_chan rec_param.nb_chan], 'FaceColor', stim_color, 'EdgeColor', stim_color)
            end
            hold on
        end

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