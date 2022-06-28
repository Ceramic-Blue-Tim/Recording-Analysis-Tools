function [histogramAvalancheSize1, histogramAvalancheSize2, histogramAvalancheLifetime, branchParam, avalanches] = aVa_mainProcessing(path, binWidth, fs, numberOfSamples)
% created by Valentina Pasquale (September 2006)
% aVa_mainProcessing detects the avalanches, calculates the avalanches distribution (size1, size2,
% lifetime) and branching parameter.
% Inputs:   path - it should be the path of the PeakDetection Folder
%           binWidth - integer variable specifying the bin width
%           fs - sampling frequency [Hz]
%           numberOfSamples - self-explaining
% Outputs:  histogramAvalancheSize1 - array of the avalanches size
%                                     distribution (size1: number of events)
%           histogramAvalancheSize2 - array of the avalanches size
%                                     distribution (size2: number of
%                                     electrodes)
%           histogramAvalancheLifetime - array of the avalanches lifetime
%                                        distribution (number of bins)
%           branchParam - array containing the branching parameters of all
%                         the avalanches detected
%           avalanches - a cell array of structures where I save all the parameters of each avalanche
% CONTENT:
%   firstBin:   bin at which an ava starts
%   lastBin:    bin at which an ava ends
%   sigma:      branching parameter
%   pattern:    an array 1*numberOfElectrodes that contains the
%               timestamps at which every electrode is activated for the first
%               time in the avalanche
%   size1:      size (1st definition: number of events)
%   size2:      size (2nd definition: number of electrodes)
%   lifetime:   duration (number of bins)
cd(path)                % it should be the path of the PeakDetection Folder
[binSamplesWidth, numberOfBins, remainder] = aVa_convert2SamplesNumber(binWidth, fs, numberOfSamples);
numberOfElectrodes = 64;
histogramAvalancheSize1 = zeros(1,20000);                % histogram of avalanches size (version 1)
histogramAvalancheSize2 = zeros(1,numberOfElectrodes);   % histogram of avalanches size (version 2)
histogramAvalancheLifetime = zeros(1,2000);              % histogram of avalanches lifetime (version 2)
branchParam = [];                                        % branching parameters
avalanches = cell(1);
z = 1;                                                   % counter of the avalanches
overallActivity = sparse(numberOfSamples, numberOfElectrodes);   % matrix of the activity of all the electrodes
% Nota: ipotizzo che la avalanche size (version 1) non sia maggiore di 20000, e
% la avalanche lifetime non sia maggiore di 2000 (numero di bin)
folders = dir;
num_folders = length(folders);                                                  
for i = 3:num_folders           % FOR cycle on the trial directories
    disp(['Trial ', num2str(i-2), '...'])
    cur_dir = folders(i).name;      % contiene nome della cartella relativa alla fase corrente
    cd(cur_dir);                    % mi sposto in quella cartella di lavoro 
    files = dir;
    num_files = length(files);
    disp('loading data...')
    % loading data
    for k = 3:num_files     % FOR cycle on the single directory files
        filename = files(k).name;              % current file
        load(filename);
        overallActivity(:,k-2) = peak_train(1:numberOfSamples);
        clear peak_train artifact       
    end
    % calculating avalanches distribution
    disp('Calculating avalanches distribution...')
    temp = zeros(numberOfElectrodes,1);
    active = 0;                                   % active = 0 if no electrode is active in a window
    j = 0;                                        % counter of the windows
%     asc = 0;                                      % number of ascendants (in the first bin of an ava)
%     desc = 0;                                     % number of descendants (in the second bin of an ava)
%     first = 0;                                    % flag for the first bin of an avalanche
    electrodes = zeros(1,numberOfElectrodes);     % electrodes' vector
    spikes = zeros(1,numberOfElectrodes);         % spikes' vector
    aVaStruct = struct('firstBin',0,'lastBin',0,'sigma1',0,'sigma3',0,'sigma4',0,'pattern',[],'size1',0,'size2',0,'lifetime',0);
    for t =(binSamplesWidth+1):binSamplesWidth:(numberOfSamples-remainder)   % FOR cycle on the single window
        % ciascuna finestra va da (t-binSamplesWidth) a (t-1)
        j = j+1;
        [r, c] = find(overallActivity((t-binSamplesWidth):(t-1),:));    % finds nonzero elements
        if(isempty(c))           % current bin is empty
            if(active)           % last bin was not empty --> END OF AN AVA
                aVaStruct.size2 = length(find(electrodes));                          % counts number of active electrodes
                histogramAvalancheSize2(aVaStruct.size2) = histogramAvalancheSize2(aVaStruct.size2) + 1; % increments the histogram
                aVaStruct.size1 = sum(spikes);                                       % counts the total number of spikes
                histogramAvalancheSize1(aVaStruct.size1) = histogramAvalancheSize1(aVaStruct.size1) + 1; % increments the histogram
                aVaStruct.lastBin = j-1;  % saves the lastBin                                   
                aVaStruct.lifetime = (aVaStruct.lastBin - aVaStruct.firstBin)+1;                                    % computes lifetime
                histogramAvalancheLifetime(aVaStruct.lifetime) = histogramAvalancheLifetime(aVaStruct.lifetime) + 1;    % increments the histogram
%                 if(first)       % this is the case of an avalanche of one bin
%                     aVaStruct.sigma = 0;
%                 end
                [aVaStruct.sigma1, aVaStruct.sigma3, aVaStruct.sigma4] = calcBranchParam2(aVaStruct.pattern);
                branchParam(z,1) = aVaStruct.sigma1;
                branchParam(z,2) = aVaStruct.sigma3;
                branchParam(z,3) = aVaStruct.sigma4;
                avalanches{z,1} = aVaStruct;
                % re-initializes variables
%                 first = 0;
%                 asc = 0;
%                 desc = 0;
                electrodes = zeros(1,numberOfElectrodes);                           
                spikes = zeros(1,numberOfElectrodes);                                
                aVaStruct.pattern = [];
                z = z+1;                    % increments the counter of the avalanches
            end
            active = 0;   % current bin is empty --> active = 0
        else              % current bin is not empty
%             if(first)        % this is the second bin of an avalanche
%                 desc = length(c);
%                 aVaStruct.sigma = desc/asc;
%                 first = 0;
%             end
            if(~active) % last bin was empty --> BEGIN OF AN AVA
                aVaStruct.firstBin = j;           % saves the firstBin
%                 asc = length(c);                  % during the first bin, it saves the number of ascendants
%                 first = 1;                        % flag for the first bin
            end
            % if the electrodes were already active, they would still
            % remain active (inside an ava)
            % if they were not active, they would become active
            % (begin of an ava)
            electrodes(c) = 1;
            spikes(c) = spikes(c) + 1;
            % aVaStruct.pattern(c(~aVaStruct.pattern(c)&1)) = (j-aVaStruct.firstBin)+1;  % CHI CAPISCE QUESTA ISTRUZIONE E' UN GENIO!
            temp(c) = 1;
            aVaStruct.pattern = [aVaStruct.pattern; temp];
            temp = zeros(numberOfElectrodes,1);
            active = 1;   % current bin is not empty --> active = 1
        end                
    end
    % branchParam = branchParam(branchParam~=0);
    cd(path);
end