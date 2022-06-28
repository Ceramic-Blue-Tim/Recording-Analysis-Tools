function [ outputMessage] = multAnSpAnAfr(start_folder, binsample, mfr_thresh, fs,cancwinsample)
%MULTANSPANAFR Summary of this function goes here
%   Detailed explanation goes here
% modified by Luca Leonardo Bologna (10 June 2007)
%  - in order to handle the 64 channels of the MED64 Panasonic system

% -----------> ERROR CONTROL FOR BIN SIZE
minbin = 1/fs;  % 0.1 msec  = usually equal to the sampling frequency
maxbin = 300000000;   % 5 minutes = total duration of the acquisition
if ((minbin>=binsample)|(binsample>=maxbin))
    outputMessage=[outputMessage blanks(1) 'impossible to perform "Spike Analysis": wrong "Average firing rate" parameters chosen'];
    return
end
%

[exp_num]=find_expnum(start_folder, '_PeakDetection');
[SpikeAnalysis]=createSpikeAnalysisfolder (start_folder, exp_num);
finalstring= strcat('AverageFiringRate - thresh', num2str(mfr_thresh));
[end_folder]=createresultfolder(SpikeAnalysis, exp_num, finalstring);
first=3;
binsec= binsample/fs;               % bin [sec]
bin=binsec*1000;
afr_table=[];
allafr=[];
mcmea_electrodes = GlobalsParams.DEFAULT_ELECTRODES_LAYOUT;
elNum=64;
% ------------------------------------------------ START PROCESSING
w = waitbar(0, 'AFR(t) computation - Please wait...');
wtbr=0;
if (binsec>=1)
    binindicator=strcat(num2str(binsec), 'sec');
else
    binindicator=strcat(num2str(bin), 'msec');
end
cd (start_folder)         % Go to the PeakDetectionMAT folder
name_dir=dir;                            % guarda quali directory sono presenti e si crea la struttura name_dr
num_dir=length (name_dir);               % num_dir � il numero di directory presenti, considera anche . e ..

for i = first:num_dir                    % inizio a ciclare sulle directory
    wtbr=wtbr+1;
    waitbar(wtbr/num_dir) % WAITBAR TO CHECK
    current_dir = name_dir(i).name;      % prima directory che contiene i files PKD (ne visualizzo il nome)
    newdir=current_dir;
    cd (current_dir);                    % mi sposto dentro la prima directory, che diventa quella corrente

    current_dir=pwd;
    content=dir;
    num_files= length(content);

    for k=first:num_files
        filename = content(k).name;
        load (filename);                  % peak_train and artifact are loaded
        tmp         = split(filename, '_');
        tmp2        = split(tmp(end), '.');
        electrode   = char(tmp2(1));
        el= str2num(electrode);           % electrode name [int]
        clear filename                    % Free the memory from unuseful variables

        if (k==first)    % Allocate enough space for afr_table on the basis of the chosen bin
            bin_num = floor(length(peak_train)/binsample); %
            afr_table= zeros (elNum, bin_num);
        end
        if (sum(peak_train)>0) % Compute only if peak_train is full
            if (sum(artifact)>0)         % if artifact exists
                [peak_train]= delartcontr (peak_train, artifact, cancwinsample);
            end
            for j=1:bin_num  % Fill in the bins with the proper spike rate [spikes/sec]
                ch_index= find(mcmea_electrodes==el);
                spikesxbin=length(find(peak_train(((j-1)*binsample+1):(j*binsample))));
                afr_table(ch_index,j)= spikesxbin/binsec; % [spikes/sec]
            end
        end
    end

    if ~isempty(afr_table) % Go on if the table is not empty
        temp=afr_table;
        afr_table=[mcmea_electrodes, afr_table]; % first column with el names
        electrodemean= mean(temp'); % Check if there are elements with a low MFR
        if find(electrodemean<=mfr_thresh)
            cancel=find(electrodemean<=mfr_thresh);
            afr_table(cancel,:)=[];
        end
        afr= mean(afr_table(:,2:end))';

        % ---------------------> PLOT PHASE
        figure
        subplot(2,1,1) % Activity on active channels
        image(afr_table(:,2:end))
        createcolorbar_afr(gca)
        colormap hot
        axis off

        subplot(2,1,2) % Average firing rate of the network
        x=binsec*[1:length(afr)];
        h= plot(x, afr, '-', 'MarkerFaceColor', 'b');
        xlim([0 x(end)])
        h = gcf;
        xlabel('Time [sec]')
        ylabel('Average Firing Rate [spikes/sec]')

        % ---------------------> SAVING PHASE
        cd (end_folder)

        nome= strcat('afr_', newdir, '_bin', binindicator);
        save (nome, 'afr', 'afr_table')
        saveas(h,nome,'jpg');
        saveas(h,nome,'fig');
        close(h)

        % saveas(afrplot,nome,'fig');
        % nometxt= strcat(nome, '.txt');
        % save (nometxt, 'afr', '-ASCII')
        clear nome nometxt
    end
    cd(start_folder)
end
close(w)
% -------------------------- END OF PROCESSING
end
