% MAIN_OutBurstReport.m
% by Michela Chiappalone (June 2010)

clr
[start_folder]= selectfolder('Select the OutBSpikes folder');
if strcmp(num2str(start_folder),'0')
    errordlg('Selection Failed - End of Session', 'Error');
    return
end

% -----------> INPUT FROM THE USER & VARIABLES
[exp_num]=find_expnum(start_folder, '_OutBSpikesFiles'); % Experiment number
first=3;
fs = GlobalsParams.DEFAULT_FS; % qs valore � cablato ATTENZIONE!!!!

% -----------> FOLDER MANAGEMENT
cd (start_folder);
cd ..
cd ..
exp_folder=pwd;
[end_folder]=createresultfolder(exp_folder, exp_num, 'BurstAnalysis');
[end_folder1]=createresultfolder(end_folder, exp_num, 'MeanStatReportOUTBURSTSPIKES');
clear burstfoldername expfolder

% --------------> COMPUTATION PHASE: Create Statistics Report
cd (start_folder)
content= dir;
NumFiles= length(content);

for i=first:NumFiles
    
    outburst_spikes_cell = [];
    SROutBurstSpikes     =[];
    
    filename = content(i).name;
    load (filename); % outburst_spikes_cell [cell_array] is loaded
    
    if length(outburst_spikes_cell)== 87 %added for compatibility with previous versions
        outburst_spikes_cell(end+1)=[]; %#ok<AGROW>
    end   
    
    for k=1:88
        OutBurstSpikes = outburst_spikes_cell{k,1};

        if ~isempty(outburst_spikes_cell{k,1})
            % Out Burst Features            
            AllNonBurstDuration  = (cell2mat(OutBurstSpikes (:, 2)) ...
                                      - cell2mat(OutBurstSpikes (:, 1)))/fs; % Duration of the non Burst Period [N x1, sec]
            TotalNonBurstDuration = sum (AllNonBurstDuration);  % Entire duration of the num burst period [sec]
            MeanNonBurstDuration  = mean (AllNonBurstDuration); % Mean non-burst period [sec]
            n_outbspikes      = sum (cell2mat(OutBurstSpikes (:, 3)));    % Number of spikes in the non-burst period
            mfob_withzeros    = mean(cell2mat(OutBurstSpikes(:,4)));      % Mean Frequency in the non-burst period - with zeros
            mfob_withoutzeros = mean (nonzeros(cell2mat(OutBurstSpikes(:,4)))); % Mean Frequency in the non-burst period - without zeros
            
            % outbspikes     % Position of the spikes in the non-burst period
            % isi_outbspikes % ISI of spikes in the non-burst period
            % f_outbspikes    % Frequency of the spikes in the non-burst period
            
%             % Fill in the StatReportMean arrays
             lastrow= [k,  TotalNonBurstDuration, MeanNonBurstDuration, ...
                       n_outbspikes,  mfob_withzeros, mfob_withoutzeros];                   
             SROutBurstSpikes = [SROutBurstSpikes; lastrow];
            clear lastrow
        end
    end

    % Mean Stat Report MAT and TXT - Out Burst Spikes
    cd (end_folder1)
    nome=strcat('MStReportOutBstSpk_', filename(16:end)); % check filename
    save(nome, 'SROutBurstSpikes')
    clear nome
    nome=strcat('MStReportOutBstSpk_', filename(16:end), '.txt'); % check filename
    save(nome, 'SROutBurstSpikes', '-ASCII')
    clear nome

    cd (start_folder)
end

EndOfProcessing (start_folder, 'Successfully accomplished');
clear all
