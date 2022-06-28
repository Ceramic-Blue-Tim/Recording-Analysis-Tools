function [] = peak_detection_PTSD_mex_autThComp (peakDuration, refrTime, fs, art_thresh_analog, art_thresh_elec, art_dist, thresh_vector, multCoeff, matfolder, pkdfolder)
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

% INITIALIZE WAITBAR
w = waitbar (0,'Spike Detection PTSD - Please wait...');

% -------------------------- START PROCESSING -----------------------------------
cd(matfolder)
matfolders=dir;
nummatfolders=length(matfolders);

for f=first:nummatfolders % FOR cycle on the phase directories
    waitbar((f-first)/(nummatfolders-first+1)) % WAITBAR
    matdir=matfolders(f).name; %name of the folder
    anafile = [matdir '_A.mat'];
    cd (matdir)     % enter the appropriate directory
    matdir=pwd;     % save the path to the present working directory
    matfiles = dir; % save in a structure the information on the files present in the current directory
    nummatfiles = length(matfiles); % number of .mat files present in the current directory

    % Check if the analog files folder exists: if yes, it performs the
    % artefact detection and saves the timestamps of stimulation artefacts
    curAnafolder = [anafolder,filesep,matfolders(f).name];
    if( exist( fullfile(curAnafolder,anafile) , 'file') )
        stim_artifacts = find_artefacts_analogRawData(fullfile(curAnafolder,anafile),art_thresh_analog);
        fprintf('number of ttl artefacts: [%d].\n',length(stim_artifacts));
    else
        fprintf('Caution!! No Analog Raw Data folder was found: the artefact detection will be performed based on the Electrode Raw Data stream.\n')
        stim_artifacts = -1;
    end

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
        [spkValues, spkTimeStamps] = SpikeDetection_PTSD_core(double(data)', thresh, peakDuration, refrTime);
        spikesTime  = 1 + spkTimeStamps( spkTimeStamps > 0 ); % +1 added to accomodate for zero- (c) or one-based (matlab) array indexing
        spikesValue = spkValues( spkTimeStamps > 0 );
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
            clear spikesTime spikesValue         % FREE the memory from the unuseful variables
            if isequal(stim_artifacts,-1)
                % ARTIFACT DETECTION IF ANA-FILES DO NOT EXIST
%                 artifact = spikesTime( find( abs(spikesValue) > art_thresh ) );
                artifact = find_artefacts_spikeTrain(peak_train, art_dist, art_thresh_elec);
            else
                artifact = stim_artifacts(:); % overwrite with TTL artefacts
            end            
        else % If there are no spikes in the current signal
            peak_train = sparse(length(data), 1);
            artifact = [];
        end      
        save (name, 'peak_train', 'artifact')
        clear peak_train        
        cd (matdir)
    end % on MATFILES
    cd(matfolder)
end % on MATFOLDERS
close (w)