% Script to identify Neuronal Avalanches on IMT arrays
% created by Valentina Pasquale, 2006-2007

% ------------ FOLDER SEEKING ---------------
% clear the workspace
clear all
clc
% select the folder that contains Peak Detection files
start_folder = pwd;
pkd_folder = uigetdir(pwd,'Select the folder that contains Peak Detection files');
if strcmp(num2str(pkd_folder),'0')          % halting case
    errordlg('Selection failed: end of session','Error')
    return
end
cd(pkd_folder)
cd ..
% select the end folder
end_folder = uigetdir(pwd,'Select the experiment folder');
if strcmp(num2str(end_folder),'0')          % halting case
    errordlg('Selection failed: end of session','Error')
    return
end

% ------------ VARIABLES INIZIALITATION --------------
% Extracts number of samples
samplesNum = aVa_getSamplesNumber(pkd_folder,'mat');
% Finds the number of the experiment
num_exp = find_expnum(pkd_folder, '_PeakDetection');    
% The user has to set the parameters for the AvalancheDetection through the
% available input prompt
[binWidths,sampling_freq,cancelFlag] = aVaIMT_uigetinfo();
if cancelFlag == 1 %halting case
    errordlg('Selection failed: end of session','Error')
    return
end

% ---------------------- START PROCESSING-------------------------------
% creates the output folder
[aVaAnalysisIMT] = createresultfolder(end_folder, num_exp, ['aVaAnalysisIMT_', num2str(binWidths(1)), '-', num2str(binWidths(end)), 'ms']);
cd(pkd_folder)
for ii = 1:max(size(binWidths))
    bin_w = binWidths(ii);
    % create results folder
    finalString = strcat('aVaIMT_bin',num2str(bin_w));                           % building part of the final name
    [aVaResultsIMT] = createresultfolder(aVaAnalysisIMT, num_exp, finalString);
    [aVaData] = createresultfolder(aVaResultsIMT, num_exp, [finalString,'_avalanches']);
    disp(['Bin Width ', num2str(bin_w), ' ms...'])
    % calculate avalanche's size and lifetime histograms (version 1&2)
    [hSize1Clust, hSize2Clust, hLifetimeClust, branchingClust, branchClustMean, branchClustSTD, branchClustSTE] = aVaIMT_mainProcessing(pkd_folder, aVaData, bin_w, sampling_freq, samplesNum);
    % preprocessing of data for fitting
    [edgesSize1Clust, hSize1ClustNorm] = aVaIMT_preprocessFit(hSize1Clust);
    [edgesSize2Clust, hSize2ClustNorm] = aVaIMT_preprocessFit(hSize2Clust);
    [edgesLifetimeClust, hLifetimeClustNorm] = aVaIMT_preprocessFit(hLifetimeClust);
    
    % LINEAR BINNING
    % fitting
    [fitSize1Clust, gofSize1Clust, edgesFitSize1Clust, fitEvalSize1Clust, slopesSize1] = aVaIMT_fitting(edgesSize1Clust, hSize1ClustNorm);
    [fitSize2Clust, gofSize2Clust, edgesFitSize2Clust, fitEvalSize2Clust, slopesSize2] = aVaIMT_fitting(edgesSize2Clust, hSize2ClustNorm);
    [fitLifetimeClust, gofLifetimeClust, edgesFitLifetimeClust, fitEvalLifetimeClust, slopesLifetime] = aVaIMT_fitting(edgesLifetimeClust, hLifetimeClustNorm);
    
    cd(aVaResultsIMT); % seeks the correct directory
    % save data
    fname = [num2str(num_exp),'_aVaIMT_bin',num2str(bin_w),'_histNotNorm.mat'];
    save(fname,'hSize1Clust', 'hSize2Clust', 'hLifetimeClust')
    fname = [num2str(num_exp),'_aVaIMT_bin',num2str(bin_w),'_branching.mat'];
    save(fname,'branchingClust','branchClustMean', 'branchClustSTD', 'branchClustSTE')
    fname = [num2str(num_exp),'_aVaIMT_bin',num2str(bin_w),'_histNorm.mat'];
    save(fname,'hSize1ClustNorm', 'hSize2ClustNorm', 'hLifetimeClustNorm','edgesSize1Clust','edgesSize2Clust','edgesLifetimeClust')
    fname = [num2str(num_exp),'_aVaIMT_bin',num2str(bin_w),'_fitting.mat'];
    save(fname,'fitSize1Clust','gofSize1Clust','edgesFitSize1Clust','fitEvalSize1Clust','fitSize2Clust','gofSize2Clust','edgesFitSize2Clust','fitEvalSize2Clust','fitLifetimeClust','gofLifetimeClust','edgesFitLifetimeClust','fitEvalLifetimeClust')
    % create and save figures
    figName = [num2str(num_exp),'_aVaIMT_bin',num2str(bin_w),'_FittedSize1.fig'];
    aVaIMT_createSaveFigure(edgesSize1Clust,hSize1ClustNorm,edgesFitSize1Clust,fitEvalSize1Clust,1,bin_w,slopesSize1,aVaResultsIMT,figName);
    figName = [num2str(num_exp),'_aVaIMT_bin',num2str(bin_w),'_FittedSize2.fig'];
    aVaIMT_createSaveFigure(edgesSize2Clust,hSize2ClustNorm,edgesFitSize2Clust,fitEvalSize2Clust,2,bin_w,slopesSize2,aVaResultsIMT,figName);
    figName = [num2str(num_exp),'_aVaIMT_bin',num2str(bin_w),'_FittedLifetime.fig'];
    aVaIMT_createSaveFigure(edgesLifetimeClust,hLifetimeClustNorm,edgesFitLifetimeClust,fitEvalLifetimeClust,3,bin_w,slopesLifetime,aVaResultsIMT,figName); 
end
cd(start_folder)
warndlg('Successfully accomplished!','End Session')
clear