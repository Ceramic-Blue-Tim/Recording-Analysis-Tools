function [] = plotraster(start_folder, end_folder, fs, starttime, endtime, startend)
%       start_folder = complete path of the folder containing the data to display
%       end_folder   = complete path for the final folder
%       fs           = sampling frequency [#samples/sec]
%       starttime    = beginning of the raster - time displayed [# samples]
%       endtime      = end of the raster - time displayed [# samples]
%       startend     = strcat(starttime/fs, '-', endtime/fs, 'sec'); [char]

% by M. Chiappalone (15 febbraio 2006)
% BUG on the length of the output files (endtime not updated for all the
% experimental phases) - Corrected by M. Chiappalone (January 16, 2009)

%% initialize
% first = 3; %avoid '.' and '..'
% dispwarn=0;
% cd(start_folder)
[~,~,peakfolderdir] = dirr(start_folder,'name','isdir','0');
% peakfolderdir = dirr(start_folder);    % Struct containing the peak-det folders
NumPeakFolder = length(peakfolderdir); % Number of experimental phases

%% create figure
scrsz = get(0,'ScreenSize');
fh = figure('Position',[1+100 scrsz(1)+100 scrsz(3)-200 scrsz(4)-200]);
set(gcf,'Color','w')
xlabel('Time [sec]')
ylabel('Electrode')
grid on; hold on

%% loop through files and plot
for f = 1:NumPeakFolder            % FOR cycle on the phase directories
%     cd(peakfolderdir(f).name)
    [~,~,phasefiles] = dirr(peakfolderdir{f},'name','isdir','0');
    numphasefiles = length(phasefiles);
    figure(fh)
    cla %clean graph
    evector = []; %vector with electrode numbers
    spkTs = [];
    spkLabel = [];
    for i = 1:numphasefiles
        load(phasefiles{i});     % peak_train and artifact are loaded
        electrode = str2double(phasefiles{i}(end-5:end-4));
        evector = [evector; electrode];
        spiketimes = find(peak_train(starttime:end))+starttime;
        nspkTsCurElec = length(spiketimes);
        spkTs = [spkTs; spiketimes(:)];
        spkLabel = [spkLabel; i.*ones(nspkTsCurElec,1)];
    end
    if ~isempty(spkTs)
        spkTs_s = spkTs/fs;
        plot(spkTs_s, spkLabel,'b.','MarkerSize',12);
    end
    if starttime > length(peak_train)
        disp(['for data in folder: ' peakfolderdir(f).name ' the starttime longer than filelength! Empty plot produced'])
    else
        if endtime<0 %automatic endtime depends on filelength
            xlim([starttime/fs length(peak_train)/fs])
        else %endtime is specified
            xlim([starttime/fs endtime/fs])
        end
    end
    
    set(gca,'ytick',1:numphasefiles,'yticklabel',num2str(evector),'ylim',[1 numphasefiles]);
    [~,phasename] = fileparts(peakfolderdir{f});
%     cd(end_folder)
    saveas(gcf,strcat(end_folder,filesep,'Raster_', startend, '_', phasename,'.fig'),'fig')
    saveas(gcf,strcat(end_folder,filesep,'Raster_', startend, '_', phasename,'.jpg'),'jpg')
%     cd(start_folder)
end
end