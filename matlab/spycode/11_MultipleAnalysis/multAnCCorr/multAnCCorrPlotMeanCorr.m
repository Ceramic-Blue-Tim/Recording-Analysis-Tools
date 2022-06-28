function [ outputMessage ] = multAnCCorrPlotMeanCorr(start_folder, fs )
%MULTANCCORRPLOTMEANCORR Summary of this function goes here
%   Detailed explanation goes here

outputMessage='';
window = [];
binsize = [];
destfolder = [];
cd(start_folder);
cd ..
end_folder=pwd;

% --------------> INPUT VARIABLES
if isempty(strfind(start_folder, 'BurstEvent'))
    strfilename='_CCorr_'; % for spike train cross-correlogram
else
    strfilename= '_BurstEvent_CCorr'; % for burst event cross-correlogram
end
[exp_num]=find_expnum(start_folder, strfilename);
winindex1=strfind(start_folder, '-');
winindex2=strfind(start_folder, 'msec');
win=str2double(start_folder(winindex1(end)+1:winindex2(end)-1));
binindex=strfind(start_folder, '_');
bin=str2double(start_folder(binindex(end)+1:winindex1(end)-1));
window = win/1000*fs;
binsize = bin/1000*fs;
% bin     [msec]
% binsize [number of samples]
% win     [msec]
% window  [number of samples]

% --------------> RESULT FOLDER MANAGEMENT
if isempty(strfind(start_folder, 'BurstEvent'))
    [destfolder]= uigetfoldername(exp_num, bin, win, end_folder, ' - MeanPlot');
else
    % for burst event cross-correlogram
    [destfolder]= uigetfoldernameBE(exp_num, bin, win, end_folder, ' - MeanPlot');
end
cd (start_folder);
plotmeancorrelogram (window, binsize, fs, start_folder, destfolder);
end