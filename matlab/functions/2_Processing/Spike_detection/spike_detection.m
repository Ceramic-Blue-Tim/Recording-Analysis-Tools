% @title      Spike detection
% @file       spike_detection.m
% @author     Tatsuya Osaki, Romain Beaubois
% @date       30 Jun 2022
% @copyright
% SPDX-FileCopyrightText: © 2020 Tatsuya Osaki <osaki@iis.u-tokyo.ac.jp>
% SPDX-FileCopyrightText: © 2022 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Spike detection
% 
% @details
% > **19 Jun 2020** : file creation (TO)
% > **30 Jun 2022** : reorganise spike detection data as a structure (RB)

function [spike_detection_struct] = spike_detection(Fs, time_ms, num_electrode, HP_Signal_fix, v, mag)
    if v==1
        fig1 = figure;
        fig1.PaperUnits      = 'centimeters';
        fig1.Units           = 'centimeters';
        fig1.Color           = 'w';
        fig1.InvertHardcopy  = 'off';
        fig1.Name            = 'Spike detection overview';
        fig1.NumberTitle     = 'off';
        set(fig1,'defaultAxesXColor','k');
        figure(fig1);
    end

    Pos_all_spikes                 = {};
    Neg_all_spikes                 = {};
    All_spikes                     = {};
    pos_avg_amp                    = zeros(num_electrode, 1);
    neg_avg_amp                    = zeros(num_electrode, 1);
    interspike_interval_sec_avg    = zeros(num_electrode, 1);
    num_posspks                    = zeros(num_electrode, 1);
    num_negspks                    = zeros(num_electrode, 1);

    tic
    for i=1:num_electrode
        STDEV   = std(HP_Signal_fix(:,i));
        peak_th = mag*STDEV;
        [posspks, poslocs] = findpeaks(HP_Signal_fix(:,i), Fs,'MinPeakHeight',peak_th );
        [negspks, neglocs] = findpeaks(-HP_Signal_fix(:,i), Fs,'MinPeakHeight',peak_th );
        
        all_locs            = vertcat(poslocs,neglocs);
        all_spks            = vertcat(posspks,-negspks);
        temp_all_locs_spks  = horzcat(all_locs, all_spks);
        all_locs_spks       = sortrows(temp_all_locs_spks, 1);
        interspike_interval = diff(all_locs_spks(:,1));
        
        Pos_all_spikes{i,1} = poslocs;
        Neg_all_spikes{i,1} = neglocs;
        Pos_all_spikes{i,2} = posspks;
        Neg_all_spikes{i,2} = negspks;
        
        temp_locs           = sort(vertcat(poslocs, neglocs));
        num_locs            = length(temp_locs);
        dummy_mat           = ones(num_locs,1);
        All_spikes{i,1}     = temp_locs;
        All_spikes{i,2}     = dummy_mat*i;
        
        All_interspike_interval_sec{i,1} = interspike_interval;
        interspike_interval_sec_avg(i,1) = mean(interspike_interval);
        
        pos_avg_amp(i, 1) = mean(posspks);
        neg_avg_amp(i, 1) = mean(-negspks);
        num_posspks(i, 1) = length(posspks);
        num_negspks(i, 1) = length(negspks);
        
        % Plot spike detection
        if v==1
            subplot(num_electrode, 1, i)
            hold on
            plot(time_ms/1000, HP_Signal_fix(:, i), 'Color', 'black');
            neglocs=Neg_all_spikes{i,1};
            negspks=Neg_all_spikes{i,2};
            poslocs=Pos_all_spikes{i,1};
            posspks=Pos_all_spikes{i,2};
            plot(neglocs, -negspks, 'o');
            plot(poslocs, posspks, 'o');
            yline(peak_th,'r');
            yline(-peak_th,'r');
            xlim([0 30]);
            hold off
        end


    end

    A = cell(num_electrode, 1);
    for k= 1:num_electrode
        A{k}=rot90(All_spikes{k, 1});
    end
    [raster_x, raster_y] = plotSpikeRaster(A);

    spike_detection_struct = struct(... 
        'all_spikes',           {All_spikes},...
        'all_pos_spikes',       {Pos_all_spikes},...
        'all_neg_spikes',       {Neg_all_spikes},...
        'nb_pos_spikes',        {num_posspks},...
        'nb_neg_spikes',        {num_negspks},...
        'mean_amp_pos_spikes',  {pos_avg_amp},...
        'mean_amp_neg_spikes',  {neg_avg_amp},...
        'all_ISI_secs',         {All_interspike_interval_sec}, ...
        'mean_ISI,',            {interspike_interval_sec_avg}, ...
        'raster_x',             {raster_x}, ...
        'raster_y',             {raster_y}...
    );

    fprintf("[Computation time] Spike detection : %s seconds\n", toc);
end