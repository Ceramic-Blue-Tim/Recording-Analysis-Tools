function [NB, NBpattern] = netBurstDetection_alg(BDTrains, IBeITh, numElecTh, userParam)
% BDTrains:
% 1st col: elec number
% 2nd col: burst init ([sample])
% 3rd col: burst end([sample])
% sorting bursts in chronological order
if (~isempty(BDTrains))
    BDTrainsSorted = sortrows(BDTrains,2);
    tsBE = BDTrainsSorted(:,2);
    % %%%%%%%
    if IBeITh(1,2)
        IBeITh_sample = round(IBeITh(1,1)/1000*userParam.sf);
    else
        IBeITh_sample = round(userParam.IBeIThDef/1000*userParam.sf);
    end
    % %%%%%%%%%%%%
    NBtrn = [0; diff(tsBE)<=IBeITh_sample; 0];
    NBedges = diff(NBtrn);
    NBFirstBurst = find(NBedges == 1);
    NBLastBurst = find(NBedges == -1);
    numNB = length(NBFirstBurst);
    numActElec = zeros(numNB,1);
    for i = 1:numNB
        % list of bursting electrodes (in the i-th NB)
        actElec = unique(BDTrainsSorted(NBFirstBurst(i):NBLastBurst(i),1));
        % counts number of active electrodes
        numActElec(i) = length(actElec);
    end
    NB2save = numActElec>=numElecTh;
    newNBFirstBurst = NBFirstBurst(NB2save);
    newNBLastBurst = NBLastBurst(NB2save);
    newNumNB = length(newNBFirstBurst);
    newNumActElec = numActElec(NB2save);
    NB = zeros(newNumNB,5);
    NBpattern = cell(newNumNB,1);
    for jj = 1:newNumNB
        burstBegin = BDTrainsSorted(newNBFirstBurst(jj),2);
        burstEnd = max(BDTrainsSorted(newNBFirstBurst(jj):newNBLastBurst(jj),3));
        if jj ~= newNumNB
            succBurstBegin = BDTrainsSorted(newNBFirstBurst(jj+1),2);
            if burstEnd >= succBurstBegin
                burstEnd = succBurstBegin-1;
            end
        end
        NB(jj,1:4) = [burstBegin, ... % ts of the begin of the first burst [samples]
            burstEnd, ...  % ts of the end of the longest burst [samples]
            newNBLastBurst(jj)-newNBFirstBurst(jj)+1,...        % number of bursts
            burstEnd-burstBegin]; % duration [samples]
        NB(jj,5) = newNumActElec(jj);
        NBpattern{jj} = BDTrainsSorted(newNBFirstBurst(jj):newNBLastBurst(jj),1:2);
    end
else
    NB = [];
    NBpattern = [];
end