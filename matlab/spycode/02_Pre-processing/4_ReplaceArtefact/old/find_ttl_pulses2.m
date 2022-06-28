function stim_artifacts_idx = find_ttl_pulses2(anafile,samplFreq,varargin)
% stim_artifacts = [];
stim_artifacts_idx = [];
stdMultFact = 8;
winLength_s = 0.2;   % s
winLength_samples = winLength_s*samplFreq;
mpd_s = 0.020;
mpd_samples = mpd_s*samplFreq;
if(exist(anafile,'file'))
    load(anafile); % this loads the variable data to the workspace
    diffAnaCh = [zeros(3,1) diff(data-repmat(mean(data,2),1,size(data,2)),1,2)];
%     diffAnaCh = [diff(data-repmat(mean(data,2),1,size(data,2)),1,2)];
    if nargin<3
        % it chooses the channel with the maximum range
        [max_dif channel] = max(max(abs(diffAnaCh'))-min(abs(diffAnaCh')));
        clear max_dif;
    else
        channel = varargin(1);
    end
    invChosAnaCh = -diffAnaCh(channel,:);
    mph = stdMultFact*std(invChosAnaCh(end-winLength_samples:end));
    try
%         [stim_artifacts,stim_artifacts_idx] = findpeaks(invChosAnaCh,'minpeakheight',mph,'minpeakdistance',mpd_samples);
        temp = [0 diff(invChosAnaCh >= mph)];
        pksIdxUp = find(temp == 1);
        pksIdxDwn = find(temp == -1);
        numPeaks = length(pksIdxUp);
        pksIdx = zeros(numPeaks,1);
        for ii = 1:numPeaks
            [maxValue, maxIdx] = max(invChosAnaCh(pksIdxUp(ii):pksIdxDwn(ii)));
            pksIdx(ii) = pksIdxUp(ii)+maxIdx-1;
        end
        pksIdx(find(diff(pksIdx)<=mpd_samples)+1)=[];
        stim_artifacts_idx = pksIdx;
%         stim_artifacts = invChosAnaCh(pksIdx);
    catch ME
        if ~strcmp(ME.identifier,'signal:findpeaks:largeMinPeakHeight')
            disp(ME)
            return
        end
    end
else
    sprintf('\nFile not found!\n')
end
fprintf('\n[%s] -> %d artifacts.\n',anafile,length(stim_artifacts_idx));