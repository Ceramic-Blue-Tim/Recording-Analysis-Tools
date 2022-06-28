% PLOT_MULTIPLE_PSTH.m
% Multiple plot for PSTH files CHECK ALWAYS!!!! It must be changed
% To be modified: maximum of the PSTH plot (not known a priori) ----

% by Michela Chiappalone (31 gennaio 2006)
% modified by Noriaki (9 giugno 2006)
% modified by Luca Leonardo Bologna (11 June 2007)
%   - in order to handle the 64 channels of MED64 Panasonic system

clr
% Select the source and target folder
[start_folder]= selectfolder('Select the source folder that contains the PSTH files'); %The foldername contains the binsize
if strcmp(num2str(start_folder),'0')
    errordlg('Selection Failed - End of Session', 'Error');
    return
end
end_folder = uigetdir(pwd,'Select the PSTHresults folder');
elNum=64;

% Create the end_folder that will contain the multiple plots for the PSTH
[exp_num]=find_expnum(start_folder, '_PSTHfiles');
[end_folder]=createresultfolder(end_folder, exp_num, 'PSTH_plotmultiple');

% --------------- USER information
prompt  = {'Number of test stimulus session:', 'X-axis Lim(msec)'};         
title   = 'Plot multiple PSTH settings';
lines   = 1;
def     = {'1', '400'};
Ianswer = inputdlg(prompt,title,lines,def);

if isempty (Ianswer)
    errordlg('Selection Failed - End of Session', 'Error');
    return
end
num_stimel= str2num(Ianswer{1,1});    % Number of test stimulus session
psthend=  str2double(Ianswer{2,1});   % Timeframe of the PSTH plot (X-axis)
if  isempty(num_stimel)
    display ('End Of Function')
    return
end
clear title prompt lines def

mcmea_electrodes = GlobalsParams.DEFAULT_ELECTRODES_LAYOUT;

% --------------- Property of the PLOT
binindex1=strfind(start_folder, 'bin');
binindex2=strfind(start_folder, '-');
binsize=str2num(start_folder(binindex1+3:binindex2(end)-1));
timeframeindex=strfind(start_folder, 'msec');
timeframe= str2num(start_folder(binindex2(end)+1:timeframeindex-1));
x=binsize*[1:timeframe/binsize];

coll = ['k','r','b','g', 'y']; % Colors of multiple plot
style=cell(4,1); % Useful if we want to change the style
style{1,1}='-';  % style{1,1}=':';
style{2,1}='-';  % style{2,1}='-';
style{3,1}='-';  % style{3,1}='--';
style{4,1}='-';
style{5,1}='-';
flag=0;

% -------------- START PROCESSING ------------
cd (start_folder)
name_dir=dir;
name_dir_cell=struct2cell(name_dir);
name_dir_cell=name_dir_cell(1,3:length(name_dir_cell(1,:)))'; % Only names of the directories - cell array

% Save in the array 'stimoli' the names of the stimulating electrodes
for i=1:fix(length(name_dir_cell)/num_stimel)            % In the case of tetanus experiment, this number is 3.
    stimoli(i)=str2num(name_dir_cell{i}(end-1:end));
end
%
for k=1:length(stimoli)
    stimel= stimoli(k);                % name of the stimulating electrodes - double
    for i = 1:elNum                      % start cycling on the directories
        figure
        electrode=mcmea_electrodes(i); % name of the considered electrode - double
        [index]=findfolder(name_dir_cell, stimel);
        for j=1:length(index)
            folder_path= strcat (start_folder, filesep, name_dir_cell{index(j)});
            filename= strcat(name_dir_cell{index(j)}, '_', num2str(electrode), '.mat');
            if exist(fullfile(folder_path, filename))
                flag=1;
                load (fullfile(folder_path, filename))
                y=plot(x, psthcnt, 'LineStyle', style{j,1}, 'col', coll(j), 'LineWidth', 2);
                hold on
            end
        end
        if (flag==1) % Only if a figure is produced
            axis ([0 psthend 0 binsize/2]) % Usually the Peak Detection window is 2 - to be modified!!!
            titolo=strcat('PSTH stim', num2str(stimel), ' ELECTRODE ', num2str(electrode));
            title(titolo);
            xlabel('TIME RELATIVE TO STIMULUS (msec)');
            ylabel('NUMBER OF EVOKED SPIKES');
            if (num_stimel>1)
                legend ('PRE TETANUS', 'POST TETANUS')
            end
            % legend ('pre', 'post 1', 'post 2', 'post 3')
            nome= strcat('cumPSTH_stim', num2str(stimel), '_', num2str(electrode));
            cd(end_folder)
            saveas(y,nome,'jpg');
            cd (start_folder)
        end
        close();
        %close all;
        flag=0;
    end
end

EndOfProcessing (start_folder, 'Successfully accomplished');

clear all
