function []= buildcorrelogram (start_folder, corr_folder, window, binsize, cancwin, fs, normid)
% by Michela Chiappalone
% modified by Luca Leonardo Bologna 21 November 2006
% buildcorrelogram.m
% Function for building the cross-correlation functions from burst_event
% INPUT:
%          start_folder= folder containing the Peak Detection files
%          corr_folder= folder containing the cross-correlation files
%          window= window of the correlation
%          binsize= bin dimension within the correlation window
%          cancwin= window for deleting the artifact
%          fs = sampling frequency
%          normid = normalization procedure
% by Michela Chiappalone (6 Maggio 2005, 16 Febbraio 2007)
% modified by Luca Leonardo Bologna (21 November 2006)
% modified by Luca Leonardo Bologna (10 June 2007) 
%   - in order to handle the 64 channels of MED64 Panasonic system

cd (start_folder)
sourcedir= dir;      % Names of the elements in the start_folder directory - struct array
numdir= length(dir); % Number of elements in the start_folder directory
first= 3;            % First two elements '.' and '..' are not considered
for i = first:numdir                 % Cycle over the directories
    current_dir = sourcedir(i).name;  % Directory containing the PKD files - visualization
    foldername=current_dir;
    finalfolder=foldername(8:end);
    cd (current_dir);
    current_dir=pwd;
    % --------------> COMPUTATION PHASE: CROSS_CORRELATION
    filecontent=dir;
    numfiles= length(filecontent);
    for k=first:numfiles
        r_table= cell (88,1); % Cross-correlation function
        filenamex= filecontent(k).name;     % LOAD THE X-SPIKE TRAIN
        elx= filenamex(end-5:end-4);        % Electrode name for x-spike train
        load (filenamex);                   % The vector'peak_train' is loaded
        if  (~exist('artifact','var') | isempty(artifact) | artifact==0) % CHECK FOR ARTIFACT
            % DO NOTHING
        else% If I have a file of electrical stim
            for p=1:length(artifact) % Cancel the artifacts
                peak_train(artifact(p):(artifact(p)+cancwin-1))= zeros(cancwin,1);
            end
        end
        input_train=peak_train;
        clear p peak_train filenamex foldername  % Free the memory
        %%
        for j=first:numfiles
            filenamey = filecontent(j).name;    % LOAD THE Y-SPIKE TRAIN
            ely= filenamey(end-5:end-4);        % Electrode name for y-spike train
            load (filenamey);                   % The vector'peak_train' is loaded
            if  (~exist('artifact','var') | isempty(artifact) | artifact==0) % CHECK FOR ARTIFACT
                % DO NOTHING
            else% If I have a file of electrical stim
                for p=1:length(artifact) % Cancel the artifacts
                    peak_train(artifact(p):(artifact(p)+cancwin-1))= zeros(cancwin,1);
                end
            end
            output_train=peak_train;
            clear p peak_train filenamey  % Free the memory
            [r]= crosscorrelogram2 (input_train, output_train, window, binsize, fs, normid);
            r_table{str2double(ely),1} = r;
        end
        %%
        % --------------> SAVING PHASE
        cd (corr_folder)
        enddir=dir;
        numenddir=length(enddir);
        corrdir=strcat('Correlogram_', finalfolder); % Name of the resulting directory
        if isempty(strmatch(corrdir, strvcat(enddir(1:numenddir).name),'exact')) % Check if the corrdir already exists
            mkdir (corrdir) % Make a new directory only if corrdir doesn't exist
        end
        cd (corrdir) % Go into the just created directory
        nome= strcat('r', finalfolder, '_', elx);
        save (nome, 'r_table')
        cd (current_dir);
        clear nome
    end
    cd(start_folder);
end