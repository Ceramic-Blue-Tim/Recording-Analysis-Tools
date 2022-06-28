% netBurstDetection_trialCycle.m
% Detects Network Bursts (NBs) from the collection of burst event
% trains (trial per trial)
function [NB, NBpattern] = netBurstDetection_trialCycle(BDfolder, IBeIThreshFolder, param)
BDfiles = dirr(BDfolder);
numTrials = length(BDfiles); 
NB = cell(1,1);
NBpattern = cell(1,1);
h = waitbar(0);
step = 1/numTrials;
IBeIThreshFolderContent = dirr(IBeIThreshFolder,'.mat');
IBeIThreshFileName = IBeIThreshFolderContent.name;
IBeIThreshFileName = fullfile(IBeIThreshFolder,IBeIThreshFileName);
load(IBeIThreshFileName)
IBEIAmplTh = IBEImax(:,2:3);
for i = 1:numTrials
    waitbar(i*step,h,['Trial ',num2str(i)]);
%     if IBEIAmplTh(i,2)
        [BDTrains, burstCh] = loadBD(BDfolder, BDfiles(i).name);
        numBurstElec = length(burstCh);
        numElecTh = numBurstElec*param.th;
        [NB{i,1},NBpattern{i,1}] = netBurstDetection_alg(BDTrains, IBEIAmplTh(i,:), numElecTh, param);
        clear BDTrains
%     else
%         continue
%     end
end
close(h)