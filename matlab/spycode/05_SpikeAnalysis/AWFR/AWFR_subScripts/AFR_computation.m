function AFR_computation(start_folder, bin_s, mfr_thresh, cancwin, fs)

% Function for calculating the AFR
% by Matteo Macr�, modified by M. Chiappalone (May 2010)


% ---- INPUT From user
[exp_num]       = find_expnum(start_folder, '_PeakDetection');
[SpikeAnalysis] = createSpikeAnalysisfolder (start_folder, exp_num);
finalstring     = strcat('AFR - thresh', num2str(mfr_thresh),' - bin',num2str(bin_s));
[end_folder]    = createresultfolder(SpikeAnalysis, exp_num, finalstring);

% ----- VARIABLES
first     = 3;
elNum     = 60; % this must be updated in a later version
ifr_table = [];
binsample = bin_s*fs;            % bin [# of samples]
cancwinsample = cancwin/1000*fs; % blanking window [# of samples]
mcmea_electrodes = GlobalsParams.DEFAULT_ELECTRODES_LAYOUT;

% ------------------------------------------------ START PROCESSING
w = waitbar(0, strcat('AFR(t) computation - Please wait...',num2str(exp_num)));
wtbr = 0;
if (bin_s >= 1)
    binindicator = strcat(num2str(bin_s), 'sec');
else
    binindicator = strcat(num2str(bin), 'msec');
end
cd(start_folder)         % Go to the PeakDetectionMAT folder
name_dir = dir;                            % guarda quali directory sono presenti e si crea la struttura name_dr
num_dir = length (name_dir);               % num_dir � il numero di directory presenti, considera anche . e ..
ifr_allPhases = [];
phaseIdx = 1:1:(num_dir-first+1);
for i = first:num_dir                    % inizio a ciclare sulle directory
    wtbr = wtbr+1;
    waitbar(wtbr/num_dir) % WAITBAR TO CHECK
    current_dir = name_dir(i).name;      % prima directory che contiene i files PKD (ne visualizzo il nome)
    newdir = current_dir;
    cd(current_dir);                    % mi sposto dentro la prima directory, che diventa quella corrente
    current_dir = pwd;
    content = dir;
    num_files = length(content);

    for k = first:num_files
        filename = content(k).name;
        load(filename);                         % peak_train and artifact are loaded
        tmp         = split(filename, '_');
        tmp2        = split(tmp(end), '.');
        electrode   = char(tmp2(1));
        el = str2double(electrode);             % electrode name [int]
        clear filename                          % Free the memory from unuseful variables

        if (k==first)    % Allocate enough space for ifr_table on the basis of the chosen bin
            bin_num = floor(length(peak_train)/binsample);
            ifr_table = zeros(elNum, bin_num);  % 60*number of bins
        end
        if (sum(peak_train)>0) % Compute only if peak_train is full
%             if (sum(artifact)>0)         % if artifact exists
%                 [peak_train] = delartcontr(peak_train, artifact, cancwinsample);
%             end
            for j = 1:bin_num  % Fill in the bins with the proper spike rate [spikes/sec]
                ch_index = find(mcmea_electrodes==el);
                spikesxbin = length(find(peak_train(((j-1)*binsample+1):(j*binsample))));
                ifr_table(ch_index,j) = spikesxbin/bin_s; % [spikes/sec]
            end
        end
    end
    if ~isempty(ifr_table) % Go on if the table is not empty
        temp = ifr_table;
        ifr_table = [mcmea_electrodes, ifr_table]; % first column with el names
        electrodemean = mean(temp,2); % Check if there are elements with a low MFR
        if find(electrodemean <= mfr_thresh)
            cancel = find(electrodemean <= mfr_thresh);
            ifr_table(cancel,:) = [];
        end
        if ~isempty(ifr_table)
            ifrMean = mean(ifr_table(:,2:end));
            ifrStde = std(ifr_table(:,2:end))./sqrt(size(ifr_table,1));
            ifr_allPhases = [ifr_allPhases; phaseIdx(i-first+1)*ones(length(ifrMean),1) ifrMean(:) ifrStde(:)];
        else
            ifrMean = zeros(bin_num,1);
            ifrStde = zeros(bin_num,1);
            ifr_allPhases = [ifr_allPhases; phaseIdx(i-first+1)*ones(bin_num,1) zeros(bin_num,1) zeros(bin_num,1)];
        end
    else
        ifrMean = zeros(bin_num,1);
        ifrStde = zeros(bin_num,1);
        ifr_allPhases = [ifr_allPhases; phaseIdx(i-first+1)*ones(bin_num,1) zeros(bin_num,1) zeros(bin_num,1)];
    end

    % ---------------------> SAVING PHASE
    cd (end_folder)

    nome = strcat('ifr_', newdir, '_bin', binindicator);
    save (nome, 'ifrMean', 'ifrStde', 'ifr_table')

    clear nome nometxt
    cd(start_folder)
end

cd(end_folder)

save('IFR_allPhases.txt','ifr_allPhases','-ASCII')
save('bin','bin_s')
close(w)
clear content ifr_allPhases name_dir temp
end