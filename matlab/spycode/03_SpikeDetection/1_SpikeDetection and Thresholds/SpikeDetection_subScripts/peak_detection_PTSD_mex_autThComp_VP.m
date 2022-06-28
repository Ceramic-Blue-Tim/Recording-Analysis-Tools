function [] = peak_detection_PTSD_mex_autThComp_VP (peakDuration, refrTime, alignFlag, fs, art_thresh_analog, art_thresh_elec, art_dist, thresh_vector, multCoeff, w_pre, w_post, interpolation, matfolder, pkdfolder)
% Function to implement the Peak Detection with the Precision Timing Spike
% Detection algorithm (PTSD) and the peak-to-peak threshold computed 
% using a multiplicative factor of the standard deviation of the basal noise.
% The artifact position is saved in the variable artifact.

% PTSD conceived by Alessandro Maccione
% implemented by Mauro Gandolfo (October 2006)
% modified by Michela Chiappalone (February 2009)
% modified by PL Baljon (May 2009)
%   - call to mex file for spike detection
%   - TTL-based artefact detection; original no longer available
%   - more efficient construction of sparse array peak_train
% modified by V Pasquale (May 2009)
%   - introduction of the automatic threshold computation (phase by phase)
% modified by Michela Chiappalone (March 2010)

% --------------- INPUT VARIABLES AND FOLDERS
cd (matfolder)
first=3;
matfolderMod = strrep(matfolder,'_Mat_Files','_Mat_files'); % MAIN folder containing the Mat files
anafolder = strrep(matfolderMod,'_Mat_files','_Ana_files'); % MAIN folder containing the Analog files




warning off MATLAB:MKDIR:DirectoryExists
mkdir (pkdfolder)
cd (pkdfolder)
pkdfolder = pwd;

% w_pre = 10;
% w_post = 22;
ls=w_pre+w_post;

% INITIALIZE WAITBAR
w = waitbar (0,'Spike Detection PTSD - Please wait...');

% -------------------------- START PROCESSING -----------------------------------
cd(matfolder)
matfolders=dir;
nummatfolders=length(matfolders);

for f=first:nummatfolders % FOR cycle on the phase directories
    waitbar((f-first)/(nummatfolders-first+1)) % WAITBAR
    matdir=matfolders(f).name; %name of the folder
    cd ..
    if ( exist( fullfile(anafolder) , 'dir') )
    cd(anafolder)
    
    curAnafolder = [anafolder,filesep,matfolders(f).name];
    curAnaFolderName=matfolders(f).name;
    % %%-------------
    currEl=[];
    PW=[];
   if( exist( fullfile(curAnafolder) , 'file') )
        cd(curAnafolder)      
        anafolders=dir;
        numanafolders=length(anafolders);
        %     %%---------------------->searching Analog channel
        dirContent=dir(pwd);
%         for currEl=3:length(dirContent)
%             load(dirContent(currEl).name);
%             data=detrend(data,'constant');
%             PW(currEl-2)=sum(data.^2);
%         end
        % nANA=find(PW==max(PW));
%         ind_ANA=find(PW==max(PW));
        
%         anafile=dirContent(ind_ANA+2).name;
        anafile=dirContent(3).name;
        %         nANA=str2num(ANA(end-4));
        %         % %%-------------
        %         anafile = [matdir '_A' num2str(nANA) '.mat'];
        if( exist( fullfile(curAnafolder,anafile) , 'file') )
            stim_artifacts = find_artefacts_analogRawData(fullfile(curAnafolder,anafile),art_thresh_analog);
            fprintf('number of ttl artefacts: [%d].\n',length(stim_artifacts));
        else
            fprintf('Caution!! No Analog Raw Data folder was found: the artefact detection will be performed based on the Electrode Raw Data stream.\n')
            stim_artifacts = -1;
        end
        
   else
       fprintf('Caution!! No Analog Raw Data folder was found: the artefact detection will be performed based on the Electrode Raw Data stream.\n')
       stim_artifacts = -1;
   end
    else
        fprintf('Caution!! No Analog Raw Data folder was found: the artefact detection will be performed based on the Electrode Raw Data stream.\n')
        stim_artifacts = -1;
    end
    cd   ([matfolder '\' matdir])     % enter the appropriate directory
    matdir=pwd;     % save the path to the present working directory
    matfiles = dir; % save in a structure the information on the files present in the current directory
    nummatfiles = length(matfiles); % number of .mat files present in the current directory       
    for i=first:nummatfiles % FOR cycle on the single directory files
        filename = matfiles(i).name;     % current file
            tmp     = split(filename, '_');
    tmp2    = split(tmp(end), '.');
    electrode = char(tmp2(1));
        load (filename);                 % load the raw data .mat file
        data= data-mean(data); % "center" the data contained in the .mat file on the value 0
        if ~isempty(thresh_vector)
            thresh = thresh_vector(eval(electrode)); % read the vector of threshold
        else
            thresh = autComputTh(data,fs,multCoeff);
        end
        % -----------------------------------------------------------------
        % Calling the MEX file
        % -----------------------------------------------------------------
        % %%%%%%%%%%%%%%% Valentina - begin
        [spkValues, spkTimeStamps] = SpikeDetection_PTSD_core(double(data)', thresh, peakDuration, refrTime, alignFlag);
        %         [spkValues, spkTimeStamps] = SpikeDetection_PTSD_onlyNeg_core(double(data)', thresh, peakDuration, refrTime);
        % %%%%%%%%%%%%%%% Valentina - end
        spikesTime  = 1 + spkTimeStamps( spkTimeStamps > 0 ); % +1 added to accomodate for zero- (c) or one-based (matlab) array indexing
        spikesValue = spkValues( spkTimeStamps > 0 );
        % %%%%%%%%%%%% Valentina - begin
        spikesValue(spikesTime<=w_pre+1 | spikesTime>=length(data)-w_post-2)=[];
        spikesTime(spikesTime<=w_pre+1 | spikesTime>=length(data)-w_post-2)=[];
        nspk = length(spikesTime);
        % %%%%%%%%%%%% Valentina - end
        clear spkValues spkTimeStamps; % very large arrays.
        
        % Prepare for the SAVING phase
        name=strcat('ptrain_', filename);
        pkdirname= name(1:end-7);
        cd (pkdfolder)
        pkdir= dir;
        numpkdir= length(dir);
        if isempty(strmatch(pkdirname, strvcat(pkdir(1:numpkdir).name),'exact'))
            mkdir (pkdirname) % Make a new directory only if it doesn't exist
        end
        cd (pkdirname)
        
        % Check if there are spikes before SAVING
        if ( any(spikesTime) ) % If there are spikes in the current signal
            % more efficient code, not creating train in memory: possible to make sparse array immediately. PL 05/09.
            peak_train = sparse(spikesTime,1,spikesValue,length(data),1);
            %             clear spikesTime spikesValue         % FREE the memory from the unuseful variables
            clear spikesValue
            if isequal(stim_artifacts,-1)
                % ARTIFACT DETECTION IF ANA-FILES DO NOT EXIST
                %                 artifact = spikesTime( find( abs(spikesValue) > art_thresh ) );
                artifact = find_artefacts_spikeTrain(peak_train, art_dist, art_thresh_elec);
            else
                artifact = stim_artifacts(:); % overwrite with TTL artefacts
            end
            % %%%%%%%%%%% Valentina - begin
            % _______________________________
            % SPIKE WAVEFORM STORING
            spikes = zeros(nspk,ls+4);
            data = [data; zeros(w_post,1)];
            for ii=1:nspk                          % Eliminates artifacts
                if max(abs(data(spikesTime(ii)-w_pre:spikesTime(ii)+w_post))) < art_thresh_elec
                    spikes(ii,:) = data(spikesTime(ii)-w_pre-1:spikesTime(ii)+w_post+2);
                end
            end
            aux = find(spikes(:,w_pre)==0);       % erases indexes that were artifacts
            spikes(aux,:)=[];
            peak_train(spikesTime(aux))=0;
            clear spikesTime
            switch interpolation
                case 1
                    spikes(:,end-1:end)=[];       %eliminates borders that were introduced for interpolation
                    spikes(:,1:2)=[];
                case 0
                    %                         Does interpolation
                    spikes = interpolate_spikes(spikes,w_pre,w_post,2);
            end
            % ____________________________________
        else % If there are no spikes in the current signal
            peak_train = sparse(length(data), 1);
            artifact = [];
            spikes = [];
        end
        save(name, 'peak_train', 'artifact', 'spikes')
        clear peak_train
        cd (matdir)
        % %         else % If there are no spikes in the current signal
        % %             peak_train = sparse(length(data), 1);
        % %             artifact = [];
        % %         end
        % %         save (name, 'peak_train', 'artifact')
        % %         clear peak_train
        % %         cd (matdir)
        % %%%%%%%%%%% Valentina - end
    end % on MATFILES
    cd(matfolder)
end % on MATFOLDERS
close (w)