function multAnMfr (start_folder,mfr_thresh,fs,cancwinsample)
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
    mcmea_electrodes = GlobalsParams.DEFAULT_ELECTRODES_LAYOUT;

    [exp_num]=find_expnum(start_folder, '_PeakDetection');
    [SpikeAnalysis]=createSpikeAnalysisfolder(start_folder, exp_num);
    finalstring =strcat('MeanFiringRate - thresh', num2str(mfr_thresh));
    [end_folder]=createresultfolder(SpikeAnalysis, exp_num, finalstring);
    elNum=64;

    % ------------------------------------------------ START PROCESSING
    cd (start_folder)           % Go to the PeakDetectionMAT folder
    name_dir=dir;               % Present directories - name_dir is a struct
    num_dir=length (name_dir);  % Number of present directories (also "." and "..")
    nphases=num_dir-first+1;
    allmfr=zeros(nphases,1);

    for i = first:num_dir     % FOR cycle over all the directories
        current_dir = name_dir(i).name;   % i-th directory - i-th experimental phase
        phasename=current_dir;
        cd (current_dir);                 % enter the i-th directory
        current_dir=pwd;
        content=dir;                      % current PeakDetectionMAT files folder
        num_files= length(content);       % number of present PeakDetection files
        mfr_table= zeros (elNum,2);          % vector for MFR allocated (elNumx2)
        mfr_table(:,1)= mcmea_electrodes; % First column = electrode names

        for k= first:num_files  % FOR cycle over all the PeakDetection files
            filename = content(k).name;
            load (filename);                      % peak_train and artifact are loaded
            tmp         = split(filename, '_');
            tmp2        = split(tmp(end), '.');
            electrode   = char(tmp2(1));
            el= str2num(electrode);               % current electrode [double]
            ch_index= find(mcmea_electrodes==el);

            if (sum(artifact)>0) % if artifact exists
                [peak_train]= delartcontr (peak_train, artifact, cancwinsample);
            end
            numpeaks=length(find(peak_train));
            acq_time=length(peak_train)/fs;            % duration of acquisition [sec]
            mfr_table(ch_index, 2)= numpeaks/acq_time; % Mean Firing Rate [spikes/sec]
            % Valentina
            mfr_table(ch_index, 3) = numpeaks;
        end

        mfr_table= mfr_table(find(mfr_table(:,2)>=mfr_thresh), :); % MFR threshold

        % ------------------------------------------------ SAVING
        if (sum(mfr_table(:,2))>0) % Save only if the table is not empty
            [r,c]=size(mfr_table);
            allmfr(i-first+1,1)=mean(mfr_table(:,2));
            totaltime=[totaltime; acq_time/60]; % Total duration of the experiment [min]

            cd (end_folder)        % Save the MAT file
            nome= strcat('mfr_', phasename); % MAT file name
            save (nome, 'mfr_table')

            % cd (sub_end2) % Save the TXT file
            nometxt= strcat(nome, '.txt');
            save (nometxt, 'mfr_table', '-ASCII')

            firingch=[firingch; r];
        end
        cd (start_folder)
    end

    totaltime=cumsum(totaltime);

    cd (end_folder)
    nome=strcat(exp_num, '_FiringChannels.txt');
    save (nome, 'firingch', '-ASCII');
    nome=strcat(exp_num, '_allmfr');
    save (nome, 'allmfr')
    nome=strcat(exp_num, '_allmfr.txt');
    save (nome, 'allmfr','-ASCII')
end
