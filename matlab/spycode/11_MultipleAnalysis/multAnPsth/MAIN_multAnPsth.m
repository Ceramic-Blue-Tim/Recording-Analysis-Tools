function [ outputMessage ] = multAnPsth(expFolder,commonParameters, psthParameters)
%MULTANPSTH Summary of this function goes here
%   Detailed explanation goes here
% created by Luca Leonardo Bologna 24 February 2007
%common parameters
sampFreq=commonParameters{1,2};
artThresh=commonParameters{1,4};
mFactor=1000;
blankWinForArt=commonParameters{1,6}*mFactor/sampFreq; %denormalising for compatibility with previous versions
%
outputMessage=['Folder ' expFolder ': '];
%

%
performPsthCompPsthLatencyCheckbox=psthParameters{2,2};
psthBinSizeEdit=psthParameters{2,4}*mFactor/sampFreq; %denormalising for compatibility with previous versions
psthTimeFrameEdit=psthParameters{2,6}*mFactor/sampFreq; %denormalising for compatibility with previous versions
%
performPsthPlotMulPsthCheckbox=psthParameters{3,2};
plotMulPsthNumStimSesEdit=psthParameters{3,4};
plotMulPsthXAxisLimitEdit=psthParameters{3,6};
%
performPsthPlotMulPsth8x8Checkbox=psthParameters{4,2};
plotMulPsth8x8StimSesEdit=psthParameters{4,4};
plotMulPsth8x8PsthTimeFrameEdit=psthParameters{4,6};
plotMulPsth8x8PsthYAxisLimEdit=psthParameters{4,8};
%
performPsthPlotStimRastAllPhCheckbox=psthParameters{5,2};
%
performPsthCompAreaPsthCheckbox=psthParameters{6,2};
%
if performPsthCompPsthLatencyCheckbox==1
    [ foldNum, foldPath ] = extractSpecFoldPath( expFolder,'.*_PeakDetectionMAT.*');
    if foldNum==1
        multAnPsthPsthLatency(foldPath,sampFreq, psthBinSizeEdit, blankWinForArt, psthTimeFrameEdit);
    end
end
%
if performPsthPlotMulPsthCheckbox==1
    [ foldPsthFilesNum, psthFilesFoldPath ] = extractSpecFoldPath( expFolder,'.*_PSTHfiles.*');
    if foldPsthFilesNum==1
        [ foldPsthResultsNum, psthResultsFoldPath ] = extractSpecFoldPath( expFolder,'.*_PSTHresults.*');
        if foldPsthResultsNum==1
            multAnPsthMultPlot(psthFilesFoldPath,psthResultsFoldPath,plotMulPsthNumStimSesEdit,plotMulPsthXAxisLimitEdit);
        end
    end
end
%
if performPsthPlotMulPsth8x8Checkbox==1
    [ foldPsthFilesNum, psthFilesFoldPath ] = extractSpecFoldPath( expFolder,'.*_PSTHfiles.*');
    if foldPsthFilesNum==1
        [ foldPsthResultsNum, psthResultsFoldPath ] = extractSpecFoldPath( expFolder,'.*_PSTHresults.*');
        if foldPsthResultsNum==1
            multAnPsthMultPlot8x8(psthFilesFoldPath,psthResultsFoldPath,plotMulPsth8x8StimSesEdit,plotMulPsth8x8PsthTimeFrameEdit,plotMulPsth8x8PsthYAxisLimEdit);
        end
    end
end
%
if performPsthPlotStimRastAllPhCheckbox==1
    [ foldPsthResultsNum, psthResultsFoldPath ] = extractSpecFoldPath( expFolder,'.*_PSTHresults.*');
    if foldPsthResultsNum==1
        [ foldPsthStimWinNum, psthStimWinPath ] = extractSpecFoldPath( psthResultsFoldPath,'.*PSTHstimwin.*');
        if foldPsthStimWinNum==1
            multAnPsthPlotStimRaster(psthStimWinPath,psthResultsFoldPath);
        end
    end
end
%
if performPsthCompAreaPsthCheckbox==1
    [ foldPsthFilesNum, psthFilesFoldPath ] = extractSpecFoldPath( expFolder,'.*_PSTHfiles.*');
    if foldPsthFilesNum==1
        [ foldPsthResultsNum, psthResultsFoldPath ] = extractSpecFoldPath( expFolder,'.*_PSTHresults.*');
        if foldPsthResultsNum==1
            multAnPsthCompArea(psthFilesFoldPath,psthResultsFoldPath);
        end
    end
end