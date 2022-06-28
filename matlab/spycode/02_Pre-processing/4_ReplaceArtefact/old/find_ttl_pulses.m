function stim_artifacts_idx = find_ttl_pulses(anafile,channel)
    TTL_THRESHOLD      = 3000; %mV
    stim_artifacts_idx = [];
    if(exist(anafile,'file'))
        load(anafile); % this loads the variable data to the workspace
        if nargin < 2
            %[max_var channel] = max(std(data,[],2));
            [max_dif channel] = max(max(abs(data'))-min(abs(data')));
            clear max_dif;
        end
        stim_artifacts     = data(channel,:) > TTL_THRESHOLD;
        stim_artifacts_idx = find(diff(stim_artifacts)>0.5);
    end
    fprintf('[%s] -> %d artifacts.\n',anafile,length(stim_artifacts_idx) );
end