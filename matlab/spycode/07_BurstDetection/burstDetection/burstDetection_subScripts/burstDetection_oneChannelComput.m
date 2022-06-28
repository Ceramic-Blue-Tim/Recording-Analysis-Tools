% burstDetection_oneChannelComput.m
% Single channel burst detection: detects bursts on single channels
function [burstTrain, burstEventTrain, outBurstSpikes] = burstDetection_oneChannelComput(peakTrain, addISImaxTh, param)
if addISImaxTh(1,4) && addISImaxTh(1,2) < param.maxISImaxTh
    % if addISImaxTh(1,4)
    if param.ISImaxTh < addISImaxTh(1,2)
        ISImaxsample = round(param.ISImaxTh/1000*param.sf);          % threshold for ISImax [sample]
        addWinsample = round(addISImaxTh(1,2)/1000*param.sf);
        amplFlag = 1;
    else
        ISImaxsample = round(addISImaxTh(1,2)/1000*param.sf);          % threshold for ISImax [sample]
        amplFlag = 0;
    end
else
    ISImaxsample = round(param.ISImaxTh/1000*param.sf);          % threshold for ISImax [sample]
    amplFlag = 0;
end
numberOfSamples = length(peakTrain);
acqTime = fix(numberOfSamples/param.sf);
% indices of nonzero elements --> corrisponde al numero del sample nel
% peak_train
timestamp = find(peakTrain);
% calculates mfr
mfr = calcMFR(peakTrain, acqTime, param.MFRmin);
% only if the mfr exceeds 0 (i.e. MFRmin)
if ~isempty(timestamp) && mfr ~= 0
    allisi2 = [0;diff(timestamp) <= ISImaxsample;0];      % ISI <= ISImax [samples]
    edges2 = diff(allisi2);                                % edges of bursts: beginning & ending
    % edgeup & edgedown contain the indexes of timestamps that correspond to
    % beginning of bursts and to end of bursts respectively
    edgeup2 = find(edges2 == 1);
    edgedown2 = find(edges2 == -1);
    if ((length(edgedown2)>=2) && (length(edgeup2)>=2))    % if there are at least 2 bursts
        numSpikesInBurst = (edgedown2-edgeup2+1);
        validBursts = numSpikesInBurst >= param.minNumSpikes;
        % if there is at least one VALID burst
        if ~isempty(validBursts)
            edgeup2 = edgeup2(validBursts);
            edgedown2 = edgedown2(validBursts);
            if amplFlag
                tsEdgeup2 = timestamp(edgeup2);
                tsEdgedown2 = timestamp(edgedown2);
                tempIBI = tsEdgeup2(2:end)-tsEdgedown2(1:end-1);
                burst2join = tempIBI<=addWinsample;
                if any(burst2join)
                    edgeup2(find(burst2join)+1)=[];
                    edgedown2(burst2join)=[];
                end
                % %%%
                allisi1 = [0;diff(timestamp)<=addWinsample;0];   % ISI <= ISImax [samples]
                edges1 = diff(allisi1);                          % edges of bursts: beginning & ending
                % edgeup & edgedown contain the indexes of timestamps that correspond to
                % beginning of bursts and to end of bursts respectively
                edgeup1 = find(edges1 == 1);
                edgedown1 = find(edges1 == -1);
                % %%%%%%
                allEdgeUp1 = [timestamp(edgeup1) ones(length(edgeup1),1) 1*ones(length(edgeup1),1)];
                allEdgeDown1 = [timestamp(edgedown1) -1*ones(length(edgedown1),1) 1*ones(length(edgeup1),1)];
                allEdge1 = [allEdgeUp1;allEdgeDown1];
                % %%%%%%
                allEdgeUp2 = [timestamp(edgeup2) ones(length(edgeup2),1) 2*ones(length(edgeup2),1)];
                allEdgeDown2 = [timestamp(edgedown2) -1*ones(length(edgedown2),1) 2*ones(length(edgeup2),1)];
                allEdge2 = [allEdgeUp2;allEdgeDown2];
                %                 edges1Sort = sortrows(edges1,1);
                allEdge = [allEdge1; allEdge2];
                allEdgeSort = sortrows(allEdge,1);
                % [timestamp    type of edge    burst train]
                % type of edge: 1 rise, -1 fall
                % burst train: 1 large ISI th, 2 strict ISI th
                % look for rise edge of large ISIth
                burstBegin = find(allEdgeSort(:,2)==1 & allEdgeSort(:,3)==1);
                b = 0;
                newBurstDetection = [];
                for ii = 1:length(burstBegin)
                    % if the following edge is -1,1 --> fall of large ISIth
                    % no burst is detected
                    if (allEdgeSort(burstBegin(ii)+1,2)==-1 && allEdgeSort(burstBegin(ii)+1,3)==1)
                        continue
                    else
                        % look for fall edge of large ISIth
                        thisBurstEnd = find(allEdgeSort(burstBegin(ii):end,2)==-1 & allEdgeSort(burstBegin(ii):end,3)==1,1);
                        thisBurstEnd = thisBurstEnd+burstBegin(ii)-1;
                        % look for rise edge of strict ISIth
                        subBurstBegin = find(allEdgeSort(burstBegin(ii):thisBurstEnd,2)==1 & allEdgeSort(burstBegin(ii):thisBurstEnd,3)==2);
                        subBurstBegin = subBurstBegin+burstBegin(ii)-1;
                        % if there's more than one
                        if length(subBurstBegin)>1
                            subBurstBegin = [burstBegin(ii);subBurstBegin(2:end)];
                            subBurstEnd = [subBurstBegin(2:end);thisBurstEnd];
                            for jj = 1:length(subBurstBegin)
                                b = b+1;
                                timestampBegin = allEdgeSort(subBurstBegin(jj),1);
                                tempTimestampEnd = allEdgeSort(subBurstEnd(jj),1);
                                if jj ~= length(subBurstBegin)
                                    spks = find(peakTrain(timestampBegin:tempTimestampEnd-1));
                                else
                                    spks = find(peakTrain(timestampBegin:tempTimestampEnd));
                                end
                                timestampEnd = timestampBegin+spks(end)-1;
                                numSpikesThisBurst = length(spks);
                                duration_s = (timestampEnd-timestampBegin)./param.sf;
                                newBurstDetection(b,:) = [timestampBegin timestampEnd numSpikesThisBurst duration_s];
                            end
                        else
                            b = b+1;
                            timestampBegin = allEdgeSort(burstBegin(ii),1);
                            timestampEnd = allEdgeSort(thisBurstEnd,1);
                            numSpikesThisBurst = sum(spones(peakTrain(timestampBegin:timestampEnd)));
                            duration_s = (timestampEnd-timestampBegin)./param.sf;
                            newBurstDetection(b,:) = [timestampBegin timestampEnd numSpikesThisBurst duration_s];
                        end
                    end
                end
            else
                % timestamps of edges (up&down)
                tsEdgeup2 = timestamp(edgeup2);
                tsEdgedown2 = timestamp(edgedown2);
                newBurstDetection = [tsEdgeup2, tsEdgedown2, (edgedown2-edgeup2+1), ...
                    (tsEdgedown2-tsEdgeup2)/param.sf];
            end
            if ~isempty(newBurstDetection)
                % MBR expressed in bursts/min
                numBursts = size(newBurstDetection,1);
                mbr = numBursts/(acqTime/60);
                if(mbr > param.MBRmin)      % only if the MBR is higher than MBRmin
                    % OUTSIDE BURST Parameters
                    temp = [(newBurstDetection(:,1)-1), (newBurstDetection(:,2)+1)];
                    if temp(1,1) <= 0
                        temp(1,1) = 1;
                    end
                    if temp(end,2) > numberOfSamples
                        temp(end,2) = numberOfSamples;
                    end
                    out_burst = reshape(temp',[],1);
                    out_burst = [1;out_burst;numberOfSamples];
                    out_burst = reshape(out_burst, 2, [])';
                    % now out_burst contains indexes of start of periods
                    % outside burst and end of periods outside bursts
                    rlines = size(out_burst,1);
                    outburst_cell = cell(rlines,7);
                    for k = 1:rlines
                        outb_period = (out_burst(k,2)-out_burst(k,1))/param.sf;   % duration [sec] of the non-burst period
                        outbspikes = timestamp(timestamp >= out_burst(k,1) & timestamp <= out_burst(k,2));
                        n_outbspikes = length(outbspikes);
                        mfob = n_outbspikes/outb_period;       % Mean frequency in the non-burst period
                        isi_outbspikes = diff(outbspikes)/param.sf; % ISI [sec] - for the spikes outside the bursts
                        f_outbspikes = 1./isi_outbspikes;     % frequency between two consecutive spikes outside the bursts

                        outburst_cell{k,1}= out_burst(k,1);  % Init of the non-burst period
                        outburst_cell{k,2}= out_burst(k,2);  % End of the non-burst period
                        outburst_cell{k,3}= n_outbspikes;    % Number of spikes in the non-burst period
                        outburst_cell{k,4}= mfob;            % Mean Frequency in the non-burst period
                        % it is the timestamp!
                        outburst_cell{k,5}= outbspikes;      % Position of the spikes in the non-burst period
                        outburst_cell{k,6}= isi_outbspikes;  % ISI of spikes in the non-burst period
                        outburst_cell{k,7}= f_outbspikes;    % Frequency of the spikes in the non-burst period
                    end
                    ave_mfob = mean(cell2mat(outburst_cell(:,4))); % Average frequency outside the burst - v1: all elements
                    % ave_mfob = mean(nonzeros(cell2mat(outburst_cell(:,4)))); % Average frequency outside the burst - v2: only non zeros elements
                    % INSIDE BURST Parameters
                    binit = newBurstDetection(:,1);     % Burst init [samples]
                    % put 1 in the timestamp of the first spike of each
                    % burst
                    burst_event = sparse(binit, ones(length(binit),1), 1); % Burst event
                    bp = [diff(binit)/param.sf; 0];     % Burst Period [sec] - start-to-start
                    ibi = [((newBurstDetection(2:end,1)- newBurstDetection(1:end-1,2))/param.sf); 0]; % Inter Burst Interval, IBI [sec] - end-to-start
                    lastrow = [acqTime, length(timestamp), numBursts, sum(newBurstDetection(:,3)), mbr, ave_mfob];
                    burstTrain = [newBurstDetection, ibi, bp; lastrow];
                    % burstTrain = [init, end, nspikes, duration, ibi, bp;
                    % acquisition time, total spikes, total bursts, total burst
                    % spikes, mbr, average mfob]
                    burstEventTrain = burst_event;
                    outBurstSpikes = outburst_cell;
                else
                    burstTrain = [];
                    burstEventTrain = [];
                    outBurstSpikes = [];
                end
            else
                burstTrain = [];
                burstEventTrain = [];
                outBurstSpikes = [];
            end
        else
            burstTrain = [];
            burstEventTrain = [];
            outBurstSpikes = [];
        end
    else
        burstTrain = [];
        burstEventTrain = [];
        outBurstSpikes = [];
    end
else
    burstTrain = [];
    burstEventTrain = [];
    outBurstSpikes = [];
end