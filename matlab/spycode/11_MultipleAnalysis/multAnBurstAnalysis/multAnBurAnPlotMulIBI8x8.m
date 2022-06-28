function [ output_args ] = multAnBurAnPlotMulIBI8x8( start_folder,binsec, max_x, ylim, fs )
% MULTANBURANPLOTMULIBI8X8 Summary of this function goes here
%   Detailed explanation goes here
% Created by Luca Leonardo Bologna 25 February
%  Modified by Luca Leonardo Bologna (10 June 2007) in order to handle the
%  64 channels of MED64 panasonic

% --------------- USER information
output_args='';
% Create the end_folder that will contain the 8x8plots of the ISI histograms
[exp_num]=find_expnum(start_folder, '_BurstDetectionFiles'); % Experiment number
cd (start_folder);
cd ..
cd ..
exp_folder=pwd;
[end_folder]=createresultfolder(exp_folder, exp_num, 'BurstAnalysis');
[end_folder1]=createresultfolder(end_folder, exp_num, 'MultipleIBI_8x8');
clear folderstring

% --------------- MEA variables
lookuptable= [  
    11  1; 21  2; 31  3; 41  4; 51  5; 61  6; 71  7; 81  8; ...
    12  9; 22 10; 32 11; 42 12; 52 13; 62 14; 72 15; 82 16; ...
    13 17; 23 18; 33 19; 43 20; 53 21; 63 22; 73 23; 83 24; ...
    14 25; 24 26; 34 27; 44 28; 54 29; 64 30; 74 31; 84 32; ...
    15 33; 25 34; 35 35; 45 36; 55 37; 65 38; 75 39; 85 40; ...
    16 41; 26 42; 36 43; 46 44; 56 45; 66 46; 76 47; 86 48; ...
    17 49; 27 50; 37 51; 47 52; 57 53; 67 54; 77 55; 87 56; ...
    18 57; 28 58; 38 59; 48 60; 58 61; 68 62; 78 63; 88 64];
mcmea_electrodes = GlobalsParams.DEFAULT_ELECTRODES_LAYOUT;
chNum=64;
% -------------- START PROCESSING ------------
cd (start_folder)  % Go to the PeakDetectionMAT folder
content=dir;                         % present PeakDetection files
num_files= length(content);          % number of present PeakDetection files

for k=3:num_files  % FOR cycle over all the PeakDetection files
    filename = content(k).name;
    load (filename);                  % peak_train and artifact are loaded
  
    for i=1:chNum
        IBIarray=[];
        el=mcmea_electrodes(i);
        temp=burst_detection_cell{el,1};
        [r,c]=size(temp);
        if (r>=3)
            IBIarray=[burst_detection_cell{el,1}(1:end-2,5)];
        end
        [bins,n_norm,max_y] = f_single_IBIh_Michela(IBIarray, fs, max_x, binsec);

        graph_pos= lookuptable(find(lookuptable(:,GlobalsParams.DEFAULT_LUT_SEL)==el),2);
        subplot(8,8,graph_pos)
        y=bar(bins, n_norm, 1, 'r' );
        axis ([0 max_x 0 ylim])
        hold on
        box off
        set(gca,'ytick',[]);
        set(gca,'xtick',[]);
    end
    
    nome= strcat('cumIBI_8x8grid', filename(16:end-4));
    cd(end_folder1)
    saveas(y,nome,'jpg');  % saveas(y,nome,'fig');
    %close all;
    cd (start_folder)
end