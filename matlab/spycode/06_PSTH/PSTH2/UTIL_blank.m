function S = UTIL_blank(S, artifact, blanking)
% Function to blank spikes detected in a period after stimulation. The 
% stimuli are provided by the variable artifact containing timestamps in
% the same (integer) scale as S(:,2). Blanking should contain a vector with
% relative samples to be blanked. For the first 2ms at 10kHz blanking
% should be 0:20, whereas at 25kHz it should be 0:50 etc.
%
% PL Baljon, April 2008
% v1.0
%
    blanking = blanking(:);
    artifact = artifact(:);
    if(length(blanking) == 1)
        fprintf('WARNING: note that blanking must be set as vector of samples to be blanked.\n');
    end
    
    idx = artifact * ones(1,size(blanking,1)) + ones(size(artifact,1),1) * blanking';
    [c,i] = setdiff( S(:,2), idx(:) );
    S = S(i,:);
end