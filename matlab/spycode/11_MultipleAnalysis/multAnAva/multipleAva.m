function multipleAva(pkd_folder, end_folder, sampling_freq, binWidths, flagExpBin)
% multipleAva.m
% Multiple Neuronal Avalanches detection algorithm (aVa)
% created by Valentina Pasquale, 2006-2007

% ------------ VARIABLES INIZIALITATION --------------
start_folder = pwd;
% Extracts number of samples
samplesNum = aVa_getSamplesNumber(pkd_folder,'mat');
% Finds the number of the experiment
num_exp = find_expnum(pkd_folder, '_PeakDetection');    
% cell array for all time bins
edgesSize1All = cell(1,1);
edgesSize2All = cell(1,1);
edgesLifetimeAll = cell(1,1);
hSize1All = cell(1,1);
hSize2All = cell(1,1);
hLifetimeAll = cell(1,1);
if (flagExpBin)
    edgesSize1RebinAll = cell(1,1);
    edgesSize2RebinAll = cell(1,1);
    edgesLifetimeRebinAll = cell(1,1);
    hSize1RebinAll = cell(1,1);
    hSize2RebinAll = cell(1,1);
    hLifetimeRebinAll = cell(1,1);
end

% ---------------------- START PROCESSING-------------------------------
% creates the output folder
[aVaAnalysis] = createresultfolder(end_folder, num_exp, ['aVaAnalysis_', num2str(binWidths(1)), '-', num2str(binWidths(end)), 'ms']);
cd(pkd_folder)
for ii = 1:max(size(binWidths))
    bin_w = binWidths(ii);
    disp(['Bin Width ', num2str(bin_w), ' ms...'])
    % calculate avalanche's size and lifetime histograms (version 1&2)
    [hSize1, hSize2, hLifetime, branching, allAvalanches] = aVa_mainProcessing(pkd_folder, bin_w, sampling_freq, samplesNum);
    % calculate mean and standard deviation of the branching parameter
%     branchMean = mean(branching);
%     branchSTD = std(branching);
%     branchSTE = stderror(branchMean, branching);
    % preprocessing of data for fitting
    [edgesSize1, hSize1Norm] = aVa_preprocessFit(hSize1);
    [edgesSize2, hSize2Norm] = aVa_preprocessFit(hSize2);
    [edgesLifetime, hLifetimeNorm] = aVa_preprocessFit(hLifetime);
    % saving data in cell arrays
    edgesSize1All{ii,1} = edgesSize1;
    edgesSize2All{ii,1} = edgesSize2;
    edgesLifetimeAll{ii,1} = edgesLifetime;
    hSize1All{ii,1} = hSize1Norm;
    hSize2All{ii,1} = hSize2Norm;
    hLifetimeAll{ii,1} = hLifetimeNorm;
    % LINEAR BINNING
    % fitting
    [fitSize1, gofSize1, edgesFitSize1, fitEvalSize1] = aVa_fitting(edgesSize1, hSize1Norm, 0);
    [fitSize2, gofSize2, edgesFitSize2, fitEvalSize2] = aVa_fitting(edgesSize2, hSize2Norm, 0);
    [fitLifetime, gofLifetime, edgesFitLifetime, fitEvalLifetime] = aVa_fitting(edgesLifetime, hLifetimeNorm, 0);
    % create results folder
    finalString = strcat('aVa_bin',num2str(bin_w));                           % building part of the final name
    [aVaResults] = createresultfolder(aVaAnalysis, num_exp, finalString);
    cd(aVaResults); % seeks the correct directory
    % save data
    fname = [num2str(num_exp),'_aVa_bin',num2str(bin_w),'_histNotNorm.mat'];
    save(fname,'hSize1', 'hSize2', 'hLifetime')
    fname = [num2str(num_exp),'_aVa_bin',num2str(bin_w),'_histNorm.mat'];
    save(fname,'hSize1Norm', 'hSize2Norm', 'hLifetimeNorm','edgesSize1','edgesSize2','edgesLifetime')
    fname = [num2str(num_exp),'_aVa_bin',num2str(bin_w),'_fitting.mat'];
    save(fname,'fitSize1','gofSize1','edgesFitSize1','fitEvalSize1','fitSize2','gofSize2','edgesFitSize2','fitEvalSize2','fitLifetime','gofLifetime','edgesFitLifetime','fitEvalLifetime')
    fname = [num2str(num_exp),'_aVa_bin',num2str(bin_w),'_branchingParameter.mat'];
    % save(fname,'branchMean', 'branchSTD', 'branching', 'branchSTE')
    save(fname,'branching')
    fname = [num2str(num_exp),'_aVa_bin',num2str(bin_w),'_avalanches.mat'];
    save(fname,'allAvalanches')
    % create and save figures
    if(~isempty(fitSize1))
        slopeSize1 = fitSize1.b;
        rmseSize1 = gofSize1.rmse;
    else
        slopeSize1 = 0;
        rmseSize1 = 0;
    end
    if (~isempty(fitSize2))
        slopeSize2 = fitSize2.b;
        rmseSize2 = gofSize2.rmse;
    else
        slopeSize2 = 0;
        rmseSize2 = 0;
    end
    if(~isempty(fitLifetime))
        slopeLifetime = fitLifetime.b;
        rmseLifetime = gofLifetime.rmse;
    else
        slopeLifetime = 0;
        rmseLifetime = 0;
    end
    figName = [num2str(num_exp),'_aVa_FittedSize1'];
    aVa_createSaveFigure(edgesSize1,hSize1Norm,edgesFitSize1,fitEvalSize1,1,bin_w,slopeSize1,rmseSize1,aVaResults,figName);
    figName = [num2str(num_exp),'_aVa_FittedSize2'];
    aVa_createSaveFigure(edgesSize2,hSize2Norm,edgesFitSize2,fitEvalSize2,2,bin_w,slopeSize2,rmseSize2,aVaResults,figName);
    figName = [num2str(num_exp),'_aVa_FittedLifetime'];
    aVa_createSaveFigure(edgesLifetime,hLifetimeNorm,edgesFitLifetime,fitEvalLifetime,3,bin_w,slopeLifetime,rmseLifetime,aVaResults,figName);
    if flagExpBin
        % EXPONENTIAL BINNING
        % create results folder for exponential binning
        finalString = strcat('aVa_bin',num2str(bin_w),'_expBinning');                           % building part of the final name
        [aVaResultsExpBin] = createresultfolder(aVaAnalysis, num_exp, finalString);
        cd(aVaResultsExpBin); % seeks the correct directory
        % exponential binning
        [edgesSize1Rebinned, hSize1NormRebinned] = aVa_expBinning(hSize1Norm);
        [edgesSize2Rebinned, hSize2NormRebinned] = aVa_expBinning(hSize2Norm);
        [edgesLifetimeRebinned, hLifetimeNormRebinned] = aVa_expBinning(hLifetimeNorm);
        % saving data in cell arrays
        edgesSize1RebinAll{ii,1} = edgesSize1Rebinned;
        edgesSize2RebinAll{ii,1} = edgesSize2Rebinned;
        edgesLifetimeRebinAll{ii,1} = edgesLifetimeRebinned;
        hSize1RebinAll{ii,1} = hSize1NormRebinned;
        hSize2RebinAll{ii,1} = hSize2NormRebinned;
        hLifetimeRebinAll{ii,1} = hLifetimeNormRebinned;
        % fitting exponential binning
        [fitSize1Rebinned, gofSize1Rebinned, edgesFitSize1Rebinned, fitEvalSize1Rebinned] = aVa_fitting(edgesSize1Rebinned, hSize1NormRebinned, 1);
        [fitSize2Rebinned, gofSize2Rebinned, edgesFitSize2Rebinned, fitEvalSize2Rebinned] = aVa_fitting(edgesSize2Rebinned, hSize2NormRebinned, 1);
        [fitLifetimeRebinned, gofLifetimeRebinned, edgesFitLifetimeRebinned, fitEvalLifetimeRebinned] = aVa_fitting(edgesLifetimeRebinned, hLifetimeNormRebinned, 1);
        % saving data exp binning
        fname = [num2str(num_exp),'_aVa_bin',num2str(bin_w),'_expBinning_histNorm.mat'];
        save(fname,'hSize1NormRebinned', 'hSize2NormRebinned', 'hLifetimeNormRebinned','edgesSize1Rebinned','edgesSize2Rebinned','edgesLifetimeRebinned')
        fname = [num2str(num_exp),'_aVa_bin',num2str(bin_w),'_expBinning_fitting.mat'];
        save(fname,'fitSize1Rebinned','gofSize1Rebinned','edgesFitSize1Rebinned','fitEvalSize1Rebinned','fitSize2Rebinned','gofSize2Rebinned','edgesFitSize2Rebinned','fitEvalSize2Rebinned','fitLifetimeRebinned','gofLifetimeRebinned','edgesFitLifetimeRebinned','fitEvalLifetimeRebinned')
        % create and save figures exp binning
        if(~isempty(fitSize1Rebinned))
            slopeSize1Rebinned = fitSize1Rebinned.b;
            rmseSize1Rebinned = gofSize1Rebinned.rmse;
        else
            slopeSize1Rebinned = 0;
            rmseSize1Rebinned = 0;
        end
        if (~isempty(fitSize2Rebinned))
            slopeSize2Rebinned = fitSize2Rebinned.b;
            rmseSize2Rebinned = gofSize2Rebinned.rmse;
        else
            slopeSize2Rebinned = 0;
            rmseSize2Rebinned = 0;
        end
        if(~isempty(fitLifetimeRebinned))
            slopeLifetimeRebinned = fitLifetimeRebinned.b;
            rmseLifetimeRebinned = gofLifetimeRebinned.rmse;
        else
            slopeLifetimeRebinned = 0;
            rmseLifetimeRebinned = 0;
        end
        figName = [num2str(num_exp),'_aVa_expBinning_FittedSize1'];
        aVa_createSaveFigure(edgesSize1Rebinned,hSize1NormRebinned,edgesFitSize1Rebinned,fitEvalSize1Rebinned,1,bin_w,slopeSize1Rebinned,rmseSize1Rebinned,aVaResultsExpBin,figName);
        figName = [num2str(num_exp),'_aVa_expBinning_FittedSize2'];
        aVa_createSaveFigure(edgesSize2Rebinned,hSize2NormRebinned,edgesFitSize2Rebinned,fitEvalSize2Rebinned,2,bin_w,slopeSize2Rebinned,rmseSize2Rebinned,aVaResultsExpBin,figName);
        figName = [num2str(num_exp),'_aVa_expBinning_FittedLifetime'];
        aVa_createSaveFigure(edgesLifetimeRebinned,hLifetimeNormRebinned,edgesFitLifetimeRebinned,fitEvalLifetimeRebinned,3,bin_w,slopeLifetimeRebinned,rmseLifetimeRebinned,aVaResultsExpBin,figName);
    end
end
% create and save figures for all bin widths
% LINEAR BINNING
figName = [num2str(num_exp), 'AllBins_FittedSize1'];
aVa_createFigureAllBins(edgesSize1All,hSize1All,1,binWidths,aVaAnalysis,figName);
figName = [num2str(num_exp), 'AllBins_FittedSize2'];
aVa_createFigureAllBins(edgesSize2All,hSize2All,2,binWidths,aVaAnalysis,figName);
figName = [num2str(num_exp), 'AllBins_FittedLifetime'];
aVa_createFigureAllBins(edgesLifetimeAll,hLifetimeAll,3,binWidths,aVaAnalysis,figName);
if flagExpBin
    % EXPONENTIAL BINNING
    figName = [num2str(num_exp), 'AllBins_expBinning_FittedSize1'];
    aVa_createFigureAllBins(edgesSize1RebinAll,hSize1RebinAll,1,binWidths,aVaAnalysis,figName);
    figName = [num2str(num_exp), 'AllBins_expBinning_FittedSize2'];
    aVa_createFigureAllBins(edgesSize2RebinAll,hSize2RebinAll,2,binWidths,aVaAnalysis,figName);
    figName = [num2str(num_exp), 'AllBins_expBinning_FittedLifetime'];
    aVa_createFigureAllBins(edgesLifetimeRebinAll,hLifetimeRebinAll,3,binWidths,aVaAnalysis,figName);
end
cd(start_folder)