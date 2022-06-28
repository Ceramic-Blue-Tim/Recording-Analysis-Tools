% MAIN_mfr.m
% Table saved in MAT format only - 1 table for each phase
% mfr_table [elNumx3] (electrode name, MFR, acquisition time)

% by Michela Chiappalone (3 Marzo 2006)
% modified by Luca Leonardo Bologna (10 June 2007) - MFR is saved even if no
% activity has been found
% modified by M. Chiappalone (26 Aprile 2010)

[start_folder]= selectfolder('Select the source folder that contains the PeakDetectionMAT files');
if strcmp(num2str(start_folder),'0')
    errordlg('Selection Failed - End of Session', 'Error');
    return
end
cd(start_folder)

% ------------------------------------------------ VARIABLES

[mfr_thresh, cancwin, fs, cancelFlag]= uigetMFRinfo;
% mfr_thresh [spikes/sec]
% cancwin [msec]
elNum = GlobalsParams.DEFAULT_NB_CH; %number of electrodes in the array [this number should be given by the user in a following version]

if cancelFlag
    return
else
    cancwinsample= cancwin/1000*fs;
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

    % ------------------------------------------------ START PROCESSING
    cd (start_folder)         % Go to the PeakDetectionMAT folder
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
            el= str2num(electrode);     % current electrode [double]
            ch_index= find(mcmea_electrodes==el);

            if (sum(artifact)>0) % if artifact exists
                [peak_train]= delartcontr (peak_train, artifact, cancwinsample);
            end
            numpeaks=length(find(peak_train));
            acq_time=length(peak_train)/fs;            % duration of acquisition [sec]
            mfr_table(ch_index, 2)= numpeaks/acq_time; % Mean Firing Rate [spikes/sec]            
            mfr_table(ch_index, 3) = numpeaks;         % Valentina
        end

        mfr_table= mfr_table(find(mfr_table(:,2)>=mfr_thresh), :); % MFR threshold

        % ------------------------------------------------ SAVING
        [r,c]=size(mfr_table);
        allmfr(i-first+1,1)=mean(mfr_table(:,2));
        totaltime=[totaltime; acq_time/60]; % Total duration of the experiment [min]

        cd (end_folder)        % Save the MAT file
        nome= strcat('mfr_', phasename); % MAT file name
        save (nome, 'mfr_table')        
        nometxt= strcat(nome, '.txt');
        save (nometxt, 'mfr_table', '-ASCII')
        firingch=[firingch; r];

        cd (start_folder)
    end

    cd (end_folder)
    nome=strcat(exp_num, '_FiringChannels.txt');
    save (nome, 'firingch', '-ASCII')
    
    nome=strcat(exp_num, '_allmfr');
    save (nome, 'allmfr')
    nome=strcat(exp_num, '_allmfr.txt');
    save (nome, 'allmfr','-ASCII')

    % PLOT PHASE
    totaltime=cumsum(totaltime);
    h=figure;
    h=plot(totaltime, allmfr, '--ko', 'MarkerFaceColor','r');
    xlim([0 totaltime(end)+1]) 
    xlabel('Time [min]')
    ylabel('Mean Firing Rate [spikes/sec]')   

    % ------------------- END OF PROCESSING
    EndOfProcessing (start_folder, 'Successfully accomplished');
    keep allmfr totaltime
end