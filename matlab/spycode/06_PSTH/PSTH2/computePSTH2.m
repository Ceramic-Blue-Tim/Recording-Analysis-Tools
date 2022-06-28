function computePSTH2(peak_dir,psth_dir, bin_ms, win_ms, blank_ms, fs)
    psth_bin   = bin_ms * fs / 1000; %org in ms
    psth_win   = win_ms * fs / 1000; %org in ms
    blank      = blank_ms * fs / 1000;
    
    all_phases = dir(peak_dir);
    
    blanking   = 0:blank;
    for p = 3:length(all_phases)
        [S ls all_artifact] = CONV_nbt_data(fullfile(peak_dir,all_phases(p).name));
        S = UTIL_blank(S,all_artifact,blanking);

        if(exist('all_artifact','var') && ~isempty(all_artifact))
            [all_psth_m all_psth_s n_stim els all_response] = PROC_get_psth_sm(S, ...
                                                                            all_artifact, ...
                                                                            psth_win, ...
                                                                            psth_bin);
            save( fullfile(psth_dir,all_phases(p).name), ...
                'all_psth_m', 'all_psth_s', 'n_stim', 'els', 'all_response', 'all_artifact', 'psth_win', 'psth_bin');
        end
    end
end