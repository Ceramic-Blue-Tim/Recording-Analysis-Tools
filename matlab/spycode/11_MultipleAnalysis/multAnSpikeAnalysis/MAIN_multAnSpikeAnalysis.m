function [ outputMessage ] = MAIN_multAnSpikeAnalysis(expFolder,commonParameters, spikeAnalysisParameters)
%MULTANSPIKEANALYSIS Summary of this function goes here
%   Detailed explanation goes here
% created by Luca Leonardo Bologna 24 February 2007

%common parameters
sampFreq=commonParameters{1,2};
artThresh=commonParameters{1,4};
blankWinForArt=commonParameters{1,6}; %already normalized
mFactor=1000;

% Spike Analysis Parameters
% mean firing rate
compMfrFrthreshEdit=spikeAnalysisParameters{2,4};% not to be normalized
% average firing rate
compAfrBinSizeEdit=spikeAnalysisParameters{3,4};
compAfrFrthreshEdit=spikeAnalysisParameters{3,6};
% multiple ISI plot

plotMulIsiIsiBinEdit=spikeAnalysisParameters{4,4};
plotMulIsiIsiWinEdit=spikeAnalysisParameters{4,6};
plotMulIsiIsiYLimEdit=spikeAnalysisParameters{4,8};


outputMessage=['Folder ' expFolder ': '];
% verify if a PeakDetection folder is present
folders=dir(expFolder);
folders={folders.name};
start_folder=regexpi(folders,'.*PeakDetectionMAT.*','match','once');
% indices of PeakDetectionMAT names folders
idx=find(~strcmp(start_folder(:),''));
start_folder=start_folder(idx);
start_folder=char(start_folder);
foldNum=size(start_folder,1);
if foldNum==0
    outputMessage=[outputMessage 'impossible to perform "Spike Analysis": no PeakDetectionMAT folder is present'];
    return
elseif foldNum>1
    outputMessage=[outputMessage 'impossible to perform "Spike Analysis": more than one PeakDetectionMAT folder is present'];
    return
else
    start_folder=deblank(strcat(expFolder,filesep,start_folder)); %
    if spikeAnalysisParameters{2,2}==1
        multAnSpAnMfr (start_folder,compMfrFrthreshEdit,sampFreq,blankWinForArt);
    end
    if spikeAnalysisParameters{3,2}==1
        multAnSpAnAfr(start_folder, compAfrBinSizeEdit, compAfrFrthreshEdit, sampFreq,blankWinForArt);
    end
    if spikeAnalysisParameters{4,2}==1
         multAnSpAnPloMujltIsi8x8( start_folder,plotMulIsiIsiBinEdit, plotMulIsiIsiWinEdit, plotMulIsiIsiYLimEdit, sampFreq );
    end
end