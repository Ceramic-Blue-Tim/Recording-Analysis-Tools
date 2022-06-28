% netBurstDetection_save.m
% saves the result of NB detection
function netBurstDetection_save(inputFolder, outputFolder, userParameters, NB, NBpattern)
numExp = find_expnum(inputFolder, '_BurstDetectionMAT');
trialFolders = dir(inputFolder);
trialNames = {trialFolders(:).name};
% discard . and ..
trialNames = trialNames(3:end);
% save parameters of the analysis
paramFile = fullfile(outputFolder, [numExp,'_NetworkBurstDetection_parameters.mat']);
% save(paramFile,'userParameters','winSizes')
save(paramFile,'userParameters','-mat')

cd (outputFolder);
% save 'NetworkBurstDetection_parameters.mat' 'userParameters';

for j = 1:size(NB,1)
    temp = findstr(trialNames{j},'_');
    curTrialName = trialNames{j}(temp(2)+1:end);
    fileName = fullfile(outputFolder,[numExp,'_NetworkBurstDetection_',curTrialName,'.mat']);
    netBursts = NB{j,1};
    netBurstsPattern = NBpattern{j,1};
    save(fileName,'netBursts','netBurstsPattern','-mat');
    
    % save('NetworkBurstDetection.mat', 'netBursts','netBurstsPattern');
    
end