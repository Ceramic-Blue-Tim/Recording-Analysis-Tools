% PLOT_multipleISI_8x8grid.m
% by Michela Chiappalone (3 marzo 2006, 13 aprile 2006)
% modified by Luca Leonardo Bologna 04 June 2007
%   - changed the code in order to be able to manage 64 channels

clr
% Select the source and target folder
[start_folder]= selectfolder('Select the source folder that contains the PeakDetectionMAT files'); %The foldername contains the binsize
if strcmp(num2str(start_folder),'0')
    errordlg('Selection Failed - End of Session', 'Error');
    return
end

% --------------- USER information
 [bin_samp, max_x, ylim, fs, cancelFlag]= uigetISIinfo;
% bin_samp [sample]
% max_x [sec]

if cancelFlag
    errordlg('Selection Failed - End of Session', 'Error');
    return
end

% Create the end_folder that will contain the 8x8plots of the ISI histograms
[exp_num]=find_expnum(start_folder, '_PeakDetection');
[SpikeAnalysis]=createSpikeAnalysisfolder(start_folder, exp_num);
folderstring=strcat('ISIplot8x8_', num2str(max_x*1000), 'msec-', num2str(ylim));
[end_folder]=createresultfolder(SpikeAnalysis, exp_num, folderstring);
clear folderstring

% --------------- MEA variables
lookuptable= [  11  1; 21  2; 31  3; 41  4; 51  5; 61  6; 71  7; 81  8; ...
                12  9; 22 10; 32 11; 42 12; 52 13; 62 14; 72 15; 82 16; ...
                13 17; 23 18; 33 19; 43 20; 53 21; 63 22; 73 23; 83 24; ...
                14 25; 24 26; 34 27; 44 28; 54 29; 64 30; 74 31; 84 32; ...
                15 33; 25 34; 35 35; 45 36; 55 37; 65 38; 75 39; 85 40; ...
                16 41; 26 42; 36 43; 46 44; 56 45; 66 46; 76 47; 86 48; ...
                17 49; 27 50; 37 51; 47 52; 57 53; 67 54; 77 55; 87 56; ...
                18 57; 28 58; 38 59; 48 60; 58 61; 68 62; 78 63; 88 64];
 mcmea_electrodes = GlobalsParams.DEFAULT_ELECTRODES_LAYOUT;


% -------------- START PROCESSING ------------
cd (start_folder)  % Go to the PeakDetectionMAT folder
name_dir=dir;                      % Present directories - name_dir is a struct
num_dir=length (name_dir);         % Number of present directories (also "." and "..")
first=3;                           % the two elements "." and ".." are excluded
for i = first:num_dir  % FOR cycle over all the directories
    current_dir = name_dir(i).name;      % i-th directory - i-th experimental phase
    phasename=current_dir;

    cd (current_dir);                    % enter the i-th directory
    current_dir=pwd;
    content=dir;                         % present PeakDetection files
    num_files= length(content);          % number of present PeakDetection files

    for k=3:num_files  % FOR cycle over all the PeakDetection files
        filename = content(k).name;
        load (filename);                  % peak_train and artifact are loaded
        tmp         = split(filename, '_');
        tmp2        = split(tmp(end), '.');
        electrode   = char(tmp2(1));
        el= str2num(electrode);           % current electrode [double]

        graph_pos= lookuptable(find(lookuptable(:,GlobalsParams.DEFAULT_LUT_SEL)==el),2);   % 2 for MED64
        subplot(8,8,graph_pos)
        [bins,n_norm,max_y,m,s] = f_single_ISIh_Michela(peak_train, fs, max_x, bin_samp);
        mbins=1000*bins; % mbins[msec]
        y=plot(mbins, n_norm , 'LineStyle', '-', 'col', 'b', 'LineWidth', 2);
        axis ([0 (max_x*1000) 0 ylim])
        hold on
        box off
        set(gca,'ytick',[]);
        set(gca,'xtick',[]);
    end

    nome = strcat('cumISI_8x8grid_', phasename);
    cd(end_folder)
    saveas(y,nome,'jpg');
    % saveas(y,nome,'fig');
    save(nome, 'n_norm', 'mbins')
    %close all;
    cd (start_folder)
end

EndOfProcessing (start_folder, 'Successfully accomplished');

clear all
