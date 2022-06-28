function [ outputMessage ] = MAIN_multAnBurstAnalysis(expFolder,commonParameters, burstAnalysisParameters)
%MULTANBURSTANALYSIS Summary of this function goes here
%   Detailed explanation goes here
% created by Luca Leonardo Bologna 24 February 2007

%common parameters

outputMessage=['Folder ' expFolder ': '];
mFactor=1000;
sampFreq=commonParameters{1,2};
artThresh=commonParameters{1,4};
blankWinForArt=commonParameters{1,6}/sampFreq*mFactor; %must be "denormalized" for compatibility with previous code
% temp variable
foldNum_BurstDetectionMAT=0;
foldNum_BurstDetectionFiles=0;
foldNum=0;
%
performBurstAnalysisBurstDetectionCheckbox=burstAnalysisParameters{2,2};
performBurstAnalysisMinNumIntraSpikesEdit=burstAnalysisParameters{2,4};
performBurstAnalysisMaxIntraIsiEdit=burstAnalysisParameters{2,6}/sampFreq*mFactor;%must be "denormalized" for compatibility with previous code
performBurstAnalysisBurstRateThreshEdit=burstAnalysisParameters{2,8};
%
performBurstAnalysisPlotMultipleIBI8x8Checkbox=burstAnalysisParameters{3,2};
plotMultipleIbi8x8IbiBinEdit=burstAnalysisParameters{3,4};
plotMultipleIbi8x8IbiWindowEdit=burstAnalysisParameters{3,6};
plotMultipleIbi8x8YLimEdit=burstAnalysisParameters{3,8};
%
performBurstAnalysisStatisticReportCheckbox=burstAnalysisParameters{4,2};
%
performBurstAnalysisStatisticReportMeanCheckbox=burstAnalysisParameters{5,2};
%
performBurstAnalysisPlotPercRandSpCheckbox=burstAnalysisParameters{6,2};
%
% verify if a PeakDetection folder is present
folders=dir(expFolder);
folders={folders.name};
% Look for Peak Detection folder
start_folder=regexpi(folders,'.*PeakDetectionMAT.*','match','once');
% indices of PeakDetectionMAT names folders
idx=find(~strcmp(start_folder(:),''));
start_folder=start_folder(idx);
start_folder=char(start_folder);
foldNum=size(start_folder,1);
%
if performBurstAnalysisBurstDetectionCheckbox==1
    if foldNum~=1
        outputMessage=[outputMessage 'impossible to perform "Burst Analysis": no PeakDetectionMAT folder or more than one is present'];
    else
        start_folderPeakDet=deblank(strcat(expFolder,filesep,start_folder)); %
        multAnBurAnBurDetect(start_folderPeakDet, performBurstAnalysisMinNumIntraSpikesEdit, performBurstAnalysisMaxIntraIsiEdit, performBurstAnalysisBurstRateThreshEdit, blankWinForArt, sampFreq )
    end
end
%%% perform the check on BurstDetectionMAT folder because possibly it has
%%% been recently created after the previous code excecution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Look for BurstDetectionMAT folder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
folders=dir(expFolder);
folders={folders.name};
start_folder_BurstDetectionMAT=regexpi(folders,'.*BurstDetectionMAT.*','match','once');
% indices of BurstDetectionMAT names folders
idx=find(~strcmp(start_folder_BurstDetectionMAT(:),''));
start_folder_BurstDetectionMAT=start_folder_BurstDetectionMAT(idx);
start_folder_BurstDetectionMAT=char(start_folder_BurstDetectionMAT);
foldNum_BurstDetectionMAT=size(start_folder_BurstDetectionMAT,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Look for BurstDetectionFiles folder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if foldNum_BurstDetectionMAT==1
    start_folder_BurstDetectionMAT=deblank(strcat(expFolder,filesep,start_folder_BurstDetectionMAT)); %
    foldersBurstDetMat=dir(start_folder_BurstDetectionMAT);
    burstDetectionMATFolders={foldersBurstDetMat.name};
    start_folder_BurstDetectionFiles=regexpi(burstDetectionMATFolders,'.*BurstDetectionFiles.*','match','once');
    % indices of BurstDetectionFiles names folders
    idx=find(~strcmp(start_folder_BurstDetectionFiles(:),''));
    start_folder_BurstDetectionFiles=start_folder_BurstDetectionFiles(idx);
    start_folder_BurstDetectionFiles=char(start_folder_BurstDetectionFiles);
    foldNum_BurstDetectionFiles=size(start_folder_BurstDetectionFiles,1);
end

% multiple plot
if performBurstAnalysisPlotMultipleIBI8x8Checkbox==1
    if foldNum_BurstDetectionFiles~=1
        outputMessage=[outputMessage 'impossible to perform "Plot Multiple IBI 8x8": no BurstDetectionFiles folder or more than one is present'];
    else
        startFoldBurstDetectionFiles=deblank(strcat(start_folder_BurstDetectionMAT,filesep,start_folder_BurstDetectionFiles)); %
        multAnBurAnPlotMulIBI8x8(startFoldBurstDetectionFiles,plotMultipleIbi8x8IbiBinEdit, plotMultipleIbi8x8IbiWindowEdit, plotMultipleIbi8x8YLimEdit, sampFreq );
    end
end
% statistic report
if performBurstAnalysisStatisticReportCheckbox==1
    if foldNum_BurstDetectionFiles~=1
        outputMessage=[outputMessage 'impossible to perform "StatisticReport": no BurstDetectionFiles folder or more than one is present'];
    else
        startFoldBurstDetectionFiles=deblank(strcat(start_folder_BurstDetectionMAT,filesep,start_folder_BurstDetectionFiles)); %
        multAnBurAnMainStatRep( startFoldBurstDetectionFiles );
    end
end
% statistic report mean
if     performBurstAnalysisStatisticReportMeanCheckbox==1
    if foldNum_BurstDetectionFiles~=1
        outputMessage=[outputMessage 'impossible to perform "StatisticReportMean": no BurstDetectionFiles folder or more than one is present'];
    else
        startFoldBurstDetectionFiles=deblank(strcat(start_folder_BurstDetectionMAT,filesep,start_folder_BurstDetectionFiles)); %
        multAnBurAnMainStatRepMean( startFoldBurstDetectionFiles );
    end
end
% plot perc of random spikes
if performBurstAnalysisPlotPercRandSpCheckbox==1
    [ foldNum, foldMatPath ] = extractSpecFoldPath( expFolder,'.*BurstAnalysis');
    if foldNum==1
        [ foldNum, foldPath ] = extractSpecFoldPath( foldMatPath,'.*MeanStatReportSPIKEinBURST');
        if foldNum==1
            start_folder=foldPath;
            end_folder=foldMatPath;
            multAnBurAnPlotHistPercRandSpikes(start_folder,end_folder);
        end
    end
end