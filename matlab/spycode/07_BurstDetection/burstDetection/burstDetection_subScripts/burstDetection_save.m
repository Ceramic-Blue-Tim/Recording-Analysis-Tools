% burstDetection_save.m
% saves the result of burst detection
function flag = burstDetection_save(PDfolder, saveFolderName, parameters, newBurstDetection, burstEvent, outburstSpikes)
% start_folder = pwd;
numExp = find_expnum(PDfolder, '_PeakDetectionMAT');
trialFolders = dir(PDfolder);
trialNames = {trialFolders(:).name};
% discard . and ..
trialNames = trialNames(3:end);
% build folder name according to date and time
% c = clock;
% saveFolderName = [numExp,'_BurstDetectionMAT_',date,'_',num2str(c(4)),num2str(c(5))];
% cd(PDfolder)
% cd ..
% mkdir(pwd,saveFolderName)
% cd(saveFolderName)
% save parameters of the analysis
paramFile = fullfile(saveFolderName, [numExp,'_BurstDetectionMAT_parameters.mat']);
save(paramFile,'parameters','-mat')
% create folders
newBurstDetection_folder = fullfile(saveFolderName, [numExp,'_BurstDetectionFiles']);
burstEvent_folder = fullfile(saveFolderName,[numExp,'_BurstEventFiles']);
outburstSpikes_folder = fullfile(saveFolderName,[numExp,'_OutBSpikesFiles']);
mkdir(newBurstDetection_folder)
mkdir(burstEvent_folder)
mkdir(outburstSpikes_folder)
disp('Saving...')
% saves files in folders
% cd(newBurstDetection_folder)
for j = 1:size(newBurstDetection,2)
    temp = findstr(trialNames{j},'_');
    curTrialName = trialNames{j}(temp(2)+1:end);
    fileName = fullfile(newBurstDetection_folder,[numExp,'_BurstDetection_',curTrialName,'.mat']);
    % change name because of compatibility with other scripts
    burst_detection_cell = newBurstDetection(:,j);
    save(fileName,'burst_detection_cell','-mat');
end
% cd ..
% cd(burstEvent_folder)
for j = 1:size(burstEvent,2)
    temp = findstr(trialNames{j},'_');
    curTrialName = trialNames{j}(temp(2)+1:end);
    fileName = fullfile(burstEvent_folder,[numExp,'_BurstEvent_',curTrialName,'.mat']);
    burst_event_cell = burstEvent(:,j);
    save(fileName,'burst_event_cell','-mat');
end
% cd ..
% cd(outburstSpikes_folder)
for j = 1:size(outburstSpikes,2)
    temp = findstr(trialNames{j},'_');
    curTrialName = trialNames{j}(temp(2)+1:end);
    fileName = fullfile(outburstSpikes_folder,[numExp,'_OutBSpikes',curTrialName,'.mat']);
    outburst_spikes_cell = outburstSpikes(:,j);
    save(fileName,'outburst_spikes_cell','-mat');
end
% cd(start_folder)
flag = 1;