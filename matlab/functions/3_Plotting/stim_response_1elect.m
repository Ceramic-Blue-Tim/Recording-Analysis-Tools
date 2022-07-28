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

function stim_response_1elect(fpath, spike_detection_struct, exp_name, rec_param, sequence, stim)
    % Get data of one or several electrodes
    [t, Signal, ~, ~]       = read_bin(fpath, rec_param.time_s);   % Signals of electrodes + name of file + recording parameters
    [id_start, id_stop]     = get_seq_id_range(rec_param.fs, sequence, length(t));
    el_id                   = stim.electrodes(1);
    el_data_raw             = Signal(:, el_id); clear Signal;
    el_data                 = highpass(lowpass(el_data_raw - mean(el_data_raw), 3000, rec_param.fs), 300, rec_param.fs);

    tstamp_sid              = stim.tstamp * (rec_param.fs/1e3);
    fig_stim_width          = stim.width*1e-3*rec_param.fs;
    offset                  = 0;
    
    % % Set figure
    % fig = figure('Name', "Raster plot of all sequences with stim stamp");
    % sgtitle(exp_name);

    % subplot(2, 1, 1)
    % i = 2;
    % % Plot one electrode analog
    % plot(t(id_start(i):id_stop(i))*1e-3-5*60, el_data(id_start(i):id_stop(i)));
    % hold on

    % % Plot spike detection on analog
    % plot(spike_detection_struct(i).all_neg_spikes{el_id,1}, -spike_detection_struct(i).all_neg_spikes{el_id,2}, 'o');
    % hold on
    % plot(spike_detection_struct(i).all_pos_spikes{el_id,1}, spike_detection_struct(i).all_pos_spikes{el_id,2}, 'o');
    % hold on
    
    % % Plot stim stamp area (add baselibe + generic truncation)
    % subplot(2, 1, 2)
    % for z = 1:length(tstamp_sid)
    %     if t(tstamp_sid(z))*1e-3-5*60 < 300
    %         if tstamp_sid(z) + fig_stim_width < length(t)
    %             area([t(tstamp_sid(z))*1e-3-5*60 t(tstamp_sid(z)+fig_stim_width)*1e-3-5*60], [el_id+1 el_id+1], 'FaceColor', '#00a9ff', 'EdgeColor', '#00a9ff')
    %         end
    %     end
    %     hold on
    % end

    % % Plot raster
    % x = spike_detection_struct(i).all_spikes{el_id, 1};
    % y = spike_detection_struct(i).all_spikes{el_id, 2};

    % plot(x, y, '.k', 'MarkerSize', 1)
    % hold on

    % ylim([el_id-1 el_id+1])

    % title(replace(sequence.label(i), '_', ' '));

    % For all sequences
    for s = 1:sequence.nb
        % If stimulation sequence
        if contains(sequence.label(s), "stim_on")
            seq_name    = replace(sequence.label(s), '_', ' ');
            tstamp      = zeros(sequence.duration_s(s)*1e3, 1);

            % Set figure
            fig = figure('Name', "Raster plot of all sequences with stim stamp",'NumberTitle','off');
            sgtitle(exp_name + "-" + seq_name);

            for i = 1:length(stim.tstamp)
                if stim.tstamp(i) > (offset*1e3) && stim.tstamp(i) < (offset*1e3 + sequence.duration_s(s)*1e3)
                    tstamp(i)          = stim.tstamp(i) - offset*1e3; % (ms)
                end
            end
            padded_tstamp   = [tstamp/1e3 ; zeros(length(t)-length(tstamp),1)];
            stim_state      = 0.1*min(el_data(id_start(s):id_stop(s))) + min(el_data(id_start(s):id_stop(s))) * double((padded_tstamp>0));

            % Plot one electrode analog
            plot(t(id_start(s):id_stop(s))*1e-3-offset, el_data(id_start(s):id_stop(s)));
            hold on

            % Plot spike detection on analog
            plot(spike_detection_struct(s).all_neg_spikes{el_id,1}, -spike_detection_struct(s).all_neg_spikes{el_id,2}, 'o');
            hold on
            plot(spike_detection_struct(s).all_pos_spikes{el_id,1}, spike_detection_struct(s).all_pos_spikes{el_id,2}, 'o');
            hold on

            scatter(padded_tstamp, stim_state, 3, 'filled')
            hold on
            
            % % Plot stim stamp area (add baseline + generic truncation)
            % subplot(2, 1, 2)
            % for z = 1:length(tstamp_sid)
            %     if t(tstamp_sid(z))*1e-3-5*60 < 300
            %         if tstamp_sid(z) + fig_stim_width < length(t)
            %             area([t(tstamp_sid(z))*1e-3-5*60 t(tstamp_sid(z)+fig_stim_width)*1e-3-5*60], [el_id+1 el_id+1], 'FaceColor', '#00a9ff', 'EdgeColor', '#00a9ff')
            %         end
            %     end
            %     hold on
            % end

            % % Plot raster
            % x = spike_detection_struct(s).all_spikes{el_id, 1};
            % y = spike_detection_struct(s).all_spikes{el_id, 2};

            % plot(x, y, '.k', 'MarkerSize', 1)
            % hold on

            % ylim([el_id-1 el_id+1])
        end
        
        offset = offset + sequence.duration_s(s);
    end
end