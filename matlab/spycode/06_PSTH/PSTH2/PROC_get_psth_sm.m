function [all_psth_m all_psth_s n_stim els all_response] = PROC_get_psth_sm(S, ...
                                                                         stim_time_samples, ...
                                                                         window_samples, ...
                                                                         bin_samples)
% This method returns the PSTH of all channels and the array-wide response.
% A column vector with time stamps (in samples) of the stimuli must be
% passed along with the spike-time/electrode couples.
% The function returns only the response on channels with at least one 
% spike (i.e. channel numbers present in the matrix S).
% The PSTH is binned, the bin size must be passed in samples, as well as
% the window size. If the window size is not an integer multiple of the bin
% size, the window is extended.
%
% The function returns a matrix of size T x (n_channels + 1). The rows
% correspond to time points after stimulation, and the columns to the
% active channels (indexed by the output value 'els'). The last column in
% the array-wide response: sum(all_psth_m(:,1:end-1),2).
% all_psth_s contains the sample standard deviation measuring the
% variability in spikes per bin between different stimuli.
%
% PL Baljon, December 2007
%
% v1.1 29/01/08 Added all response, the entire (unbinned) response to all
%               stimuli.
    ELEC_COLUMN = 1;
    TIME_COLUMN = 2;
    
    n_stim = length(stim_time_samples);
    % make the length of the peak train long enough so that the indexing
    % does not exceed the upper bound.
    tmax   = max(S(:,TIME_COLUMN)); tmax = tmax + 2*bin_samples-rem(tmax,bin_samples);
    
    % increase the window size if it not an natural mulitple of the binsize
    if(rem(window_samples,bin_samples) ~= 0)
        window_samples = window_samples + bin_samples - rem(window_samples,bin_samples);
    end
    
    stim_time_samples = stim_time_samples( find(stim_time_samples < (tmax - window_samples - 1) ) );
    els = unique(S(:,ELEC_COLUMN));
    all_psth_m   = zeros(window_samples/bin_samples,length(els)+1);
    all_psth_s   = zeros(window_samples/bin_samples,length(els)+1);
    all_response = cell(length(els),1);
    
    indexs = ones(window_samples,1)*stim_time_samples' + (1:window_samples)'*ones(1,size(stim_time_samples,1));
    for e = 1:length(els)
        peak_train   = sparse(S(find(S(:,ELEC_COLUMN)==els(e)),TIME_COLUMN),1,1,tmax,1,size(S,1));
        % all_response: column 1: stimulus number, column 2: time.
        [all_response{e}(:,2) all_response{e}(:,1)] = find( peak_train( indexs ) );

        psth_samples = reshape(full(peak_train( indexs )),bin_samples,[],size(stim_time_samples,1));
        psth_binned  = squeeze(sum(psth_samples,1));

        all_psth_m(:,e) = sum(psth_binned,2); % sum or mean?
        all_psth_s(:,e) = std(psth_binned,0,2)./sqrt(n_stim);
    end
    
    all_psth_m(:,end) = sum(all_psth_m(:,1:end-1),2);
    all_psth_s(:,end) = sum(all_psth_s(:,1:end-1),2);
end