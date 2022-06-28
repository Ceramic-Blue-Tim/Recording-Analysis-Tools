% MAIN_rasterplotMAT.m
% Script for creating the rasterplot files (jpg format) from the peak
% detection files of one experiment. It allows to select specific
% electrodes and specific window of the datastream

% TO DO:
% 1 - Save JPG or FIG Files or other format...
% 3 - select a subset of electrodes

% by Michela Chiappalone (2 Febbraio 2006)

% --------- USER INPUT
[start_folder]= selectfolder('Select the PeakDetectionMAT_files folder');
if strcmp(num2str(start_folder),'0')
    errordlg('Selection Failed - End of Session', 'Error');
    return
end
[fs, starttime, endtime, startend, cancelFlag]=uigetRASTERinfo;

if cancelFlag
    errordlg('Selection Failed - End of Session', 'Error');
else
    [exp_num]=find_expnum(start_folder, '_PeakDetection');
    endname=strcat('RasterPlotMAT_', startend);

    % --------- FOLDER MANAGEMENT
    cd (start_folder);
    cd ..
    upfolder=pwd;
    [end_folder]=createresultfolder(upfolder, exp_num, endname);
    plotraster(start_folder, end_folder, fs, starttime, endtime, startend);

%     if (dispwarn==1)
%         EndOfProcessing (start_folder, 'End time longer than data length!');
%     else
        EndOfProcessing (start_folder, 'Successfully accomplished');
%     end
end
clear all
