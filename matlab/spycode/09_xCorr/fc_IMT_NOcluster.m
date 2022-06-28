% MAIN_IMT_NOcluster
% by Michela Chiappalone (22 Giugno 2006, 16 Febbraio 2007)

% ------ VARIABLE DEFINITION
Cdi0_table=zeros(60,60);

all_imt   = [        12 3 5; 13 2 7; 14 1 6; 15 2 5; 16 2 4; 17 3 4; ...
             21 6 7; 22 4 6; 23 3 6; 24 1 7; 25 1 4; 26 2 3; 27 4 5; 28 4 4; ...
             31 4 8; 32 5 7; 33 5 6; 34 2 6; 35 1 3; 36 5 5; 37 5 4; 38 7 4; ...
             41 5 9; 42 6 8; 43 4 9; 44 5 8; 45 5 3; 46 4 2; 47 4 1; 48 5 2; ...
             51 8 9; 52 7 9; 53 7 8; 54 8 8; 55 8 1; 56 7 1; 57 5 1; 58 6 2; ...
             61 7 7; 62 7 6; 63 8 5; 64 11 6; 65 10 3; 66 6 3; 67 8 2; 68 7 2; ...
             71 8 6; 72 9 6; 73 10 6; 74 10 5; 75 10 4; 76 9 5; 77 8 4; 78 7 3; ...
             82 10 7; 83 11 7; 84 11 4; 85 11 3; 86 9 4; 87 7 5];

% --------------> INPUT VARIABLES
if isempty(strfind(start_folder, 'BurstEvent'))
    strfilename='_CCorr_'; % for spike train cross-correlogram
else
    strfilename= '_BurstEvent_CCorr'; % for burst event cross-correlogram
end

first=3;
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

% --------------> START COMPUTATION
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
        electrode= str2double(el);    % Electrode name in DOUBLE
        load(filename)

        [Cdi0, maxv, maxi]= computeCdi0_NOcluster(r_table, nbins, fs);
        temp_cc_max=[maxv', maxi']; % value of the peak and position [msec]
        cc_max=[cc_max;temp_cc_max];
        elpos= find(electrode==all_imt(:,1));
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
    imagesc (Cdi0_table);
    colormap hot
    colorbar
    set(gca,'ytick',(1:60), 'YTickLabel', {num2str(all_imt(:,1))},...
        'xtick',(1:60), 'XTickLabel', {num2str(all_imt(:,1))},...
        'FontSize', (5), 'XAxisLocation', 'top');
    set(gca,'TickLength', [0 0]);
    axis image
    figure(gcf)
    y=gcf;
    nome=strcat(filename(1:end-7), '_MAP.fig');
    saveas(y, nome, 'fig');
    close (y)
    clear nome y

    % Save CONNECTIVITY plot
    [h, r]= connectivitymap_IMT (all_imt, Cdi0_table, threshold);
    nome=strcat(filename(1:end-7), '_CON.fig');
    saveas(h, nome, 'fig');
    %close all
    clear nome

    cd(start_folder)
end

