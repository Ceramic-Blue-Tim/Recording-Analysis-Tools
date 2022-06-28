%%Burstiness Index
%%Alberto Averna (Irene Nava previus algorithm)

[start_folder]= selectfolder('Select the PeakDetectionMAT folder');
if strcmp(num2str(start_folder),'0')
    errordlg('Selection Failed - End of Session', 'Error');
    return
end
cd(start_folder)
cd ..
exp_folder=pwd;
cancelFlag = 0;
PopupPrompt  = {'Sampling frequency [samples/sec]','BI Window [sec]'};
PopupTitle   = 'Burstiness Index - BI)';
PopupLines   = 1;
PopupDefault = {GlobalsParams.DEFAULT_FS_CHAR,'300'};
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault);
if isempty(Ianswer)
    cancelFlag = 1;
else
    fs = str2num(Ianswer{1,1});  % Sampling frequency
     BIWindow = str2num(Ianswer{2,1});  % Window Burstiness Index
end
if cancelFlag
    return
else
    
    if BIWindow<100
       disp(['BI Window maybe too short ' num2str(BIWindow) ' [sec]']);
    
    end
    
    l_exp=0;
    j=0;
    first=3;
    peak_train=[];
    firingch=[];
    BI=[];
    BI_Tot=[];
    f15=[];
    mcmea_electrodes = GlobalsParams.DEFAULT_ELECTRODES_LAYOUT;
        [exp_num]=find_expnum(start_folder, '_PeakDetection');
    %[SpikeAnalysis]=createSpikeAnalysisfolder(start_folder, exp_num);
    finalstring ='BurstinessIndex';
    %[end_folder]=createresultfolder(SpikeAnalysis, exp_num, finalstring);
    [end_folder] = createresultfolder(exp_folder, exp_num, 'BurstAnalysis');
    [end_folder1]= createresultfolder(end_folder, exp_num, finalstring);
    % ------------------------------------------------ START PROCESSING
    cd (start_folder)         % Go to the PeakDetectionMAT folder
    name_dir=dir;               % Present directories - name_dir is a struct
    num_dir=length (name_dir);  % Number of present directories (also "." and "..")
    nphases=num_dir-first+1;
    allmfr=zeros(nphases,1);
    for i = first:num_dir     % FOR cycle over all the directories
        spks=[];
        j=j+1;
        current_dir = name_dir(i).name;   % i-th directory - i-th experimental phase
        phasename=current_dir;
        
        cd (current_dir);                 % enter the i-th directory
        current_dir=pwd;
        content=dir;                      % current PeakDetectionMAT files folder
        num_files= length(content);       % number of present PeakDetection files
        
        for k= first:num_files  % FOR cycle over all the PeakDetection files
            filename = content(k).name;
            load (filename);                      % peak_train and artifact are loaded
            tmp         = split(filename, '_');
            tmp2        = split(tmp(end), '.');
            el          = char(tmp2(1));
            ch_index= find(mcmea_electrodes==el);
            spks=[spks ;([el(ones(length(find(peak_train)),1)), find(peak_train)])];
        end
        l_exp=l_exp+(length(peak_train)/fs);
        acq_time=length(peak_train)/fs;
        if acq_time+10<BIWindow
            h=errordlg(['BIWindow>Acq_Time:' num2str(BIWindow) '>' num2str(acq_time)]);
            return
        end
        samples_BI=spks(:,2);
        sec_BI=round(samples_BI/fs);   %samples to seconds
        edges=(1:acq_time);
        n_spikes=hist(sec_BI,edges);
        difwin=length(n_spikes)-BIWindow*(round(length(n_spikes)/BIWindow));
        if length(n_spikes)>=310
            for n=1:round(length(n_spikes)/BIWindow)    %calcolo BI ogni 5min di registrazione
                
                if n*(BIWindow)<=length(n_spikes)
                    X=n_spikes( (n-1)*BIWindow+1 : n*(BIWindow));
                    % X=n_spikes( (n-1)*300+1 : n*300 );
                else
                    X=n_spikes( (n-1)*BIWindow+1 : end);
                end
                
                X=sort(X);
                NumBins=length(X);
                LargestCounts=(round(0.85*NumBins):NumBins);
                f15(n)=sum(X(LargestCounts))/sum(X);
                BI(n)=(f15(n)-0.15)/0.85;
            end
        else
            n=1;
            X=n_spikes;
            X=sort(X);
            NumBins=length(X);
            LargestCounts=(round(0.85*NumBins):NumBins);
            f15=sum(X(LargestCounts))/sum(X);
            BI=(f15-0.15)/0.85;
        end
        
        BI_Tot(j)=sum(BI)/n;
        BI_Tot=BI_Tot';
        cd (start_folder)
    end
    
    cd (end_folder1)
    nome=strcat(exp_num, '_BI.txt');
    save (nome, 'BI_Tot', '-ASCII')
    nome=strcat(exp_num, '_BI');
    save (nome, 'BI_Tot')
    disp(['BI_Tot' '_' num2str(l_exp/60) 'min' ': ' num2str(sum(BI_Tot)/j)]);
    
    EndOfProcessing (start_folder, 'Successfully accomplished');
    
end
