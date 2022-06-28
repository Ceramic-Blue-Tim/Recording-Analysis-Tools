% MAIN_MEA
% by Michela Chiappalone (22 Giugno 2006, 13 Febbraio 2007)

% ------ VARIABLE DEFINITION
% Cdi0_table=zeros(60,60);
Cdi0_table=zeros(64,64);
first=3;

% --------------> INPUT VARIABLES
if isempty(strfind(start_folder, 'BurstEvent'))
    strfilename='_CCorr_'; % for spike train cross-correlogram
else
    strfilename= '_BurstEvent_CCorr'; % for burst event cross-correlogram
end

[exp_num]=find_expnum(start_folder, strfilename);
winindex1=strfind(start_folder, '-');
winindex2=strfind(start_folder, 'msec');
win=str2double(start_folder(winindex1(end)+1:winindex2(end)-1)); % win [msec]
binindex=strfind(start_folder, '_');
bin=str2double(start_folder(binindex(end)+1:winindex1(end)-1)); % bin [msec]
window = win/1000*fs;  % window  [number of samples]
binsize = bin/1000*fs; % binsize [number of samples]
clear strfilename winindex1 winindex2 binindex
cc_max=[];

% --------------> RESULT FOLDER MANAGEMENT
if isempty(strfind(start_folder, 'BurstEvent'))
    [destfolder]= uigetfoldername(exp_num, bin, win, end_folder, '-Analysis');   % spike train
else
    [destfolder]= uigetfoldernameBE(exp_num, bin, win, end_folder, '-Analysis'); % burst event
end
cd(start_folder)

corrfolders=dir;
numcorrfolders=length(dir);
exphase= numcorrfolders-first+1;

for i=3:numcorrfolders   % Cycle over the 'Cross correlation' folders
    exphase= exphase+1;
    currentcorrfolder=corrfolders(i).name;
    cd(currentcorrfolder)
    currentcorrfolder=pwd;
    corrfiles=dir;
    numcorrfiles=length(dir);

    for j=3:numcorrfiles % Cycle over the 'Cross correlation' files
        filename=corrfiles(j).name;
        tmp         = split(filename, '_');
        tmp2        = split(tmp(end), '.');
        el          = char(tmp2(1));
        electrode= str2double(el); % Electrode name in DOUBLE
        load(filename)
        if length(r_table)==87 %added for compatibility with previous versions of SM
            r_table(end+1)=[];
        end

        [Cdi0, maxv, maxi]= computeCdi0_mcsmea(r_table, nbins, fs);
        temp_cc_max=[maxv', maxi']; % Value of the peak and position [msec]
        cc_max=[cc_max;temp_cc_max];
        elpos=find(electrode==mcmea_electrodes(:,1));
        Cdi0_table(elpos,:)=Cdi0;
    end
    cd(destfolder)

    % Save information on C(0)
    nome=strcat(filename(1:end-7), '_Cdi0.txt');
    save(nome, 'Cdi0_table', '-ASCII')
    clear nome
    nome=strcat(filename(1:end-7), '_CCmax.txt');
    save(nome, 'cc_max', '-ASCII')
    clear nome

    % Save MAP plot
    figure
    imagesc (Cdi0_table);
    colormap hot
    colorbar
    set(gca,'ytick',(1:64),'YTickLabel',{num2str(mcmea_electrodes)},...
        'xtick',(1:64),'XTickLabel',{num2str(mcmea_electrodes)},...
        'FontSize', (5), 'XAxisLocation', 'top');
%     set(gca,'ytick',(1:60),'YTickLabel',{num2str(mcmea_electrodes)},...
%         'xtick',(1:60),'XTickLabel',{num2str(mcmea_electrodes)},...
%         'FontSize', (5), 'XAxisLocation', 'top');
    set(gca,'TickLength', [0 0]);
    axis image
    figure(gcf)
    y=gcf;
    nome=strcat(filename(1:end-7), '_MAP.fig');
    saveas(y, nome, 'fig');
    close (y)
    clear nome y

    % Save CONNECTIVITY plot
    [h, r]= connectivitymap_mea (mcmea_electrodes, Cdi0_table, threshold);
    nome=strcat(filename(1:end-7), '_CON.fig');
    saveas(h, nome, 'fig');
    %close all
    clear nome
    cd(start_folder)
end