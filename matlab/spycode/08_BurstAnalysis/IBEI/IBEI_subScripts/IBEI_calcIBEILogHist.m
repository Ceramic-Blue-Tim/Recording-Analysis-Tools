function [success, errorString] = IBEI_calcIBEILogHist(startFolder, outputFolder, param)
trialFiles = dirr(startFolder);
numTrials = length(trialFiles);
trialFilenames = {trialFiles.name};
idxUnderscore = strfind(trialFilenames,'_');
phaseNames = [];
c = 0;
for hh = 1:numTrials
%     curNumPhase = trialFilenames{hh}(idxUnderscore{hh}(end-2)+1:idxUnderscore{hh}(end-1)-1);
    curPhaseName = trialFilenames{hh}(idxUnderscore{hh}(end-2)+1:idxUnderscore{hh}(end)-1);
    if ~any(strcmp(curPhaseName,phaseNames))
        c = c+1;
        phaseNames{c} = curPhaseName;
        groupTrials(c,1) = hh;
        groupTrials(c,2) = hh;
    else
        groupTrials(c,2) = hh;
    end    
end
% groupTrials = [1 2;3 4;5 5];
% phaseNames = {'fisio1','BIC30','fisio2'};
numPhase = size(groupTrials,1);
% %%%%%%%%%%%%%%%%%%%%%%%%%%
for jj = 1:size(groupTrials,1)
        nTrialsPerPhase(jj) = groupTrials(jj,2)-groupTrials(jj,1)+1;
        % %%%%%%%%%%%%%%%%%%%%%%%%%%
        bins = cell(nTrialsPerPhase(jj),1);
        IBEILogHistNorm = cell(nTrialsPerPhase(jj),1);
        allIBEI = cell(nTrialsPerPhase(jj),1);
        % %%%%%%%%%%%%%%%%%%%%%%%%%%
    for ii = groupTrials(jj,1):groupTrials(jj,2)
        filename = fullfile(startFolder,trialFilenames{ii});
        load(filename)
        BEcell = burst_event_cell(~cellfun('isempty',burst_event_cell));
        maxLength = max(cellfun('length',BEcell));
        cumBETrain = sparse(maxLength,1);
        for kk = 1:length(BEcell)
            cumBETrain(find(BEcell{kk})) = cumBETrain(find(BEcell{kk}))+1;
        end
        cumBETrain = cumBETrain~=0;
        [bins{ii-groupTrials(jj,1)+1}, IBEILogHistNorm{ii-groupTrials(jj,1)+1},...
            allIBEI{ii-groupTrials(jj,1)+1}] = calcISILogHist(cumBETrain, param.nBinsPerDec, param.sf);
    end
    ls = cellfun('length',bins);
    [maxNumBins, idxMaxNumBins] = max(ls);
    binsAver{jj,1} = bins{idxMaxNumBins};
    IBEILogHistNormAver{jj,1} = zeros(maxNumBins,1);
    for kk = 1:nTrialsPerPhase(jj)
        if ~isempty(IBEILogHistNorm{kk})
            IBEILogHistNormAver{jj,1} = IBEILogHistNormAver{jj,1}+...
                padarray(IBEILogHistNorm{kk},maxNumBins-ls(kk),0,'post');
        end
    end
    IBEILogHistNormAver{jj,1} = IBEILogHistNormAver{jj,1}./nTrialsPerPhase(jj);
end
[IBEILogHistNormSmoothed] = smoothISI(IBEILogHistNormAver,param.smoothMethod,param.smoothSpan);
[IBEImax4BurstDet, peaks, flags] = calcIBEImax(binsAver, ...
    IBEILogHistNormSmoothed, param.minPeakDistance, param.voidParamTh, ...
    param.timeTh, numPhase);
[plotIBEISmoothPeaksFlag, errorString] = plotIBEISmoothPeaks(outputFolder,phaseNames,binsAver,IBEILogHistNormSmoothed,...
    IBEImax4BurstDet,peaks,flags);
if ~plotIBEISmoothPeaksFlag
    errordlg('plotISISmoothPeaks: Some errors have occurred! Execution terminated!', '!!Error!!', 'modal');
    return
end
IBEIThFolderName = 'IBEImaxTh';
try
    mkdir(outputFolder,IBEIThFolderName);
catch
    success = 0;
    errorStr = lasterror;
    errordlg(errorStr.message,errorStr.identifier)
    return
end
IBEIThFolder = fullfile(outputFolder,IBEIThFolderName);
fname1 = fullfile(IBEIThFolder,'IBEIHistLOG_IBEImaxTh.mat');
fname2 = fullfile(IBEIThFolder,'IBEIHistLOG_IBEImaxTh.txt');
IBEImax = [];
for zz = 1:numPhase
    IBEImax = [IBEImax; (groupTrials(zz,1):groupTrials(zz,2))', ...
        IBEImax4BurstDet(zz)*ones(nTrialsPerPhase(zz),1), ...
        flags(zz)*ones(nTrialsPerPhase(zz),1)];
end
try
    save(fname1,'IBEImax','-mat')
    save(fname2,'IBEImax','-ASCII')
catch
    success = 0;
    errorStr = lasterror;
    errordlg(errorStr.message,errorStr.identifier)
    return
end
success = 1;