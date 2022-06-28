function [ outputMessage ] = MAIN_multAnCrossCorrelation(expFolder,commonParameters, cCorrParameters)
%MULTANCROSSCORRELATION Summary of this function goes here
% modified by Luca Leonardo Bologna (10 June 2007)
%     - fixed bug on folders retrieving

outputMessage=['Folder ' expFolder ': '];
mFactor=1000;
samplingFrequencyEdit=commonParameters{1,2};
artifactThresholdEdit=commonParameters{1,4};
blankWindForArtEdit=commonParameters{1,6}; %already normalized
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Cross Correlation Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Spike Train
%%%%%%%%%%%%%%%%%%%%%%%%%%%
performCCorrOnStCheckbox=cCorrParameters{2,2};
performCCorrOnStCorrWinEdit=cCorrParameters{2,4};
performCCorrOnStBinSizeEdit=cCorrParameters{2,6};
performCCorrOnStNormMethPopupmenu=cCorrParameters{2,8};
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Burst Event
%%%%%%%%%%%%%%%%%%%%%%%%%%%
performCCorrOnBeCheckbox=cCorrParameters{3,2};
performCCorrOnBeCorrWinEdit=cCorrParameters{3,4};
performCCorrOnBeBinSizeEdit=cCorrParameters{3,6};
performCCorrOnBeNormMethPopupmenu=cCorrParameters{3,8}; %numerical value index of "String" in component
%%% Valentina 20.04.2007
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Functional connectivity
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % performCCorrCompFuncConnCheckbox=cCorrParameters{4,2};
% % % performCCorrCompFunConnThreshEdit=cCorrParameters{4,4};
% % % performCCorrFuncConnHalfAreaPopupmenu=cCorrParameters{4,6};%numerical value index of "String" in component
% % % performCCorrFuncConnHalfAreaEdit=cCorrParameters{4,8}; % #bins
% % % performCCorrCompFunConnMeaPopupmenu=cCorrParameters{4,10};%numerical value index of "String" in component
% % % performCCorrCompFunConnClusterPopupmenu=cCorrParameters{4,12};%numerical value index of "String" in component
%%% Valentina 20.04.2007
%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Plot 3D Correlogram
%%%%%%%%%%%%%%%%%%%%%%%%%%
performCCorrPlot3DCorrelogramCheckbox=cCorrParameters{5,2};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Plot Mean Correlogram
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
performCCorrPlotMeanCorrelogramCheckbox=cCorrParameters{6,2};
%%% Valentina 20.04.2007
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Analyze Cross Corr on ST
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
anCCSTCheckbox=cCorrParameters{7,2};
binsAroundPeakSTEdit=cCorrParameters{7,4};
binsAroundZeroSTEdit=cCorrParameters{7,6};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Analyze Cross Corr on BE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
anCCBECheckbox=cCorrParameters{8,2};
binsAroundPeakBEEdit=cCorrParameters{8,4};
binsAroundZeroBEEdit=cCorrParameters{8,6};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% compatibility code
% % % nbins     = performCCorrFuncConnHalfAreaEdit;  % Half area around the peak [# bin]
% % % peakID    = performCCorrFuncConnHalfAreaPopupmenu;  % Around the peak or around zero
% % % threshold = performCCorrCompFunConnThreshEdit; % Threshold for functional connectivity
% % % arrayID   = performCCorrCompFunConnMeaPopupmenu; % Type of array
% % % clusterID = performCCorrCompFunConnClusterPopupmenu; % Cluster identifier
%%% Valentina 20.04.2007
fs=samplingFrequencyEdit;
%
% --------------> MAIN VARIABLES DEFINITION
mcmea_electrodes = [(11:18)'; (21:28)'; (31:38)'; (41:48)'; (51:58)'; (61:68)'; (71:78)';(81:88)'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cross correlation on Spike Train
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if performCCorrOnStCheckbox
    [ foldNum, foldPath ] = extractSpecFoldPath( expFolder,'.*PeakDetectionMAT.*');
    if foldNum==1
        start_folder=foldPath;
        [exp_num]=find_expnum(start_folder, '_PeakDetectionMAT'); % To be revised
        [r_tabledir]= uigetfoldername(exp_num, performCCorrOnStBinSizeEdit*1000/samplingFrequencyEdit, performCCorrOnStCorrWinEdit*1000/samplingFrequencyEdit, expFolder, 'msec');
        buildcorrelogram (start_folder, r_tabledir, performCCorrOnStCorrWinEdit, performCCorrOnStBinSizeEdit, blankWindForArtEdit, samplingFrequencyEdit, performCCorrOnStNormMethPopupmenu) % for spike train
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cross correlation on Burst Event
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if performCCorrOnBeCheckbox==1
    [ foldNum, foldMatPath ] = extractSpecFoldPath( expFolder,'.*BurstDetectionMAT.*msec');
%     [ foldNum, foldMatPath ] = extractSpecFoldPath( expFolder,'.*BurstDetectionMAT');
    if foldNum==1
        cd(foldMatPath)
        [ foldNum, foldPath ] = extractSpecFoldPath( foldMatPath,'.*BurstEventFiles');
        if foldNum==1
            start_folder=foldPath;
            [exp_num]=find_expnum(start_folder, '_BurstEventFiles');
            [r_tabledir]= uigetfoldernameBE(exp_num,performCCorrOnBeBinSizeEdit*1000/samplingFrequencyEdit, performCCorrOnBeCorrWinEdit*1000/samplingFrequencyEdit, foldMatPath, 'msec');
            buildcorrelogrambe (start_folder, r_tabledir, performCCorrOnBeCorrWinEdit, performCCorrOnBeBinSizeEdit, blankWindForArtEdit, samplingFrequencyEdit,performCCorrOnBeNormMethPopupmenu) % for burst event
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%
% Plot 3D Correlogram
%%%%%%%%%%%%%%%%%%%%%
if  performCCorrPlot3DCorrelogramCheckbox==1
    [ foldNum, foldPath ] = extractSpecFoldPath( expFolder,'.*CCorr_\d+-\d+msec');
    if foldNum==1
        multAnCCorrPlot3DCorr(foldPath,samplingFrequencyEdit);
    end
    % [ foldNum, foldMatPath ] = extractSpecFoldPath( expFolder,'.*BurstDetectionMAT.*msec');
    [ foldNum, foldMatPath ] = extractSpecFoldPath( expFolder,'.*BurstDetectionMAT');
    if foldNum==1
        [ foldNum, foldPath ] = extractSpecFoldPath( foldMatPath,'.*BurstEvent_CCorr.*msec');
        if foldNum~=0
            % TODO put an ouput message
            subBurFoldNum=size(foldPath,1);
            for ii=1:subBurFoldNum
                multAnCCorrPlot3DCorr(foldPath(ii,:) ,samplingFrequencyEdit);
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%
% Plot Mean Correlogram
%%%%%%%%%%%%%%%%%%%%%%%
if performCCorrPlotMeanCorrelogramCheckbox==1
    [ foldNum, foldPath ] = extractSpecFoldPath( expFolder,'.*CCorr_\d+-\d+msec');
    if foldNum==1
        multAnCCorrPlotMeanCorr(foldPath,samplingFrequencyEdit);
    end
    % [ foldNum, foldMatPath ] = extractSpecFoldPath( expFolder,'.*BurstDetectionMAT.*msec');
    [ foldNum, foldMatPath ] = extractSpecFoldPath( expFolder,'.*BurstDetectionMAT');
    if foldNum==1
        [ foldNum, foldPath ] = extractSpecFoldPath( foldMatPath,'.*BurstEvent_CCorr.*msec');
        if foldNum~=0
            % TODO put an ouput message
            subBurFoldNum=size(foldPath,1);
            for ii=1:subBurFoldNum
                multAnCCorrPlotMeanCorr(foldPath(ii,:),samplingFrequencyEdit);
            end
        end

    end
end
%%% Valentina 20.04.2007
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analyze Cross Corr on ST
%%%%%%%%%%%%%%%%%%%%%%%%%%
if anCCSTCheckbox==1
    [ foldNum, foldMatPath ] = extractSpecFoldPath( expFolder,'.*CCorr_\d+-\d+msec');
    if foldNum~=0
        % TODO put an ouput message
        subCorrFoldNum=size(foldMatPath,1);
        for ii=1:subCorrFoldNum
            start_folder=foldMatPath(ii,:);
            [exp_num]=find_expnum(start_folder, '_CCorr');
            if performCCorrOnStCheckbox
                multAnCCorrParam(start_folder,exp_num,fs,binsAroundPeakSTEdit,binsAroundZeroSTEdit,performCCorrOnStBinSizeEdit,'ST');
            else
                multAnCCorrParam(start_folder,exp_num,fs,binsAroundPeakSTEdit,binsAroundZeroSTEdit,30,'ST');
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analyze Cross Corr on BE
%%%%%%%%%%%%%%%%%%%%%%%%%%
if anCCBECheckbox==1
   [foldNum, foldMatPath ] = extractSpecFoldPath( expFolder,'.*BurstDetectionMAT_5-80msec');
   cd(foldMatPath)
    [ foldNum, foldPath ] = extractSpecFoldPath( foldMatPath,'.*BurstEvent_CCorr.*msec');
    if foldNum~=0
        cd(foldPath)
        % TODO put an ouput message
        subBurFoldNum=size(foldPath,1);
        for ii=1:subBurFoldNum
            start_folder=foldPath(ii,:);
            [exp_num]=find_expnum(start_folder, '_BurstEvent_CCorr');
            if performCCorrOnBeCheckbox==1
                multAnCCorrParam(start_folder,exp_num,fs,binsAroundPeakBEEdit,binsAroundZeroBEEdit,performCCorrOnBeBinSizeEdit,'BE');
            else
                multAnCCorrParam(start_folder,exp_num,fs,binsAroundPeakBEEdit,binsAroundZeroBEEdit,1,'BE');
            end
        end
    end
end

%%% Valentina 20.04.2007