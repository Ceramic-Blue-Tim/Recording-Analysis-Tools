function multAnBurAnPlotHistPercRandSpikes(start_folder,end_folder)
% multAnBurAnPlotHistPercRandSpikes.m
% Plot histogram of percentage of random spikes (out burst) for a selected
% experiment
% --------- COMPUTATION PHASE ----------
elNum=64;
cd(start_folder)
files = dir;
numfiles = length(dir);
percRandSpikes = zeros(elNum,1);
n = 0;
for i = 3:numfiles          % Cycle over the files (one for each phase)
    if (~strcmp(files(i).name(end-2:end), 'txt')) % select only mat files and discard txt files
        load(files(i).name)
        n = n+1;        % counter of mat files
        filenames{n,1}=files(i).name;
        if (~isempty(SRMspike))
            percRandSpikes(:,n) = [SRMspike(:,5); -1*ones(elNum-size(SRMspike,1),1)];
        else
            return
        end
    end
end
[r,c] = find(percRandSpikes ~= -1);
percRandSpikes = percRandSpikes(min(r):max(r),:);
percRandSpikes(find(percRandSpikes == -1)) = 0;
% AllPercRandSpikes = mean(percRandSpikes,2);   % mean over the different phases
meanPercRandSpikes = mean(percRandSpikes,1);
stdPercRandSpikes = std(percRandSpikes, 0, 1);

% --------- PLOT PHASE -----------
x = 0:5:100;
for j = 1:size(percRandSpikes,2)
    scrsz = get(0,'ScreenSize');
    finalfig = figure('Position',[scrsz(3)/4 scrsz(4)/6 scrsz(3)/2 scrsz(4)/1.5]);
    hPercRandSpikes = histc(percRandSpikes(:,j), x);
    bar(x, hPercRandSpikes, 'histc')
    axis([0 100 0 ceil(max(hPercRandSpikes)/10)*10])
    xlabel('Percentage of random spikes')
    ylabel('Frequency')
    title(['Mean = ', num2str(meanPercRandSpikes(j)), ' Standard deviation = ', num2str(stdPercRandSpikes(j))]);

    % --------- SAVE PHASE -----------
    cd(end_folder)
    string = filenames{j,1};
    ind = findstr(string, '_');
    str = string(ind(1)+1:end-4);
    filename = strcat('histPercRandSpikes_',str);
    saveas(finalfig, filename, 'jpg')
end
cd(end_folder)
filename2 = 'percRandSpikes.txt';
percRandSpikes = percRandSpikes(:);
save(filename2,'percRandSpikes','-ASCII')
%close all