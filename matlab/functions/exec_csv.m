function exec_csv(Fs, num_electrode)
[Signal_comp]=init_csv(num_electrode);

sample_number=size(Signal_comp, 1);
for j=1:sample_number
Signal=Signal_comp{j, 1};
[LP_Signal_fix, HP_Signal_fix, time_ms]=filter_signal(Fs, num_electrode, Signal);
%% Spike detection
visual_on=0;
magnification=5; % magnification *STDEV
%////////////
[All_spikes_pos, All_spikes_neg, Mean_posspks_amp, Mean_negspks_amp, Num_posspks,Num_negspks, All_interspike_interval_sec, Mean_interspike_interval_sec, All_spikes]=spike_detection(Fs, time_ms, num_electrode, HP_Signal_fix, visual_on, magnification);

%% Burst detection (need spike detection first)
%Burst determination
bin_win= 100;%msec
burst_th=5;
visual_on=0;
[burst_locs, burst_spikes, All_interburst_interval_sec, Mean_burst_frequency, Stdev_interburst_interval,  inter_burst_interval_CV]=burst_detection(Fs, time_ms, num_electrode, LP_Signal_fix, HP_Signal_fix,All_spikes, bin_win, burst_th, visual_on);
%% Neuronal avalcnhes (need spike detection first)
def_avalanch_ms=2;
[logx, Avalanches_probability, avalanch, AB, idx]=indexed_neuronal_avalanches(All_spikes, def_avalanch_ms, num_electrode, time_ms, HP_Signal_fix);
%%  Spike Raster plot
A=cell(num_electrode, 1);
for k=1:num_electrode
A{k}=rot90(All_spikes{k, 1});
end
fig1 = figure;
fig1.PaperUnits      = 'centimeters';
fig1.Units           = 'centimeters';
fig1.Color           = 'w';
fig1.InvertHardcopy  = 'off';
fig1.Name            = ['Spike Rastor plot'];
fig1.DockControls    = 'on';
fig1.WindowStyle    = 'docked';
fig1.NumberTitle     = 'off';
set(fig1,'defaultAxesXColor','k');
figure(fig1);

[x, y]=plotSpikeRaster(A, 'PlotType','vertline');
% plot(x, y);
%% Data

for k=1:num_electrode
    try % General and spike detection
        Data(k).Name='Signal' ;
        Data(k).Order= num2str(k);
        Data(k).Sampling_Rate= Fs;
        Data(k).Electrode= electode_position(k);
        Data(k).LP_signal= LP_Signal_fix(:, k);
        Data(k).HP_signal= HP_Signal_fix(:, k);
        Data(k).All_spikes=All_spikes{k};
        Data(k).Interspike_interval=All_interspike_interval_sec{k};
        Data(k).Mean_interspike_interval_sec=Mean_interspike_interval_sec(k);
    catch
    end
    try %spike sorting
        Data(k).Ex_spikes_neg=Extracted_spikes_neg{k};
        Data(k).Ex_spikes_pos=Extracted_spikes_pos{k};
    catch
    end
    try % Spikes
        Data(k).Mean_negative_spike_amplitude=Mean_negspks_amp(k);
        Data(k).Mean_positice_spike_amplitude=Mean_posspks_amp(k);
        Data(k).number_of_negative_sspikes=Num_negspks(k);
        Data(k).number_of_positive_spikes=Num_posspks(k);
        Data(k).number_of_spikes=Num_posspks(k)+Num_negspks(k);
    catch
    end
    try %Burst detection
        Data(k).Mean_burst_frequency=Mean_burst_frequency(k);
        Data(k).All_interburst_interval_sec=All_interburst_interval_sec{k};
        Data(k).Inter_event_interval_CV=CV(k);
    catch
    end
    try % avaalcnhes
        Data(k).Avalanches_probability=Avalanches_probability;
        Data(k).Avalanches_def_ms=def_avalanch_ms;
    catch
    end
    try % Raster of spikes
        Data(k).Spike_timing_raster=A{k}; %#ok<*SAGROW>
    catch
    end
end
save_str=num2str(Signal_comp{j, 2});
save_str = strtrim(save_str);
mat='.mat';
dta='cData_';
save_str =strcat(dta, save_str, mat);
save(save_str, 'Data');

end

end