% @title      Plot response to stimulation
% @file       stim_response.m
% @author     Romain Beaubois
% @date       07 Jul 2022
% @copyright
% SPDX-FileCopyrightText: © 2022 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Plot response to stimulation
% * <TO DO> add handling for overlap stimulation and sequence handling
% 
% @details
% > **07 Jul 2022** : file creation (RB)

function stim_response(spike_detection_struct, exp_name, rec_param, sequence, stim)
    % Spike counting parameters
    % /!\ overlap with SNN based stimulation
    tpre_stim_ms    = 100; % (ms)
    tpost_stim_ms   = 100; % (ms)
    win_width_ms    = 5; %(ms)
    win_size_ms     = tpre_stim_ms + tpost_stim_ms + stim.width; % (ms)

    spk_count       = zeros(round(win_size_ms/win_width_ms), 1);
    t_win           = (1 : length(spk_count))*win_width_ms;

    s               = 2;    % sequence to check -- <HARDCODED> Sequence to load
    tstamp          = stim.tstamp - 5*60*1e3; % (ms) -- <HARDCODED> shift of time stamp according to sequence
    
    pos_label       = ["stimulated", "non-stimulated close", "non-stimulated far"];
    el_list         = [stim.electrodes; stim.electrodes_no_stim_close; stim.electrodes_no_stim_far];

    for pos = 1 : length(pos_label)
        % Create figure
        fig = figure('Name', sprintf("Response to stimulation (%s)", pos_label(pos)));
        sgtitle(exp_name + sprintf("(%s)", pos_label(pos)));
        
        nb_el   = length(el_list(pos,:));
        for h = 1 : nb_el
            el      = el_list(pos, h);

            subplot(round(sqrt(nb_el)), ceil(sqrt(nb_el)), h);

            spikes_el_ms    = spike_detection_struct(s).all_spikes{el, 1}*1e3; % Timing of spikes (ms)

            % For all time stamps
            for i = 1 : length(stim.tstamp)
                % For all elements in the time window
                for j = 1 : length(spk_count)-1
                    % For all spikes detected
                    for z = 1 : length(spikes_el_ms)
                        if spikes_el_ms(z) >= (tstamp(i) - tpre_stim_ms + j*win_width_ms) ...
                            && spikes_el_ms(z) <= (tstamp(i) - tpre_stim_ms + (j+1)*win_width_ms)
                            spk_count(j) = spk_count(j) + 1;
                        elseif spikes_el_ms(z) > (tstamp(i) - tpre_stim_ms + (j+1)*win_width_ms)
                            break;
                        end
                    end
                end
            end

            area([tpre_stim_ms tpre_stim_ms + stim.width], [max(spk_count) max(spk_count)], 'FaceColor', '#00a9ff', 'EdgeColor', '#00a9ff')
            hold on
            bar(t_win, spk_count, 'k');
            title(sprintf("%d", el));
        end
    end
end