% ISI_calcISILin.m
% by Valentina Pasquale, March-April 2008
% It computes the ISI histogram for all electrodes (and all experimental
% phases) of a selected experiment; the bins of the histogram are linearly spaced.
% INPUTS:
% inputFolder: Peak Detection files folder path
% outputFolder: folder in which to save results
% paramISILinCommon: structure that contains common parameters for the ISI
%   computation; contains the following fields:
%       sf_Hz: sampling rate
% paramISILinComp: structure that contains all the parameters for the ISI
%   computation; contains the following fields:
%       maxWin_s: maximum windom (x-scale) [s]
%       binSize_ms: bin size [ms]
%       autoSclFlag: flag for autoscaling of y-axis
%       maxY: empty if autoSclFlag = 1; otherwise it contains the YLim (the same for
%           all channels)
% paramISILinSav: structure that contains a series of flag for saving
%   results of ISI computation; contains the following fields:
%       ISI8x8layoutFlag: flag for saving 8x8 plots
%       netISIFlag: flag for saving network ISI
%       allISIFlag: flag for saving all ISIs for every channel
%       ISIstatFlag: flag for saving ISI statistics
%       ISIsmoothingFlag: flag for saving ISI histograms smoothed according to the
%           moving average algorithm (i.e. LPF), window = 3
% OUTPUTS:
% flag: a flag for successfully accomplished computation and saving
% errorStr: lasterror output
function [flag, errorStr] = ISI_calcISILin(inputFolder, outputFolder, paramISILinCommon, ...
    paramISILinComp, paramISILinSav)
PDFolder = inputFolder;
ISIFolder = outputFolder;
% ------------ COMPUTATION -------------
name_dir = dir(PDFolder);            % Present directories - name_dir is a struct
num_dir = length(name_dir);          % Number of present directories (also "." and "..")
first = 3;                           % the two elements "." and ".." are excluded
phasename = cell(1,1);               % cell array of strings containing phase names
hISI8x8layout = zeros(num_dir-first+1,1);   % array of handles for ISI8x8layout plots
hISISmooth8x8 = zeros(num_dir-first+1,1);   % array of handles for ISI8x8layout plots
hWB = waitbar(0,'ISILin computation...Please wait...','Position',[50 50 275 50]);
u = 0;
for i = first:num_dir  % FOR cycle over all the directories
    u = u + 1/(num_dir-first+1);
    waitbar(u,hWB)
    current_dir = fullfile(PDFolder, name_dir(i).name);      % i-th directory - i-th experimental phase
    phasename{i-first+1} = name_dir(i).name;
    content = dir(current_dir);             % present PeakDetection files
    num_files = length(content);         % number of present PeakDetection files
    ISIHistLinNorm = cell(1,1);          % cell array containing ISI hist
    bins = cell(1,1);                    % cell array cont bins' series
    allISI = cell(1,1);                  % cell array cont all ISIs
    numElec = zeros(num_files-first+1,1);   % array of numbers of electrodes
    for k = first:num_files     % FOR cycle over all the PeakDetection files
        filename = fullfile(current_dir, content(k).name);
        load(filename);                                     % peak_train and artefact are loaded
        if exist('artifact','var') && ~isempty(artifact) && ~isscalar(artifact)
            cancwin = 4;
            peak_train = delartcontr(peak_train,artifact,cancwin);    % delete artifact contribution
        end
        tmp         = split(filename, '_');
        tmp2        = split(tmp(end), '.');
        electrode   = char(tmp2(1));
        numElec(k-first+1) = str2double(electrode);         % current electrode [double]
        [bins{k-first+1,1}, ISIHistLinNorm{k-first+1,1}, ...
            allISI{k-first+1,1}] = calcISILinHist(peak_train, ...
            paramISILinComp.maxWin_s, paramISILinComp.binSize_ms, ...
            paramISILinCommon.sf);
    end
    if paramISILinSav.ISI8x8layoutFlag
        hISI8x8layout(i-first+1) = figure(i-first+1);
%         if ~paramISILinSav.ISIsmoothingFlag
%             plotMultISI8x8Flag = plotMultISI8x8(hISI8x8layout(i-first+1),bins,ISIHistLinNorm,[],numElec,paramISILinComp.autoSclFlag,paramISILinComp.maxY,[],'lin');
%         else
%             plotMultISI8x8Flag = plotMultISI8x8(hISI8x8layout(i-first+1),bins,ISIHistLinNorm,ISIHistLinNormSmoothed,numElec,paramISILinComp.autoSclFlag,paramISILinComp.maxY,[],'lin');
%         end
        plotMultISI8x8Flag = plotMultISI8x8(hISI8x8layout(i-first+1),bins,ISIHistLinNorm,numElec,paramISILinComp.autoSclFlag,paramISILinComp.maxY,'lin','b-');
        if ~plotMultISI8x8Flag
            errordlg('plotMultISI8x8: Some errors have occurred! Execution terminated!', '!!Error!!', 'modal');
            return
        end
        fnameFig = fullfile(ISIFolder,strcat('ISIHistLIN_8x8layout_', phasename{i-first+1},'.fig'));
        fnameJpg = fullfile(ISIFolder,strcat('ISIHistLIN_8x8layout_', phasename{i-first+1},'.jpg'));
        try
            saveas(hISI8x8layout(i-first+1),fnameJpg,'jpg');
            saveas(hISI8x8layout(i-first+1),fnameFig,'fig');
        catch
            flag = 0;
            errorStr = lasterror;
            errordlg(errorStr.message,errorStr.identifier)
            return
        end
        close(hISI8x8layout(i-first+1))
    end
    if paramISILinSav.ISIsmoothingFlag
        [ISIHistLinNormSmoothed] = smoothISI(ISIHistLinNorm,paramISILinSav.ISIsmoothingMethod,...
            paramISILinSav.ISIsmoothingSpan);
        fname = fullfile(ISIFolder,strcat('ISIHistLIN_smoothedHist_', phasename{i-first+1},'.mat'));
        try
            save(fname, 'ISIHistLinNormSmoothed','-mat')
        catch
            flag = 0;
            errorStr = lasterror;
            errordlg(errorStr.message,errorStr.identifier)
            return
        end
        hISISmooth8x8(i-first+1) = figure(i-first+1);
%         if ~paramISILinSav.ISIsmoothingFlag
%             plotMultISI8x8Flag = plotMultISI8x8(hISI8x8layout(i-first+1),bins,ISIHistLinNorm,[],numElec,paramISILinComp.autoSclFlag,paramISILinComp.maxY,[],'lin');
%         else
%             plotMultISI8x8Flag = plotMultISI8x8(hISI8x8layout(i-first+1),bins,ISIHistLinNorm,ISIHistLinNormSmoothed,numElec,paramISILinComp.autoSclFlag,paramISILinComp.maxY,[],'lin');
%         end
        plotMultISISmooth8x8Flag = plotMultISI8x8(hISISmooth8x8(i-first+1),bins,ISIHistLinNormSmoothed,numElec,paramISILinComp.autoSclFlag,paramISILinComp.maxY,'lin','r-');
        if ~plotMultISISmooth8x8Flag
            errordlg('plotMultISI8x8: Some errors have occurred! Execution terminated!', '!!Error!!', 'modal');
            return
        end
        fnameFig = fullfile(ISIFolder,strcat('ISIHistLIN_smoothed8x8layout_', phasename{i-first+1},'.fig'));
        fnameJpg = fullfile(ISIFolder,strcat('ISIHistLIN_smoothed8x8layout_', phasename{i-first+1},'.jpg'));
        try
            saveas(hISISmooth8x8(i-first+1),fnameJpg,'jpg');
            saveas(hISISmooth8x8(i-first+1),fnameFig,'fig');
        catch
            flag = 0;
            errorStr = lasterror;
            errordlg(errorStr.message,errorStr.identifier)
            return
        end
        close(hISISmooth8x8(i-first+1))        
    end
    if paramISILinSav.netISIFlag
        [binsAver,ISIhistAver] = calcNetAverISI(bins, ISIHistLinNorm);
        [hNetAverISI] = plotNetAverISI(binsAver,ISIhistAver,'lin');
        fnameFig = fullfile(ISIFolder,strcat('ISIHistLIN_NetworkAverageISI_', phasename{i-first+1},'.fig'));
        fnameJpg = fullfile(ISIFolder,strcat('ISIHistLIN_NetworkAverageISI_', phasename{i-first+1},'.jpg'));
        try
            saveas(hNetAverISI,fnameJpg,'jpg')
            saveas(hNetAverISI,fnameFig,'fig')
        catch
            flag = 0;
            errorStr = lasterror;
            errordlg(errorStr.message,errorStr.identifier)
            return
        end
        close(hNetAverISI)
    end
    if paramISILinSav.ISIstatFlag
        [ISIstat] = calcISIstat(allISI);
        ISIstat = [numElec ISIstat];
        fnameTxt = fullfile(ISIFolder,strcat('ISIHistLIN_ISIstat_', phasename{i-first+1},'.txt'));
        fnameMat = fullfile(ISIFolder,strcat('ISIHistLIN_ISIstat_', phasename{i-first+1},'.mat'));
        try
            save(fnameMat,'ISIstat','-mat')
            save(fnameTxt,'ISIstat','-ASCII')
        catch
            flag = 0;
            errorStr = lasterror;
            errordlg(errorStr.message,errorStr.identifier)
            return
        end
    end
    fname = fullfile(ISIFolder,strcat('ISIHistLIN_hist_', phasename{i-first+1},'.mat'));
    try
        save(fname, 'bins', 'ISIHistLinNorm','-mat')
    catch
        flag = 0;
        errorStr = lasterror;
        errordlg(errorStr.message,errorStr.identifier)
        return
    end
    if paramISILinSav.allISIFlag
        fname = fullfile(ISIFolder,strcat('ISIHistLIN_allISI_', phasename{i-first+1},'.mat'));
        try
            save(fname, 'allISI','-mat')
        catch
            flag = 0;
            errorStr = lasterror;
            errordlg(errorStr.message,errorStr.identifier)
            return
        end
    end
end
fname = fullfile(ISIFolder,'ISIHistLIN_param.mat');
try
    save(fname,'paramISILinCommon','paramISILinComp','paramISILinSav','-mat')
catch
    flag = 0;
    errorStr = lasterror;
    errordlg(errorStr.message,errorStr.identifier)
    return
end
flag = 1;
errorStr = [];
close(hWB)
%close all