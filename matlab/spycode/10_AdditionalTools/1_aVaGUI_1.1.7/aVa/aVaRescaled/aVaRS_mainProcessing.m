function [histogramAvalancheSize1Clust, histogramAvalancheSize2Clust, histogramAvalancheLifetimeClust, branchParam, branchMean, branchSTD, branchSTE] = aVaRS_mainProcessing(path, results_folder, binWidth, fs, numberOfSamples)

cd(path)                % it should be the path of the PeakDetection Folder
[binSamplesWidth, numberOfBins, remainder] = aVa_convert2SamplesNumber(binWidth, fs, numberOfSamples);

numberOfRescaling = 5;
% Rescaling considering 1/4 of the MEA (the 4 different corners), 1/2 (4 different halves - right, left, up, down)
% of the MEA
lookuptable = cell(numberOfRescaling,1);
clusterCode = cell(numberOfRescaling,1);
% right half & left half
lookuptable{1,1} = [(11:18)'; (21:28)'; (31:38)'; (41:48)'; ... % left half
                    (51:58)'; (61:68)'; (71:78)'; (81:88)'];    % right half
% upper half & lower half
lookuptable{2,1} = [(11:14)'; (21:24)'; (31:34)'; (41:44)'; (51:54)'; (61:64)'; (71:74)'; (81:84)'; ... % upper half
                    (15:18)'; (25:28)'; (35:38)'; (45:48)'; (55:58)'; (65:68)'; (75:78)'; (85:88)'];    % lower half
% 4 corners
lookuptable{3,1} = [(11:14)'; (21:24)'; (31:34)'; (41:44)';... % upper left corner
                    (51:54)'; (61:64)'; (71:74)'; (81:84)';... % upper right corner
                    (15:18)'; (25:28)'; (35:38)'; (45:48)';... % lower left corner
                    (55:58)'; (65:68)'; (75:78)'; (85:88)'];   % lower right corner
% spacing 400 um --> 4 different patterns
lookuptable{4,1} = [(11:2:17)'; (31:2:37)'; (51:2:57)'; (71:2:77)';
                    (21:2:27)'; (41:2:47)'; (61:2:67)'; (81:2:87)';
                    (12:2:18)'; (32:2:38)'; (52:2:58)'; (72:2:78)';
                    (22:2:28)'; (42:2:48)'; (62:2:68)'; (81:2:88)'];
% spacing 600 um --> 4 (out of 8) different patterns
lookuptable{5,1} = [(11:3:17)'; (41:3:47)'; (71:3:77)';
                    (21:3:27)'; (51:3:57)'; (81:3:87)';
                    (12:3:18)'; (42:3:48)'; (72:3:78)';
                    (21:3:28)'; (52:3:58)'; (82:3:88)'];
% defining number of cluster                      
clusterCode{1,1} = [ones(1,32)'; (ones(1,32)'*2)];
clusterCode{2,1} = [ones(1,32)'; (ones(1,32)'*2)];
clusterCode{3,1} = [ones(1,16)'; (ones(1,16)'*2); (ones(1,16)'*3); (ones(1,16)'*4)];
clusterCode{4,1} = [ones(1,16)'; (ones(1,16)'*2); (ones(1,16)'*3); (ones(1,16)'*4)];
clusterCode{5,1} = [ones(1,9)'; (ones(1,9)'*2); (ones(1,9)'*3); (ones(1,9)'*4)];

for i = 1:numberOfRescaling
    lookuptable{i,1} = [(1:length(lookuptable{i,1}))', clusterCode{i,1}, lookuptable{i,1}];
    [orderedElectrodes, indices] = sort(lookuptable{i,1}(:,3));
    clusters = lookuptable{i,1}(indices,2);
    lookuptable{i,1} = [(1:length(lookuptable{i,1}))', clusters, orderedElectrodes];
    clear orderedElectrodes indices clusters
end
clear clusterCode i
% lookuptable{i,1} content:
% 1st column: numbers of electrodes (1,2,3,4,...64)
% 2nd column: correspondent cluster (1,2...)
% 3rd column: numbers of electrodes (11,13,14,...88)

% matrix parameters
numberOfElectrodes = 64;                        % --> DA CORREGGERE
numberOfClusters = [2 2 4 4 4]';
numberOfElectrodesPerCluster = [32 32 16 16 8]';
% matrix of the activity of all the electrodes
overallActivity = sparse(numberOfSamples, numberOfElectrodes);
% cell arrays to save info for every cluster (and for every table)
histogramAvalancheSize1Clust = cell(numberOfRescaling,1);
histogramAvalancheSize2Clust = cell(numberOfRescaling,1);
histogramAvalancheLifetimeClust = cell(numberOfRescaling,1);
branchParam = cell(numberOfRescaling,1);
allAvalanches = cell(numberOfRescaling,1);
branchMean = [];
branchSTD = [];
branchSTE = [];
z = [];
for i = 1:numberOfRescaling
    for j = 1:numberOfClusters(i,1)
        histogramAvalancheSize1Clust{i,j} = zeros(1,10000);                                % histogram of avalanches size (version 1)
        histogramAvalancheSize2Clust{i,j} = zeros(1,numberOfElectrodesPerCluster(i,1));    % histogram of avalanches size (version 2)
        histogramAvalancheLifetimeClust{i,j} = zeros(1,1000);                              % histogram of avalanches lifetime (version 2)
        branchParam{i,j} = [];                                                             % branching parameter array
        z(i,j) = 1;                                                                        % counter of the avalanches
        allAvalanches{i,j} = cell(1,1);
        branchMean(i,j) = 0;
        branchSTD(i,j) = 0;
        branchSTE(i,j) = 0;
    end
end
clear i j
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
    for s = 1:numberOfRescaling
        for n = 1:numberOfClusters(s,1)      % FOR every cluster
            active = 0;                                   % active = 0 if no electrode is active in a window
            electrodes = zeros(1,numberOfElectrodesPerCluster(s,1));     % electrodes' vector
            spikes = zeros(1,numberOfElectrodesPerCluster(s,1));         % spikes' vector
            firstBin = 0;                                 % bin at which an ava starts
            lastBin = 0;                                  % bin at which an ava ends
            j = 0;                                        % counter of the windows
            asc = 0;                                      % number of ascendants (in the first bin of an ava)
            desc = 0;                                     % number of descendants (in the second bin of an ava)
            first = 0;                                    % flag for the first bin of an avalanche
            aVaStruct = struct('firstBin',0,'lastBin',0,'sigma',0,'pattern',zeros(1,numberOfElectrodesPerCluster(s,1)),'size1',0,'size2',0,'lifetime',0);
            % structure where I save all the parameters of an avalanche
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
            activityFor1Cluster = overallActivity(:,lookuptable{s,1}((lookuptable{s,1}(:,2)==n),1));
            for t =(binSamplesWidth+1):binSamplesWidth:(numberOfSamples-remainder)   % FOR cycle on the single window
                % ciascuna finestra va da (t-binSamplesWidth) a (t-1)
                j = j+1;
                [r, c] = find(activityFor1Cluster((t-binSamplesWidth):(t-1),:));    % finds nonzero elements
                if(isempty(c))           % current bin is empty
                    if(active)      % last bin was not empty --> END OF AN AVA
                        aVaStruct.size2 = length(find(electrodes));                                    % counts number of active electrodes
                        histogramAvalancheSize2Clust{s,n}(aVaStruct.size2) = histogramAvalancheSize2Clust{s,n}(aVaStruct.size2) + 1; % increments the histogram
                        aVaStruct.size1 = sum(spikes);                                                 % counts the total number of spikes
                        histogramAvalancheSize1Clust{s,n}(aVaStruct.size1) = histogramAvalancheSize1Clust{s,n}(aVaStruct.size1) + 1; % increments the histogram
                        aVaStruct.lastBin = j-1;                                                                % saves the lastBin
                        aVaStruct.lifetime = (aVaStruct.lastBin - aVaStruct.firstBin)+1;                                              % computes lifetime
                        histogramAvalancheLifetimeClust{s,n}(aVaStruct.lifetime) = histogramAvalancheLifetimeClust{s,n}(aVaStruct.lifetime) + 1;    % increments the histogram
                        if(first)       % this is the case of an avalanche of one bin
                            aVaStruct.sigma = 0;
                        end
                        branchParam{s,n}(z(s,n)) = aVaStruct.sigma;
                        allAvalanches{s,n}{z(s,n),1} = aVaStruct;
                        % re-initializes variables
                        first = 0;
                        asc = 0;
                        desc = 0;
                        electrodes = zeros(1,numberOfElectrodesPerCluster(s,1));     % electrodes' vector
                        spikes = zeros(1,numberOfElectrodesPerCluster(s,1));         % spikes' vector
                        aVaStruct.pattern = zeros(1,numberOfElectrodesPerCluster(s,1));
                        z(s,n) = z(s,n)+1;                    % increments the counter of the avalanches
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
            branchParam{s,n} = branchParam{s,n}(find(branchParam{s,n}));
            branchMean(s,n) = mean(branchParam{s,n});
            branchSTD(s,n) = std(branchParam{s,n});
            branchSTE(s,n) = stderror(branchMean(s,n), branchParam{s,n});
        end
    end
    cd(results_folder)
    filename = 'avalanches';
    save(filename,'allAvalanches')
    cd(path);
end