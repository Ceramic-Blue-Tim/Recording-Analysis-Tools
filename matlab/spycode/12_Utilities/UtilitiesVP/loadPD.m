% loadPD.m
% Loads the peak trains of a single trial (output of the spike detection
% algorithm); returns a matrix numberOfSamples x numberOfElectrodes that
% contains all the peak trains of a single trial
function [peakTrns] = loadPD(trialFolder, cancwinsample)
startFolder = pwd;
numberOfSamples = getSamplesNumber(trialFolder);
numberOfElectrodes = getElectrodesNumber(trialFolder);
peakTrns = sparse(numberOfSamples, numberOfElectrodes);   % matrix of the activity of all the electrodes
cd(trialFolder)
files = dirr;
h = waitbar(0,'Loading data...');
% loading data
for k = 1:numberOfElectrodes
    load(files(k).name);
    % first row contains the numbers of electrodes
    peakTrns(1,k) = str2double(files(k).name(end-5:end-4));     % current electrode (double) --> 1 - 99
    % if sum(peak_train) > 0        % if there is at least one spike
        if (sum(artifact) > 0)  % if artifact exists
            peak_train = delartcontr(peak_train, artifact, cancwinsample); % Delete the artifact contribution
        end
        peakTrns(2:numberOfSamples+1,k) = peak_train(1:numberOfSamples);
        clear peak_train artifact
        waitbar(k/numberOfElectrodes)
%     else
%         continue
%     end
end
close(h)
cd(startFolder)