% fc_IDEA_NOcluster
% by Michela Chiappalone (22 Giugno 2006, 13 Febbraio 2007)

% ------ VARIABLE DEFINITION

Cdi0_table=zeros(60,60);

all_cluster=[        12 1 7; 13 1 5; 14 3 5; 15 3 3; 16 1 4; 17 1 3; ...
             21 2 8; 22 2 7; 23 1 6; 24 2 5; 25 3 4; 26 2 3; 27 1 2; 28 2 2; ...
             31 3 7; 32 3 8; 33 1 8; 34 2 6; 35 2 4; 36 1 1; 37 2 1; 38 3 1; ...
             41 4 6; 42 3 6; 43 4 7; 44 4 8; 45 4 1; 46 3 2; 47 4 3; 48 4 2; ...
             51 5 7; 52 5 6; 53 6 7; 54 5 8; 55 5 1; 56 5 2; 57 6 3; 58 5 3; ...
             61 6 8; 62 7 8; 63 8 8; 64 7 5; 65 7 3; 66 8 1; 67 6 1; 68 6 2; ...
             71 7 7; 72 8 7; 73 7 6; 74 6 5; 75 7 4; 76 8 3; 77 7 2; 78 7 1; ...
             82 8 6; 83 8 5; 84 6 6; 85 6 4; 86 8 4; 87 8 2];

lutIDEA =  [       12 12; 13 23; 14 13; 15 16; 16 17; 17 27;       ...
            21 21; 22 22; 23 34; 24 24; 25 35; 26 26; 27 28; 28 37;...
            31 32; 32 31; 33 42; 34 14; 35 25; 36 15; 37 46; 38 38;...
            41 44; 42 43; 43 41; 44 11; 45 18; 46 47; 47 48; 48 45;...
            51 54; 52 51; 53 52; 54 81; 55 88; 56 58; 57 56; 58 55;...
            61 61; 62 53; 63 84; 64 74; 65 85; 66 57; 67 68; 68 67;...
            71 62; 72 71; 73 73; 74 64; 75 75; 76 65; 77 77; 78 78;...
            82 72; 83 82; 84 83; 85 86; 86 76; 87 87];


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

    for j=first:numcorrfiles % Cycle over the 'Cross correlation' files
        filename=corrfiles(j).name;
        tmp         = split(filename, '_');
        tmp2        = split(tmp(end), '.');
        el          = char(tmp2(1));
        electrode= str2double(el); % Electrode name in DOUBLE
        load(filename)

        [Cdi0, maxv, maxi]= computeCdi0_NOcluster(r_table, nbins, fs);
        temp_cc_max=[maxv', maxi']; % Value of the peak and position [msec]
        cc_max=[cc_max;temp_cc_max];
        elpos= find(electrode==all_cluster(:,1));
        Cdi0_table(elpos,:)=Cdi0;
    end
    cd(destfolder)
    
    % Save information on C(0)
    nome=strcat(lower(filename(2:4)), '_Cdi0.txt');
    save(nome, 'Cdi0_table', '-ASCII')
    clear nome
    nome=strcat(lower(filename(2:4)), '_CCmax.txt');
    save(nome, 'cc_max', '-ASCII')
    clear nome

    % Save MAP plot
    imagesc (Cdi0_table);
    colormap hot
    colorbar
    set(gca,'ytick',(1:60), 'YTickLabel', {num2str(all_cluster(:,1))},...
        'xtick',(1:60), 'XTickLabel', {num2str(all_cluster(:,1))},...
        'FontSize', (5), 'XAxisLocation', 'top');
    set(gca,'TickLength', [0 0]);
    axis image
    y=gcf;
    nome=strcat(filename(1:end-7), '_MAP.fig');
    saveas(y, nome, 'fig');
    close (y)
    clear nome y
    
    % Save CONNECTIVITY plot
    [h, r]= connectivitymap_NOclu (all_cluster, Cdi0_table, threshold);
    nome=strcat(filename(1:end-7), '_CON.fig');
    if ~isempty(h)
        saveas(h, nome, 'fig');
        %close all
        clear nome
    end

    cd(start_folder)
end