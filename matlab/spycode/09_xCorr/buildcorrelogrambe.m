function []= buildcorrelogrambe (start_folder, corr_folder, window, binsize, cancwin, fs, normid)
% buildcorrelogrambe.m
% Function for building the cross-correlation functions
% INPUT:
%          start_folder = folder containing the Peak Detection files
%          corr_folder  = folder containing the cross-correlation files
%          window       = window for computing the cross-correlogram
%          binsize      = bin dimension within the correlogram window
%          cancwin      = window for deleting the artifact
%          fs           = sampling frequency
%          normid       = normalization procedure
% by Michela Chiappalone (6 Maggio 2005, 16 Febbraio 2007)
%  modified by Luca Leonardo Bologna (11 June 2007)
%   - in order to handle the 64 channels of the MED64 Panasonic system

first= 3;
% mcmea_electrodes = [(12:17)'; (21:28)'; (31:38)'; (41:48)'; (51:58)'; (61:68)'; (71:78)';(82:87)'];
mcmea_electrodes = GlobalsParams.DEFAULT_ELECTRODES_LAYOUT;
elNum=64;

cd (start_folder)
sourcedir= dir;      % Names of the elements in the start_folder directory - struct array
numdir= length(dir); % Number of elements in the start_folder directory

for i = first:numdir              % Cycle over the files
    filename = sourcedir(i).name  % Cell array containing the burst_event trains
    finalfolder=filename(13:end-4);
    load(filename)                % burst_event_cell is loaded
    if length(burst_event_cell)==87 %added for compatibility with previous versions of SM
        burst_event_cell(end+1)=[];
    end

    % --------------> COMPUTATION PHASE: CROSS_CORRELATION
    for k=1:elNum
        r_table= cell (88,1); % Cross-correlation function
        elx=mcmea_electrodes(k,1);             % Electrode name for x-spike train
        input_train= burst_event_cell{elx,1};

        for j=1:elNum
            ely= mcmea_electrodes(j,1);        % Electrode name for y-spike train
            output_train=burst_event_cell{ely,1};
            [r]= crosscorrelogram2 (input_train, output_train, window, binsize, fs, normid);
            r_table{ely,1} = r;
        end

        % --------------> SAVING PHASE
        cd (corr_folder)
        enddir=dir;
        numenddir=length(enddir);
        corrdir=strcat('CCorrBE_', finalfolder); % Name of the resulting directory
        if isempty(strmatch(corrdir, strvcat(enddir(1:numenddir).name),'exact')) % Check if the corrdir already exists
            mkdir (corrdir) % Make a new directory only if corrdir doesn't exist
        end
        cd (corrdir) % Go into the just created directory
        nome= strcat('r', finalfolder, '_', num2str(elx));
        save (nome, 'r_table')
        clear nome
    end
    cd(start_folder);
end
