function []=gpuWavelet_transformation(Fs, time_ms, num_electrode, LP_Signal_fix, Downsample_rate, t1, t2)

dFs=Fs/Downsample_rate;
DS_LP_Signal= downsample(LP_Signal_fix, Downsample_rate);
DS_time_ms= downsample(time_ms, Downsample_rate);
DS_time_ms_lim= DS_time_ms(t1:t2,:);
t = 0:1/dFs:(length(DS_time_ms_lim)*1/dFs)-1/dFs;

% Calculation range
% DC removal
% d = designfilt('bandstopiir','FilterOrder',2, ...
%                'HalfPowerFrequency1',49,'HalfPowerFrequency2',51, ...
%                'DesignMethod','butter','SampleRate',Fs);
%            
% DCR_LP_Signal = filtfilt(d,DS_LP_Signal);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
for i=1:num_electrode
    gpuDevice(1);

    DS_LP_Signal_single=DS_LP_Signal(:, i);
    
    DS_LP_Signal_lim= DS_LP_Signal_single(t1:t2,:);
    DS_LP_Signal_lim=single(DS_LP_Signal_lim);

    fb = cwtfilterbank('SignalLength',length(DS_LP_Signal_lim),'SamplingFrequency',Fs, 'FrequencyLimits',[0 100]);
    
    [cfs,f] = fb.wt(gpuArray(DS_LP_Signal_lim));
    

    
    fig1 = figure;
    fig1.PaperUnits      = 'centimeters';
    fig1.Units           = 'centimeters';
    fig1.Color           = 'w';
    fig1.InvertHardcopy  = 'off';
    fig1.Name            = ['#', num2str(i), ' Time-Frequency analysis'];
    fig1.DockControls    = 'on';
    fig1.WindowStyle    = 'docked';
    fig1.NumberTitle     = 'off';
    set(fig1,'defaultAxesXColor','k');
    figure(fig1);
    
    title('Signal and Scalogram')
    subplot(211)
    plot(DS_time_ms_lim/1000, DS_LP_Signal_lim);
    xlim([t1/1000 t2/1000]);
    ylim([-0.2 0.2]);
    xlabel('Time (s)');
    ylabel('Amplitude (mV)');
    
    subplot(212)
  
    imagesc(t,f,abs(cfs))  
    AX = gca;
    AX.YTickLabelMode = 'auto';

    caxis([0 0.03])
    axis tight
    shading flat
    axis xy

    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    set(gca,'yscale','log')
    colormap jet;
    
end