function multAnSpAnIMTMfr (start_folder,mfr_thresh,fs,cancwinsample)
%MULTANMFR Summary of this function goes here
%   Detailed explanation goes here
% created by Luca Leonardo Bologna 25 February 2006
% modified by Luca Leonardo Bologna 10 June 2007 
%     -in order to handle the 64 channels of MED64 Panasonic system
% ------------------------------------------------ VARIABLES 
   first=3;
    artifact=[];
    peak_train=[];
    firingch=[];
    totaltime=[];
%     mcmea_electrodes = [(11:18)'; (21:28)'; (31:38)'; (41:48)'; ...
%         (51:58)'; (61:68)'; (71:78)';(81:88)'];
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lookuptable =  [36; 37; 87; 33; 28; 77; 71; 22; 27; 38; 63; 62; ... % CLUSTER A
    58; 57; 56; 68; 45; 48; 47; 55; 67; 78; 46; 66; ... % CLUSTER B + channel B/A
    74; 84; 64; 73; 86; 75; 85; 83; 82; 72; 65; 76; ... % CLUSTER C + channel C/A
    42; 52; 41; 44; 61; 53; 51; 43; 31; 32; 54; 21; ... % CLUSTER D + channel D/A
    15; 14; 25; 16; 23; 34; 24; 35; 26; 17; 13; 12];    % CLUSTER E + channel E/A
IMT_array = [1:12, 1:12, 1:12, 1:12, 1:12]'; % Indexes of the IMT electrodes, ordered as cluster A-B-C-D
cluster_code = [ones(1,12)'; (ones(1,12)'*2); (ones(1,12)'*3); (ones(1,12)'*4); ones(1,12)'*5];
lookuptable = [cluster_code, IMT_array, lookuptable];
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [exp_num]=find_expnum(start_folder, '_PeakDetection');
    [SpikeAnalysis]=createSpikeAnalysisfolder(start_folder, exp_num);
    finalstring =strcat('MeanFiringRate - thresh', num2str(mfr_thresh));
    [end_folder]=createresultfolder(SpikeAnalysis, exp_num, finalstring);
    elNum=60;

    % ------------------------------------------------ START PROCESSING
    cd (start_folder)           % Go to the PeakDetectionMAT folder
    name_dir=dir;               % Present directories - name_dir is a struct
    phaseNames = {name_dir.name};
    phaseNames = char(phaseNames);
    num_dir=length (name_dir);  % Number of present directories (also "." and "..")
    nphases=num_dir-first+1;
    allmfr=zeros(nphases,1);
    phaseNamesSel = cell(1,1);

    for i = first:num_dir     % FOR cycle over all the directories
        current_dir = name_dir(i).name;   % i-th directory - i-th experimental phase
        phasename=current_dir;
        idxUnderscore = strfind(phaseNames(i,:),'_');
        phaseNamesSel{i} = phaseNames(i,idxUnderscore(end-1)+1:idxUnderscore(end)-1);
        cd (current_dir);                 % enter the i-th directory
        current_dir=pwd;
        content=dir;                      % current PeakDetectionMAT files folder
        num_files= length(content);       % number of present PeakDetection files
        mfr_table= zeros (elNum,2);          % vector for MFR allocated (elNumx2)
%         mfr_table(:,1) = mcmea_electrodes; % First column = electrode names
        mfr_table(:,1:3) = lookuptable;
        for k= first:num_files  % FOR cycle over all the PeakDetection files
            filename = content(k).name;
            load (filename);                      % peak_train and artifact are loaded
            tmp         = split(filename, '_');
            tmp2        = split(tmp(end), '.');
            electrode   = char(tmp2(1));
            el= str2num(electrode);               % current electrode [double]
            ch_index= find(lookuptable(:,3)==el);

            if (sum(artifact)>0) % if artifact exists
                [peak_train]= delartcontr (peak_train, artifact, cancwinsample);
            end
            numpeaks=length(find(peak_train));
            acq_time=length(peak_train)/fs;            % duration of acquisition [sec]
            mfr_table(ch_index, 4)= numpeaks/acq_time; % Mean Firing Rate [spikes/min]
        end
        mfr_thresh = 0.1;
        mfr_table= mfr_table(find(mfr_table(:,4)>=mfr_thresh), :); % MFR threshold

        % ------------------------------------------------ SAVING
        if (sum(mfr_table(:,4))>0) % Save only if the table is not empty
            [r,c]=size(mfr_table);
            for j = 1:5
                allmfr(i-first+1,j) = mean(mfr_table(mfr_table(:,1)==j,4));
            end
            totaltime=[totaltime; acq_time/60]; % Total duration of the experiment [min]

            cd (end_folder)        % Save the MAT file
            nome= strcat('mfr_', phasename); % MAT file name
            save (nome, 'mfr_table','allmfr')

            % cd (sub_end2) % Save the TXT file
            nometxt= strcat(nome, '.txt');
            save (nometxt, 'mfr_table', '-ASCII')

            firingch = [firingch; r];
        end
        cd (start_folder)
    end

    totaltime = cumsum(totaltime);

    cd (end_folder)
    nome=strcat(exp_num, '_FiringChannels.txt');
    save (nome, 'firingch', '-ASCII');
    nome=strcat(exp_num, '_ALLmfr.txt');
    save (nome, 'allmfr', '-ASCII')
    figure;
    plot(1:5,allmfr,'o-')
%     ylim([0 10])
    hold all
    xlabel('cluster No.')
    ylabel('MFR [spikes/s]')
    names = phaseNamesSel(first:end);
    legend(names)
    fignome = strcat(exp_num, '_mfrClByCl');
    saveas(gcf,fignome,'fig')
    saveas(gcf,fignome,'jpg')
end