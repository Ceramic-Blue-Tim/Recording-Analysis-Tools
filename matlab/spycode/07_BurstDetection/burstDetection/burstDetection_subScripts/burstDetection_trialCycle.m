% burstDetection_trialCycle.m
% Detects bursts from the collection of peak
% trains (trial by trial)
function [newBurstDetection_cell, burstEvent_cell, outburstSpikes_cell] = ...
    burstDetection_trialCycle(startPath, ISIThFolder, userParam)
% count number of different trials
trialFolders = dirr(startPath);
numTrials = length(trialFolders); 
% initialize variables
maxNumElec = 88;
newBurstDetection_cell = cell(maxNumElec,numTrials);
burstEvent_cell = cell(maxNumElec,numTrials);
outburstSpikes_cell = cell(maxNumElec,numTrials);
% ------ COMPUTATION ------
cancWinSample = userParam.cancWin*1e-3*userParam.sf;    % [sample]
hWB = waitbar(0,'Burst Detection...Please wait...','Position',[50 50 275 50]);
u = 0;
for j = 1:numTrials
    u = u + 1/(numTrials);
    waitbar(u,hWB)
    trialFolder = fullfile(startPath,trialFolders(j).name);
    numberOfSamples = getSamplesNumber(trialFolder);
    numberOfElectrodes = getElectrodesNumber(trialFolder);
    files = dirr(trialFolder);
    idxSlash = strfind(trialFolder,filesep);
    trialFolderName = trialFolder(idxSlash(end)+1:end);
%     [trialFolderPath, trialFolderName] = fileparts(trialFolder);
    % Load ISITh
    ISITh = importdata(fullfile(ISIThFolder,['ISIHistLOG_ISImaxTh_',trialFolderName,'.txt']));
    tic
    for k = 1:numberOfElectrodes
        filename = fullfile(trialFolder,files(k).name);
        tmp         = split(filename, '_');
        tmp2        = split(tmp(end), '.');
        elecNumber   = char(tmp2(1));
        load(filename);
        if sum(peak_train) > 0        % if there is at least one spike
            %%%%%%%%% TO REVISE AS SOON AS THE NEW ARTEFACT DETECTION WILL
            %%%%%%%%% BE AVAILABLE
            if exist('artifact','var') && ~isempty(artifact) && ~isscalar(artifact)
                peak_train = delartcontr(peak_train,artifact,cancWinSample);    % delete artifact contribution
            end
            %%%%%%%%%
%             peakTrain = sparse(numberOfSamples,1);
%             peak_train = peak_train(1:numberOfSamples);
%             clear peak_train artifact
            if ISITh(k,3)
                ISIThThis = ISITh(ISITh(:,1)==elecNumber,:);
                [newBurstDetection_cell{elecNumber,j}, ...
                    burstEvent_cell{elecNumber,j}, ...
                    outburstSpikes_cell{elecNumber,j}] = ...
                    burstDetection_oneChannelComput(peak_train, ISIThThis, userParam);
            else
                continue
            end  
        else
            continue
        end
    end
    toc
end
close(hWB)