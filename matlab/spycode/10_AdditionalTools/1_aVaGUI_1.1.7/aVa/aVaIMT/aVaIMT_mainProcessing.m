function [histogramAvalancheSize1Clust, histogramAvalancheSize2Clust, histogramAvalancheLifetimeClust, branchParam, branchMean, branchSTD, branchSTE] = aVaIMT_mainProcessing(path, results_folder, binWidth, fs, numberOfSamples)

cd(path)                % it should be the path of the PeakDetection Folder
[binSamplesWidth, numberOfBins, remainder] = aVa_convert2SamplesNumber(binWidth, fs, numberOfSamples);

lookuptable = [36; 37; 87; 33; 28; 77; 71; 22; 27; 38; 63; 62; ... % CLUSTER A
               58; 57; 56; 68; 45; 48; 47; 55; 67; 78; 46; 66; ... % CLUSTER B + channel B/A
               74; 84; 64; 73; 86; 75; 85; 83; 82; 72; 65; 76; ... % CLUSTER C + channel C/A
               42; 52; 41; 44; 61; 53; 51; 43; 31; 32; 54; 21; ... % CLUSTER D + channel D/A
               15; 14; 25; 16; 23; 34; 24; 35; 26; 17; 13; 12];    % CLUSTER E + channel E/A
cluster_code = [ones(1,12)'; (ones(1,12)'*2); (ones(1,12)'*3); (ones(1,12)'*4); ones(1,12)'*5];
lookuptable = [(1:60)', cluster_code, lookuptable];
[orderedElectrodes,indices] = sort(lookuptable(:,3));
clusters = lookuptable(indices,2);
lookuptable = [(1:60)', clusters, orderedElectrodes];
% lookuptable content:
% 1st column: numbers of electrodes (1,2,3,4,...60)
% 2nd column: correspondent cluster (1,2,3,4 or 5)
% 3rd column: numbers of electrodes (12,13,14,...87)

% matrix parameters
numberOfElectrodes = 60;
numberOfClusters = 5;
numberOfElectrodesPerCluster = 12;
% matrix of the activity of all the electrodes
overallActivity = sparse(numberOfSamples, numberOfElectrodes);

% cell arrays to save info for every cluster
for j = 1:numberOfClusters
    histogramAvalancheSize1Clust{j} = zeros(1,10000);                           % histogram of avalanches size (version 1)
    histogramAvalancheSize2Clust{j} = zeros(1,numberOfElectrodesPerCluster);    % histogram of avalanches size (version 2)
    histogramAvalancheLifetimeClust{j} = zeros(1,1000);                         % histogram of avalanches lifetime (version 2)
    branchParam{j} = [];    % branching parameter array
    allAvalanches{j} = [];
    branchMean(j) = []; 
    branchSTD(j) = []; 
    branchSTE(j) = []; 
    z(j) = [];
end

folders = dir;
num_folders = length(folders);                                                  
for i = 3:num_folders           % FOR cycle on the trial directories
    disp(['Trial ', num2str(i-2), '...'])
    cur_dir = folders(i).name;      % contiene nome della cartella relativa alla fase corrente
    cd(cur_dir);                    % mi sposto in quella cartella di lavoro 
    files = dir;
    num_files = length(files);
    disp('loading data...')
    for k = 3:num_files     % FOR cycle on the single directory files
        filename = files(k).name;              % current file
        load(filename);
        overallActivity(:,k-2) = peak_train(1:numberOfSamples);
        clear peak_train artifact       
    end
    disp('Calculating avalanches distribution...')
    for n = 1:numberOfClusters      % FOR every cluster
        active = 0;                                   % active = 0 if no electrode is active in a window
        electrodes = zeros(1,numberOfElectrodesPerCluster);     % electrodes' vector
        spikes = zeros(1,numberOfElectrodesPerCluster);         % spikes' vector
        firstBin = 0;                                 % bin at which an ava starts
        lastBin = 0;                                  % bin at which an ava ends
        j = 0;                                        % counter of the windows
        asc = 0;                                      % number of ascendants (in the first bin of an ava)
        desc = 0;                                     % number of descendants (in the second bin of an ava)
        first = 0;                                    % flag for the first bin of an avalanche
        aVaStruct = struct('firstBin',0,'lastBin',0,'sigma',0,'pattern',zeros(1,numberOfElectrodesPerCluster),'size1',0,'size2',0,'lifetime',0);
        % structure where I save all the parameters of an avalanche
        % CONTENT:
        %   firstBin:   bin at which an ava starts
        %   lastBin:    bin at which an ava ends
        %   sigma:      branching parameter
        %   pattern:    an array 1*numberOfElectrodesPerCluster that contains the
        %               timestamps at which every electrode is activated for the first
        %               time in the avalanche
        %   size1:      size (1st definition: number of events)
        %   size2:      size (2nd definition: number of electrodes)
        %   lifetime:   duration (number of bins)
        activityFor1Cluster = overallActivity(:,lookuptable((lookuptable(:,GlobalsParams.DEFAULT_LUT_SEL)==n),1));
        for t =(binSamplesWidth+1):binSamplesWidth:(numberOfSamples-remainder)   % FOR cycle on the single window
            % ciascuna finestra va da (t-binSamplesWidth) a (t-1)
            j = j+1;
            [r, c] = find(activityFor1Cluster((t-binSamplesWidth):(t-1),:));    % finds nonzero elements
            if(isempty(c))           % current bin is empty
                if(active)      % last bin was not empty --> END OF AN AVA
                    aVaStruct.size2 = length(find(electrodes));                                    % counts number of active electrodes
                    histogramAvalancheSize2Clust{n}(aVaStruct.size2) = histogramAvalancheSize2Clust{n}(aVaStruct.size2) + 1; % increments the histogram
                    aVaStruct.size1 = sum(spikes);                                                 % counts the total number of spikes
                    histogramAvalancheSize1Clust{n}(aVaStruct.size1) = histogramAvalancheSize1Clust{n}(aVaStruct.size1) + 1; % increments the histogram
                    aVaStruct.lastBin = j-1;                                                                % saves the lastBin                                   
                    aVaStruct.lifetime = (aVaStruct.lastBin - aVaStruct.firstBin)+1;                                              % computes lifetime
                    histogramAvalancheLifetimeClust{n}(aVaStruct.lifetime) = histogramAvalancheLifetimeClust{n}(aVaStruct.lifetime) + 1;    % increments the histogram
                    if(first)       % this is the case of an avalanche of one bin
                        aVaStruct.sigma = 0;
                    end
                    branchParam{n}(z(n)) = aVaStruct.sigma;
                    allAvalanches{z(n),1} = aVaStruct;
                    % re-initializes variables
                    first = 0;
                    asc = 0;
                    desc = 0;
                    electrodes = zeros(1,numberOfElectrodesPerCluster);                           
                    spikes = zeros(1,numberOfElectrodesPerCluster);                                
                    aVaStruct.pattern = zeros(1,numberOfElectrodesPerCluster);
                    z(n) = z(n)+1;                    % increments the counter of the avalanches
                end
                active = 0;   % current bin is empty --> active = 0
            else
                if(first)        % this is the second bin of an avalanche
                    desc = length(c);
                    aVaStruct.sigma = desc/asc;
                    first = 0;
                end
                if(~active) % last bin was empty --> BEGIN OF AN AVA
                    aVaStruct.firstBin = j;           % saves the firstBin
                    asc = length(c);                  % during the first bin, it saves the number of ascendants
                    first = 1;                        % flag for the first bin
                end
                electrodes(c) = 1;
                spikes(c) = spikes(c) + 1;
                aVaStruct.pattern(c(~aVaStruct.pattern(c)&1)) = (j-aVaStruct.firstBin)+1;  % CHI CAPISCE QUESTA ISTRUZIONE E' UN GENIO!
                active = 1;   % current bin is not empty --> active = 1
            end                
        end
        branchParam{n} = branchParam{n}(find(branchParam{n}));
        branchMean(n) = mean(branchParam{n});
        branchSTD(n) = std(branchParam{n});
        branchSTE(n) = stderror(branchMean(n), branchParam{n});
        cd(results_folder)
        filename = ['avalanches_cluster', num2str(n)];
        save(filename,'allAvalanches')
    end
    cd(path);
end

