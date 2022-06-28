% PLOT_stimraster_single.m
% This script produces the raster plot obtained after each stimulus
% (usually 50) - 1 graph for 1 electrode - elNum graphs for 1 stimwin file

% by Michela Chiappalone (31 gennaio 2006)
% modified by Luca Leonardo Bologna (11 June 2007)
%   - in order to handle the 64 channels of MED64 Panasonic system

clear all
% Select one single stimwin file
[FileName,PathName] = uigetfile('*.mat','Select one of the PSTH stimwin files');
end_folder = uigetdir(pwd,'Select the PSTHresults folder');
elNum=64; %number of electrodes to handle
if strcmp(num2str(FileName),'0') || isempty(end_folder)
    errordlg('Selection Failed - End of Session', 'Error');
else
    % Create the end_folder that will contain the graphs
    [exp_num]=find_expnum(end_folder, '_PSTHresults');
    [end_folder]=createresultfolder(end_folder, exp_num, 'PSTH_plotstimraster');

    % -------------------- START PROCESSING
    dim= 4000; %400msec
    color='b';
    mcmea_electrodes = GlobalsParams.DEFAULT_ELECTRODES_LAYOUT;

    load (fullfile(PathName, FileName)) % stimwin_cell is loaded
    if length(stimwin_cell)==87 % for compatibility with previous versions of SpikeManager
        stimwin_cell(end+1)={[]};
    end
    for k=1:elNum
        el_index= mcmea_electrodes(k)
        stimwin_array= stimwin_cell{el_index, 1};

        if ~isempty (stimwin_array)
            [r,c]= size(stimwin_array);
            h = figure
            for j=1:r
                subplot(r,1,j, 'align')
                temp=stimwin_array(j,:)';
                spiketimes=find(temp);
                %             if ~isempty (spiketimes)
                %                 stimraster= rasterplotm (spiketimes, 0, 0.5, 0.5, color);
                %             end
                raster=bar(spiketimes, sign(spiketimes),0.001,'b'); % Raster Plot
                set(raster,'EdgeColor','b');% Lines are blue
                axis([0 dim 0 0.5]);

                set(gca,'Xcolor', 'w');
                set(gca,'Ycolor', 'w');
                set(gca,'ytick',[]);
                set(gca,'xtick',[]);
                box off;
                grid off;
                axis off; % Decide if you want to visualize the rows among each electrode
                text(-elNum, 0.25, num2str(j),'FontSize', 5, 'FontWeight', 'bold');
            end

            % SAVING PLOT INTO SEPARATE FOLDERS
            index1= findstr(FileName, '_stim');
            index2= findstr(FileName, '.mat');
            foldername=strcat('STIMraster', FileName(index1:index2-1));
            nome= strcat(foldername, '_', num2str(el_index));

            cd(end_folder)
            enddir= dir;
            numenddir= length(dir);
            if isempty(strmatch(foldername, strvcat(enddir(1:numenddir).name),'exact'))
                mkdir(foldername) % Make a new directory only if it doesn't exist
            end
            cd (foldername)
            saveas(gca, nome,'jpg'); % saveas(gca, nome,'fig');
            figure(h)
            close;
            clear temp stimwin_array spiketimes el_index index1 index2 nome c r
        end
    end

    % -------------------- END OF PROCESSING
    EndOfProcessing (end_folder,'Successfully accomplished');
end
clear all
