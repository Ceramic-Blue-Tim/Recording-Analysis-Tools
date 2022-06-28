function []= peak_detectionOK (window, fs, art_thresh, art_dist, thresh_vector, matfolder, pkdfolder)
% Peak detection
% Function to implement the Peak Detection algorithm with the shifting
% window and the peak-to-peak threshold computed using a multiplicative
% factor of the standard deviation of the basal noise.
% The artifact position is saved in the variable artifact

% by Michela Chiappalone (3 Maggio 2005)
% modified by Luca Leonardo Bologna (16 November 2006)
% modified by Pieter Laurens Baljon (April 2007)
%   added support for analog channels containing artifacts.

anafolder = strrep(matfolder,'_Mat_files','_Ana_files');

w = waitbar(0,'Peak Detection - Please wait...');
cd(matfolder)
first=3;
matfolders=dir;
nummatfolders=length(matfolders);
% -------------------------- START PROCESSING -----------------------------------
for f=first:nummatfolders % FOR loop on the phase directories
    waitbar((f-first)/(nummatfolders-first+1)) % WAITBAR
    matdir=matfolders(f).name; %name of the folder
    anafile = [matdir '_A.mat'];
    cd (matdir) %enter the appropriate directory
    matdir=pwd; %save the path to the present working directory
    matfiles = dir; % save in a structure the information on the files present in the current directory
    nummatfiles = length(matfiles); % number of .mat files present in the current directory
    
    if( exist( fullfile(anafolder,anafile) , 'file') )
        stim_artifacts = find_ttl_pulses( fullfile(anafolder,anafile) );
        fprintf('number of ttl artefacts: [%d].\n',length(stim_artifacts));
    else
        stim_artifacts = -1;
    end
    
    for i=first:nummatfiles % FOR loop on the single directory files
        filename = matfiles(i).name; % current file
            tmp     = split(filename, '_');
    tmp2    = split(tmp(end), '.');
    electrode = char(tmp2(1));
        load (filename); % load the .mat file
        data= data-mean(data); % "center" the data contained in the .mat file on the value 0
        thresh = thresh_vector(eval(electrode)); % read the vector of threshold
        n= length(data);
        value=[];
        artifact=[];
        % -------------> PEAK DETECTION
        %"tokenizedData" contains the same elements of data rearranged in a
        %"window" x "floor(numSamples/window)" grid; the ith column of "tokenizedData"
        %contains the samples belonging to the ith window used for the spike detection
        tokenizedData=reshape(data(1:end-rem(n,window)),window,floor(n/window));
        [w_max,maxRows]=max(tokenizedData); %w_max = array with the biggest elements contained in the columns of "tokenizedData", "maxRows" array containing the rows of "tokenizedData" in which the max elements are positioned
        [w_min,minRows]=min(tokenizedData); %w_min = array with the smallest elements contained in the columns of "tokenizedData", "minRows" array containing the rows of "tokenizedData" in which the min elements are positioned
        wDiff=w_max-w_min; %array conatining the difference between "w_max" and "w_min"
        indGrThThreshCol=find(wDiff>thresh); %indexes of wDiff elements greater than "thresh"

        % -------------> temporary variables
        w_maxTh=w_max(indGrThThreshCol); %array containing the elements of "w_max" belonging to the windows in which the threshold is overcome
        w_minTh=w_min(indGrThThreshCol); %array containing the elements of "w_min" belonging to the windows in which the threshold is overcome
        w_maxThAbs=abs(w_maxTh);%absolute value of w_maxTh
        w_minThAbs=abs(w_minTh);%absolute value of w_minTh
        sizeTokenizedData=size(tokenizedData); %array containing the dimensions of tokenizedData
        indGrLen=length(indGrThThreshCol); % number of columns in which the threshold is exceeded
        indMaxAbsColInd=find(w_maxThAbs>=w_minThAbs); % indices in which the elements of "w_maxThAbs" is greater or equal than "w_minThAbs"
        indMinAbsColInd=setdiff(1:indGrLen,indMaxAbsColInd); % indices in which the elements of "w_maxThAbs" is smaller than "w_minThAbs"
        indMaxNeeded=indGrThThreshCol(indMaxAbsColInd); %columns in which "w_maxThAbs" is greater or equal than "w_minThAbs" (only the columns in which the threshold is exceeded are considered)
        indMinNeeded=indGrThThreshCol(indMinAbsColInd);%columns in which "w_maxThAbs" is smaller than "w_minThAbs" (only the columns in which the threshold is exceeded are considered)
        maxRowsNeeded=maxRows(indMaxNeeded); % rows of "tokenizedData" in which "w_maxThAbs" is greater or equal than "w_minThAbs" (only the columns in which the threshold is exceeded are considered)
        minRowsNeeded=minRows(indMinNeeded); % rows of "tokenizedData" in which "w_maxThAbs" is smaller than "w_minThAbs" (only the columns in which the threshold is exceeded are considered)
        indMaxAbs=sub2ind(sizeTokenizedData,maxRowsNeeded,indMaxNeeded); %indices of "tokenizedData" in which "w_maxThAbs" is greater or equal than "w_minThAbs"  as if "tokenizedData" were a 1D array
        indMinAbs=sub2ind(sizeTokenizedData,minRowsNeeded,indMinNeeded); %indices of "tokenizedData" in which "w_maxThAbs" is smaller than "w_minThAbs"  as if "tokenizedData" were a 1D array
        peak_train = zeros(n, 1); % store values and timestamps of the peak trains
        peak_train=sparse(peak_train); % convert peak_train in a sparse matrix (for performance improvement)
        % <-------------
        
        value(1:indGrLen)=wDiff(indGrThThreshCol); %set value with the peak-to-peak values of the windows in which the threshold has been overcome
        y=sort([indMaxAbs,indMinAbs]); % indices of "tokenizedData" in which the values to be stored in "peak_train" are contained
        clear w_maxTh w_minTh w_maxThAbs w_minThAbs indMaxAbsColInd indMinAbsColInd maxRowsNeeded minRowsNeeded ...
            indMaxNeeded indMinNeeded wDiff w_max w_min tokenizedData %clear useless variables
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
        if (length(y)>0) % If there are spikes in the current signal
            y=y'; %transpose the array
            peak_train(y) = value;      % the peak value is the peak-to-peak amplitude in uV
            clear train value           % FREE the memory from the useless variables
          %[artifact] = find_artefacts_analogRawData(peak_train, art_dist, art_thresh); % Collection of artifact's positions
             [artifact] = find_artefacts_spikeTrain(peak_train, art_dist, art_thresh); % Collection of artifact's positions
            art_num=length(artifact);% number of artifacts
            j=1;
            while (j<art_num-1) %FOR loop deleting the artifact timestamps which are far from the preceding timestamp less than "art_dist" 
                if (artifact(j+1)-artifact(j)<art_dist) %if the distance between two consecutive timestamps is smaller than "art_dist"
                    if (j+1)== art_num %if the last artifact timestamp is being analized
                        artifact=artifact(1:j); % set artifact to its current values except for the last element
                    else
                        B=artifact; %temporary copy of artifact
                        artifact=[B(1:j) ; B(j+2:art_num)]; %
                        art_num=art_num-1;
                    end
                end
                j=j+1;
            end
        end
        
        if( stim_artifacts ~= -1 )
            % overwrite with TTL artefacts.
            artifact = stim_artifacts(:);
        end
        
        save (name, 'peak_train', 'artifact'); %saves "peak_train" and "artifact" variables in the .mat file "name"
        clear peak_train artifact B; % clear workspace from useless variables
        cd (matdir) % 
    end % on MATFILES
    cd(matfolder)
end % on MATFOLDERS
close (w)