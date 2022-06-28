function stim_artifacts_idx = find_ttl_pulses3(anafile,samplFreq,varargin)
% stim_artifacts = [];
stim_artifacts_idx = [];
% stdMultFact = 6;
% winLength_s = 0.2;   % s
% winLength_samples = winLength_s*samplFreq;
mpd_s = 0.020;
mpd_samples = mpd_s*samplFreq;
if(exist(anafile,'file'))
    load(anafile); % this loads the variable data to the workspace
    anaCh = data-repmat(mean(data,2),1,size(data,2));
%     diffAnaCh = [diff(data-repmat(mean(data,2),1,size(data,2)),1,2)];
    if nargin<3
        % it chooses the channel with the maximum range
        [max_dif channel] = max(max(abs(anaCh'))-min(abs(anaCh')));
        clear max_dif;
    else
        channel = varargin(1);
    end
    chosAnaCh = anaCh(channel,:);
%     mph = stdMultFact*std(chosAnaCh(end-winLength_samples:end));
    mph = 50;
    try
%         [pks,pksIdx] = findpeaks(chosAnaCh,'minpeakheight',mph,'minpeakdistance',mpd_samples);
        temp = [0 diff(chosAnaCh >= mph)];
        pksIdxUp = find(temp == 1);
        pksIdxDwn = find(temp == -1);
        numPeaks = length(pksIdxUp);
        pksIdx = zeros(numPeaks,1);
        for ii = 1:numPeaks
            [maxValue, maxIdx] = max(chosAnaCh(pksIdxUp(ii):pksIdxDwn(ii)));
            pksIdx(ii) = pksIdxUp(ii)+maxIdx-1;
        end
        pksIdx(find(diff(pksIdx)<=mpd_samples)+1)=[];
        stim_artifacts_idx = pksIdx;
%         stim_artifacts = chosAnaCh(pksIdx);
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