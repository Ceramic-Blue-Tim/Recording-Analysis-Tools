base_dir = 'K:\valentina\experiments\tetanicIMT';
exps = {...
%     '607_tetanoInPhase_IMT\607_before30minStop',...
%     '607_tetanoInPhase_IMT\607_after30minStop',...
%     '622_tetanoInPhase_IMT\622_before30minstop',...
%     '622_tetanoInPhase_IMT\622_after30minstop',...
    '647_tetanoInPhase_IMT\647_FilteredData\647_before30minStop',...
%     '647_tetanoInPhase_IMT\647_FilteredData\647_after30minStop'...
%     '649_tetanoInPhase_IMT\649_FilteredData\649_before30minStop',...
%     '649_tetanoInPhase_IMT\649_FilteredData\649_after30minStop'...
%     '651_tetanoInPhase_IMT\651_FilteredData\651_before30minStop',...
%     '651_tetanoInPhase_IMT\651_FilteredData\651_after30minStop',...
%     '652_tetanoInPhase_IMT\652_FilteredData\652_before30minStop',...
%     '652_tetanoInPhase_IMT\652_FilteredData\652_after30minStop'...
    };
sf = GlobalsParams.DEFAULT_FS;

for e = 1:length(exps)
    peak_dir  = fullfile(base_dir,exps{e},sprintf('%s_PeakDetectionMAT_PLP2ms_RP1ms',exps{e}(1:3)));
    peak_dir2 = fullfile(base_dir,exps{e},sprintf('%s_PeakDetectionMAT_PLP2ms_RP1ms2',exps{e}(1:3)));
    ana_dir   = fullfile(base_dir,exps{e},sprintf('%s_Ana_files',exps{e}(1:3)));
    
    all_phases = dir(peak_dir);
    for p = 3:length(all_phases)
        mkdir(peak_dir2,all_phases(p).name);
        
        this_phase = all_phases(p).name(8:end);
        fprintf('\n%s: ',this_phase);
        peak_files = dir(fullfile(peak_dir,all_phases(p).name));
        stim_artifact = find_ttl_pulses2(fullfile(ana_dir,[this_phase, filesep, this_phase '_A.mat']),sf);
        for pf = 3:length(peak_files);
            fprintf('.');
            clear artifact peak_train;
            load(fullfile(peak_dir,all_phases(p).name,peak_files(pf).name));
            artifact = stim_artifact(:);
            save(fullfile(peak_dir2,all_phases(p).name,peak_files(pf).name),'artifact','peak_train')
        end
    end
end