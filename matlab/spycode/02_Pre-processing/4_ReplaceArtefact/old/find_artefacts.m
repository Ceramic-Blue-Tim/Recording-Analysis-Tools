function [stim_artifacts_idx, channel] = find_artefacts(anafile,mph)
stim_artifacts_idx = [];
if(exist(anafile,'file'))
    load(anafile); % this loads the variable data to the workspace
    max_dif = 0;
    channel = [];
    for ii = 1:size(data,1)
%         data(ii,:) = data(ii,:)-mean(data(ii,:));
        curMaxDif = abs(max(data(ii,:))-min(data(ii,:)));
        if curMaxDif>max_dif
            max_dif = curMaxDif;
            channel = ii;
        end
    end
    chosAnaCh = data(channel,:);
    clear data
    temp = [0 diff(chosAnaCh >= mph)];
    pksIdx = find(temp == 1);
%     pksIdx(find(diff(pksIdx)<=mpd_samples)+1)=[];
    stim_artifacts_idx = pksIdx;
else
    sprintf('\nFile not found!\n')
end
% fprintf('\n[%s] -> %d artifacts.\n',anafile,length(stim_artifacts_idx));