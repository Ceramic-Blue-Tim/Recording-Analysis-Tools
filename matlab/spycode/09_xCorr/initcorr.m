function [window, binsize, fs, start_folder, destfolder,cancelFlag]=initcorr(plotflag)
% by Michela Chiappalone (25 Maggio 2006)

fs=GlobalsParams.DEFAULT_FS; % I need to pass this variable from the interface - TO BE DONE LATER
cancelFlag = 0;
window = [];
binsize = [];
start_folder = [];
destfolder = [];

start_folder = uigetdir(pwd,'Select the Cross-Correlograms folder');
if  strcmp(num2str(start_folder),'0')
    display ('End Of Function') 
    cancelFlag = 1;    
else
    cd(start_folder)
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
        % for spike train cross-correlogram
        switch plotflag
            case {1}
                [destfolder]= uigetfoldername(exp_num, bin, win, end_folder, ' - 3DPlot');
            case {2}
                [destfolder]= uigetfoldername(exp_num, bin, win, end_folder, ' - MeanPlot');
        end
    else
        % for burst event cross-correlogram
        switch plotflag
            case {1}
                [destfolder]= uigetfoldernameBE(exp_num, bin, win, end_folder, ' - 3DPlot');
            case {2}
                [destfolder]= uigetfoldernameBE(exp_num, bin, win, end_folder, ' - MeanPlot');
        end
    end

    cd(start_folder)
end

