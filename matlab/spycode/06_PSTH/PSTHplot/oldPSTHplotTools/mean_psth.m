% ANALISI DEI FILES DEL PSTH
% Funzione per calcolare il PSTH medio, dato il sito di stimolazione
% 
% Questa versione prevede file di partenza organizzati in cartelle

clear

start_dir = pwd; % � la cartella contenente gli algoritmi di elaborazione: si parte da qui
start_folder = uigetdir(pwd,'Select the source folder that contains the PSTH files');
end_folder1 = uigetdir(pwd,'Select the final folder that will contain the results');    

if ~(strcmp(start_dir, start_folder))    % se la cartella che contiene i dati � diversa dalla attuale, spostati
    cd (start_folder)                    % sono nella cartella che contiene le cartella di dati
end

ora=pwd;
name_dir=dir;                            % guarda quali directory sono presenti e si crea la struttura name_dr
num_dir=length (name_dir);               % num_dir � il numero di directory presenti, considera anche . e ..

% Ricordati che potrebbero esserci anche le cartelle del/dei basali!!
first=3; % non considero ., ..

for i = first:num_dir                    % inizio a ciclare sulle directory        
    current_dir = name_dir(i).name;       % prima directory che contiene i files PKD (ne visualizzo il nome)
    foldername=current_dir;
    len_dir = length(name_dir(i).name);   
    cd (current_dir);                    % mi sposto dentro la prima directory, che diventa quella corrente
    current_dir=pwd;
    
    %  -------------------------------------------    
    % |  ----------- CALCOLO DELL'AREA ---------    | 
    %  -------------------------------------------
    content=dir;
    num_files= length(content);
    num_psth=0;
    mean_psth= zeros (200,1); % alloco un vettore che conterr� i mfr della fase corrente
    for k=3:num_files
        filename = content(k).name;                
        if ~isempty(strfind(filename,'.mat')) % se ho un file.mat lo considero, altrimenti no            
            load (filename); % Qui carico il vettore della PSTH 'psthcnt'
            s = filename(1:(length(filename)-4)); % This is the name of the file without the ".mat"
            cuthere = findstr(s, '_');
            nome = s(cuthere(1)+1:length(s))  % Questo � il nome del file originale, senza il "psth_"
            clear cuthere s filename          % Libero la memoria dalle variabili inutili   
            electrode= nome(length(nome)-1:length(nome));  % nome dell'elettrodo considerato - stinga

            num_psth=num_psth+1;
            mean_psth=mean_psth+psthcnt; % Sommo i PSTHs            
        end

    end
    mean_psth=mean_psth/num_psth;
    stimel=foldername(length(foldername)-1:length(foldername));
    
    % salvare la tabella della mfr per questa fase
    cd (end_folder1)
%     nome= strcat('meanPSTH_', foldername)
%     save (nome, 'mean_psth')
    
    x=3*[1:200];
    % y=bar(x, mean_psth)
    y=plot(x, mean_psth, 'LineWidth', 1.5);
    axis ([1 400 0 1])
    % titolo=strcat('Mean PSTH from stimulating electrode ', stimel)
    % title(titolo);
    xlabel('Time (msec)');
    ylabel('Probability of firing');
    saveas(y,nome,'jpg');
    saveas(y,nome,'fig');
    close all;

    cd(ora);
end

% -------------------------- END OF PROCESSING -----------------------------------

cd (start_dir)
clear
display ('End Of Session')
