% MAIN_StatisticsReportMean.m
% by Michela Chiappalone (12 Aprile 2006)
% Probably it needs to be updated on the basis of the other scripts on
% burst detection, already changed
% modified by Luca Leonardo Bologna
%   - in order to handle the 64 channels of MED64 Panasonic System
% changed - not able to manage the 64 channel of MED Panasonic system

[start_folder]= selectfolder('Select the BurstDetectionFiles folder');
if strcmp(num2str(start_folder),'0')
    errordlg('Selection Failed - End of Session', 'Error');
    return
end

% -----------> INPUT FROM THE USER & VARIABLES
[exp_num]=find_expnum(start_folder, '_BurstDetectionFiles'); % Experiment number
first=3;
burstingch=0;
burstingchs=[];

% -----------> FOLDER MANAGEMENT
cd (start_folder);
cd ..
% burst_folder=pwd;
cd ..
exp_folder=pwd;
[end_folder]=createresultfolder(exp_folder, exp_num, 'BurstAnalysis');
[end_folder1]=createresultfolder(end_folder, exp_num, 'MeanStatReportBURST');
[end_folder2]=createresultfolder(end_folder, exp_num, 'MeanStatReportSPIKEinBURST');
clear burstfoldername expfolder

% --------------> COMPUTATION PHASE: Create Statistics Report
cd (start_folder)
content= dir;
NumFiles= length(content);
for i=first:NumFiles
    filename = content(i).name;
    load (filename); % burst_detection_cell [cell_array] is loaded
    
    % changed by Michela Chiappalone
%     if length(burst_detection_cell)==87 %added for compatibility with previous versions
%         burst_detection_cell(end+1)=[];
%     end

    burstingch=0;
    SRMburst=[];
    SRMspike=[];
mfr_only_spikes_tot=[];
    for k=1:87
        burst_detection=burst_detection_cell{k,1};

        if ~isempty(burst_detection_cell{k,1})
            acq_time=burst_detection(end,1); % Acquisition time [sec]

            % Burst Features
            burstingch=burstingch+1;
            totalbursts= burst_detection(end,3);            % total # of bursts
            spikesxburst=  burst_detection(1:end-1,3);      % # of spikes in burst
            burstduration= burst_detection(1:end-1,4)*1000; % Burst Duration[msec]
            ibi= burst_detection(1:end-2,5);                % IBI start-to-start [sec]
            mbr= burst_detection(end,5);                    % mbr [#bursts/min]

            % Spike Features
            totalspikes= burst_detection(end,2);            % total # of spikes
            mfr= totalspikes/acq_time;                      % mfr [#spikes/sec]
            totalburstspikes= burst_detection(end,4);       % total # of intra-burst spikes
            percrandomspikes= ((totalspikes-totalburstspikes)/totalspikes)*100; % Percentage of random spikes
           
            mfb=(spikesxburst./burstduration)*1000;         % mfb = mean freq intraburst [#spikes/sec]
            pfb= max(mfb);                                  % peak frequency intra burst

            % Fill in the StatReportMean arrays
            lastrow= [k, acq_time, mbr, totalbursts, ...
                mean(spikesxburst), stderror(mean(spikesxburst), spikesxburst),...
                mean(burstduration), stderror(mean(burstduration), burstduration),...
                mean(ibi), stderror(mean(ibi), ibi)];
            SRMburst=[SRMburst; lastrow];
           
            clear lastrow

            lastrow=  [k, acq_time, totalspikes, totalburstspikes, percrandomspikes, ...
                pfb, mean(mfb), stderror(mean(mfb), mfb)];
            SRMspike= [SRMspike; lastrow];
            clear lastrow
          
        end   
    end
    burstingchs=[burstingchs; burstingch];

    % Mean Stat Report MAT and TXT - Burst
    cd (end_folder1)
    nome=strcat('MStReportB', filename(16:end));
    save(nome, 'SRMburst')
   
   
    clear nome
    nome=strcat('MStReportB', filename(16:end-4), '.txt');
    save(nome, 'SRMburst', '-ASCII')
    clear nome

    % Mean Stat Report MAT and TXT - Spikes
    cd (end_folder2)
    nome=strcat('MStReportSpinB', filename(16:end));
    save(nome, 'SRMspike')
    clear nome
    nome=strcat('MStReportSpinB', filename(16:end-4), '.txt');
    save(nome, 'SRMspike', '-ASCII')
    clear nome

    cd (start_folder)
end

%burstingchs=(burstingchs/60)*100;

cd (end_folder1)
nome=strcat(exp_num, '_BurstingChannels.txt');
save(nome, 'burstingchs', '-ASCII')

EndOfProcessing (start_folder, 'Successfully accomplished');
clear all
