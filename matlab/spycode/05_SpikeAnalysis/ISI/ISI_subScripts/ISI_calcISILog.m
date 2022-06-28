% ISI_calcISILog.m
% by Valentina Pasquale, September 2008
% It computes the ISI histogram for all electrodes (and all experimental
% phases); bins are logarithmically spaced;
% ARGUMENTS:
% inputFolder: PeakDetectionMAT files folder path
% outputFolder: folder in which to save results
% paramISILogCommon: structure that contains some common parameters for the ISI
%   computation; it contains the following fields:
%       sf_Hz: sampling rate [Hz]
% paramISILogComp: structure that contains all the parameters for the ISI
%   computation; it contains the following fields:
%       nBinsxDec: number of bins per decade
%       autoSclFlag: flag for autoscaling of y-axis
%       maxY: it is empty if autoSclFlag = 1; otherwise it contains the YLim for
%           all channels
% paramISILinSav: structure that contains a series of flag for saving
%   results of ISI computation; it contains the following fields:
%       ISI8x8layoutFlag: flag for saving 8x8 plots
%       netISIFlag: flag for saving network ISI
%       allISIFlag: flag for saving all ISIs for every channel
%       ISIstatFlag: flag for saving ISI statistics
%       calcISImaxBurstFlag: flag for saving parameters for the Burst Detection
%           extracted from ISI hist
%       ISIsmoothingFlag: flag for smoothing histograms (it is automatically set to
%           1 if calcISImaxBurstFlag = 1)
%       minPeakHeight: minimum peak height
%       minPeakDist: minimum peak distance
%       diffTh: a threshold for the 1st derivative (diff output): it is
%           used to compute the ISImax in case two peaks are not found
%       ISITh: a threshold for the ISI: if there is no peak below ISITh,
%           the channel is considered not bursting
% RETURNS:
% flag: a flag for success
% errorStr: lasterror output
function [flag, errorStr] = ISI_calcISILog(inputFolder, outputFolder, paramISILogCommon, paramISILogComp, paramISILogSaving)
% % Initialize flag
% flag = 0;
% errorStr = [];
% input & output folder
PDFolder = inputFolder;
ISIFolder = outputFolder;
% -------------- START PROCESSING ------------
name_dir = dir(PDFolder);            % Present directories - name_dir is a struct
num_dir = length(name_dir);          % Number of present directories (also "." and "..")
first = 3;                           % the two elements "." and ".." are excluded
phasename = cell(1,1);               % cell array of strings containing phase names
hISI8x8layout = zeros(num_dir-first+1,1);   % array of handles for ISI8x8layout plots
hISISmooth8x8 = zeros(num_dir-first+1,1);   % array of handles for ISI8x8layout plots
hWB = waitbar(0,'ISILog computation...Please wait...','Position',[50 50 275 50]);
u = 0;
ISIThFolderName = 'ISImaxTh';
try
    mkdir(ISIFolder,ISIThFolderName);
catch
    flag = 0;
    errorStr = lasterror;
    errordlg(errorStr.message,errorStr.identifier)
end
ISIThFolder = fullfile(ISIFolder,ISIThFolderName);
for i = first:num_dir  % FOR cycle over all the directories
    u = u + 1/(num_dir-first+1);
    waitbar(u,hWB)
    current_dir = fullfile(PDFolder, name_dir(i).name);      % i-th directory - i-th experimental phase
    phasename{i-first+1} = name_dir(i).name;
    content = dir(current_dir);                       % present PeakDetection files
    num_files = length(content);         % number of present PeakDetection files
    ISIHistLogNorm = cell(1,1);          % cell array containing ISI logarithmic hist
    bins = cell(1,1);                    % cell array cont bins' series
    allISI = cell(1,1);                  % cell array cont all ISIs
    numElec = zeros(num_files-first+1,1);   % array of numbers of electrodes
    for k = first:num_files     % FOR cycle over all the PeakDetection files
        filename = fullfile(current_dir, content(k).name);
        load(filename);                                     % peak_train and artifact are loaded
        if exist('artifact','var') && ~isempty(artifact) && ~isscalar(artifact)
            cancwin = 40;
            peak_train = delartcontr(peak_train,artifact,cancwin);    % delete artifact contribution
        end
        tmp         = split(filename, '_');
        tmp2        = split(tmp(end), '.');
        electrode   = char(tmp2(1));
        numElec(k-first+1) = str2double(electrode);         % current electrode [double]
        [bins{k-first+1,1}, ISIHistLogNorm{k-first+1,1}, allISI{k-first+1,1}] = calcISILogHist(peak_train, paramISILogComp.nBinsxDec, paramISILogCommon.sf);
    end
    if paramISILogSaving.ISI8x8layoutFlag
        hISI8x8layout(i-first+1) = figure(i-first+1);
%         if ~paramISILogSaving.ISIsmoothingFlag
%             plotMultISI8x8Flag = plotMultISI8x8(hISI8x8layout(i-first+1),bins,ISIHistLogNorm,[],numElec,paramISILogComp.autoSclFlag,paramISILogComp.maxY,peaks,'log');
%         else
%             plotMultISI8x8Flag = plotMultISI8x8(hISI8x8layout(i-first+1),bins,ISIHistLogNorm,ISIHistLogNormSmoothed,numElec,paramISILogComp.autoSclFlag,paramISILogComp.maxY,peaks,'log');
%         end
        plotMultISI8x8Flag = plotMultISI8x8(hISI8x8layout(i-first+1),bins,ISIHistLogNorm,numElec,paramISILogComp.autoSclFlag,paramISILogComp.maxY,'log','b');
        if ~plotMultISI8x8Flag
            errordlg('plotMultISI8x8: Some errors have occurred! Execution terminated!', '!!Error!!', 'modal');
            return
        end
        fnameFig = fullfile(ISIFolder,strcat('ISIHistLOG_8x8layout_', phasename{i-first+1},'.fig'));
        fnameJpg = fullfile(ISIFolder,strcat('ISIHistLOG_8x8layout_', phasename{i-first+1},'.jpg'));
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
    if paramISILogSaving.ISIsmoothingFlag
        [ISIHistLogNormSmoothed] = smoothISI(ISIHistLogNorm,paramISILogSaving.ISIsmoothingMethod,...
            paramISILogSaving.ISIsmoothingSpan);
        fname = fullfile(ISIFolder,strcat('ISIHistLOG_smoothedHist_', phasename{i-first+1},'.mat'));
        try
            save(fname, 'ISIHistLogNormSmoothed','-mat')
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
        plotMultISISmooth8x8Flag = plotMultISI8x8(hISISmooth8x8(i-first+1),bins,ISIHistLogNormSmoothed,numElec,paramISILogComp.autoSclFlag,paramISILogComp.maxY,'log',[0.4 0.4 0.4]);
        if ~plotMultISISmooth8x8Flag
            errordlg('plotMultISI8x8: Some errors have occurred! Execution terminated!', '!!Error!!', 'modal');
            return
        end
        fnameFig = fullfile(ISIFolder,strcat('ISIHistLOG_smoothed8x8layout_', phasename{i-first+1},'.fig'));
        fnameJpg = fullfile(ISIFolder,strcat('ISIHistLOG_smoothed8x8layout_', phasename{i-first+1},'.jpg'));
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
    if paramISILogSaving.calcISImaxBurstFlag
        [ISImax4BurstDet, peaks, flags] = calcISImax(bins, ...
            ISIHistLogNormSmoothed, paramISILogSaving.minPeakDist, ...
            paramISILogSaving.voidParamTh, paramISILogSaving.ISITh, ...
            length(numElec));
        dirName = [phasename{i-first+1},'_ISImaxThFigures'];
        try
            mkdir(ISIFolder,dirName);
        catch
            flag = 0;
            errorStr = lasterror;
            errordlg(errorStr.message,errorStr.identifier)
            return
        end
        plotISISmoothPeaksFlag = plotISISmoothPeaks(fullfile(ISIFolder,dirName),numElec,bins,ISIHistLogNormSmoothed,ISImax4BurstDet,peaks,flags);
        if ~plotISISmoothPeaksFlag
            errordlg('plotISISmoothPeaks: Some errors have occurred! Execution terminated!', '!!Error!!', 'modal');
            return
        end
        fname1 = fullfile(ISIThFolder,strcat('ISIHistLOG_ISImaxTh_', phasename{i-first+1},'.mat'));
        fname2 = fullfile(ISIThFolder,strcat('ISIHistLOG_ISImaxTh_', phasename{i-first+1},'.txt'));
        ISImax = [numElec, ISImax4BurstDet, flags];
        try
            save(fname1,'ISImax','peaks','-mat')
            save(fname2,'ISImax','-ASCII')
        catch
            flag = 0;
            errorStr = lasterror;
            errordlg(errorStr.message,errorStr.identifier)
            return
        end
    end
    if paramISILogSaving.netISIFlag
        [binsAver,ISIhistAver] = calcNetAverISI(bins, ISIHistLogNorm);
        [hNetAverISI] = plotNetAverISI(binsAver,ISIhistAver,'log');
        fnameFig = fullfile(ISIFolder,strcat('ISIHistLOG_NetworkAverageISI_', phasename{i-first+1},'.fig'));
        fnameJpg = fullfile(ISIFolder,strcat('ISIHistLOG_NetworkAverageISI_', phasename{i-first+1},'.jpg'));
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
    if paramISILogSaving.ISIstatFlag
        [ISIstat] = calcISIstat(allISI);
        ISIstat = [numElec ISIstat];
        fname1 = fullfile(ISIFolder,strcat('ISIHistLOG_ISIstat_', phasename{i-first+1},'.mat'));
        fname2 = fullfile(ISIFolder,strcat('ISIHistLOG_ISIstat_', phasename{i-first+1},'.txt'));
        try
            save(fname1,'ISIstat','-mat')
            save(fname2,'ISIstat','-ASCII')
        catch
            flag = 0;
            errorStr = lasterror;
            errordlg(errorStr.message,errorStr.identifier)
            return
        end
    end
%     cd(ISIFolder)    
    fname = fullfile(ISIFolder,strcat('ISIHistLOG_hist_', phasename{i-first+1},'.mat'));
    try
        save(fname, 'bins', 'ISIHistLogNorm', '-mat')
    catch
        flag = 0;
        errorStr = lasterror;
        errordlg(errorStr.message,errorStr.identifier)
        return
    end
    if paramISILogSaving.allISIFlag
        fname = fullfile(ISIFolder,strcat('ISIHistLOG_allISI_', phasename{i-first+1},'.mat'));
        try
            save(fname, 'allISI','-mat')
        catch
            flag = 0;
            errorStr = lasterror;
            errordlg(errorStr.message,errorStr.identifier)
            return
        end
    end
%     cd(PDFolder)
end
% cd(ISIFolder)
fname = fullfile(ISIFolder,'ISIHistLOG_param.mat');
try
    save(fname,'paramISILogCommon','paramISILogComp', 'paramISILogSaving','-mat')
catch
    flag = 0;
    errorStr = lasterror;
    errordlg(errorStr.message,errorStr.identifier)
    return
end
flag = 1;
errorStr = [];
close(hWB)
% close all