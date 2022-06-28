function [flag, errorStr] = IFR_trialCycle(PDfolder,outFolder,commonParam,computParam,saveParam)

% handles.commonParameters = struct('sf',sf);
% handles.computParameters = struct('spikingThreshold',spkTh,...
%                     'autoAdjFlag',autoAdjFlag,...
%                     'selectedKernel_string',selectedString,...
%                     'kernelWidth',width,...
%                     'mfrMultFactor',multFactor,...
%                     'undersamplingFactor',undersamplFactor);
% handles.saveParameters = struct('saveIFRSingleCh',saveIFRSingleCh,...
%                     'saveIFRArrayWide',saveIFRArrayWide,...
%                     'saveIFRFig',saveIFRFig);

numExp = find_expnum(PDfolder, '_PeakDetectionMAT');
trialFolders = dirr(PDfolder);
numTrials = length(trialFolders);
hw = waitbar(0);
for j = 1:numTrials
    step = j/numTrials;
    waitbar(step,hw,['Trial ',num2str(j),'...'])
    trialFolder = fullfile(PDfolder,trialFolders(j).name);
    numberOfSamples = getSamplesNumber(trialFolder);
    numberOfElectrodes = getElectrodesNumber(trialFolder);
    IFRTable = sparse(zeros(floor(numberOfSamples/computParam.undersamplingFactor),numberOfElectrodes));
    binSizes = zeros(1,numberOfElectrodes);
    elecNumbers = zeros(1,numberOfElectrodes);
    files = dirr(trialFolder);
    for k = 1:numberOfElectrodes
        filename = fullfile(trialFolder,files(k).name);
        tmp         = split(filename, '_');
        tmp2        = split(tmp(end), '.');
        elNum       = char(tmp2(1));
        elecNumbers(k) = str2double(elNum);
        load(filename);
        if sum(peak_train) > 0        % if there is at least one spike
            %%%%%%%%% TO REVISE AS SOON AS THE NEW ARTEFACT DETECTION WILL
            %%%%%%%%% BE AVAILABLE
            cancwin = 4; % [ms]
            if exist('artifact','var') && ~isempty(artifact) && ~isscalar(artifact)
                peak_train = delartcontr(peak_train, artifact, cancwin); % Delete the artifact contribution
            end
            %%%%%%%%%
            peakTrain = peak_train(1:numberOfSamples);
            clear peak_train artifact
            [IFRTable(:,k), binSizes(k)] = IFR_singleChComp(peakTrain,commonParam,computParam);
            clear peakTrain
        else
            IFRTable(:,k) = zeros(floor(numberOfSamples/computParam.undersamplingFactor),1);
            binSizes(k) = 0;
        end
    end
    cumIFR = sum(IFRTable,2);
    % saving
    if saveParam.saveIFRSingleCh
        fname = fullfile(outFolder,[numExp, '_IFR_', trialFolders(j).name,'.mat']);
        try
            save(fname,'IFRTable','binSizes','elecNumbers','-mat')
        catch
            flag = 0;
            errorStr = lasterror;
            errordlg(errorStr.message,errorStr.identifier)
            return
        end
    end
    if saveParam.saveIFRArrayWide
        fname = fullfile(outFolder,[numExp, '_cumIFR_', trialFolders(j).name,'.mat']);
        try
            save(fname,'cumIFR','-mat')
        catch
            flag = 0;
            errorStr = lasterror;
            errordlg(errorStr.message,errorStr.identifier)
            return
        end
    end
    if saveParam.saveIFRFig
        x = computParam.undersamplingFactor:computParam.undersamplingFactor:numberOfSamples;
        h = IFR_plot(IFRTable, cumIFR, x);
        fnameFig = fullfile(outFolder,[numExp, '_IFRFig_', trialFolders(j).name,'.fig']);
        fnameJpg = fullfile(outFolder,[numExp, '_IFRFig_', trialFolders(j).name,'.jpg']);
        try
            saveas(h,fnameFig,'fig')
            saveas(h,fnameJpg,'jpg')
        catch
            flag = 0;
            errorStr = lasterror;
            errordlg(errorStr.message,errorStr.identifier)
            return
        end
        close(h)
    end
    clear IFRTable binSizes elecNumbers cumIFR
end
fname = fullfile(outFolder,[numExp, '_IFR_saveParameters.mat']);
try
    save(fname,'commonParam','computParam','saveParam','-mat')
catch
    flag = 0;
    errorStr = lasterror;
    errordlg(errorStr.message,errorStr.identifier)
    return
end
flag = 1;
errorStr = [];
close(hw)