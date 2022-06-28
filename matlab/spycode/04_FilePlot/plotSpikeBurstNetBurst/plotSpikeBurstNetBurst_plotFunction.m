function [success] = plotSpikeBurstNetBurst_plotFunction(PDFolder, BDFolder, NBFolder, saveFolderName, userParam)
% BUG in Matlab 7.0.1 --> function 'subplot' does not work properly
% It is necessary to use the property 'align' within subplot to allow a
% correct visualization of the rasters [15 Febbraio 2006]
% subplot(NFiles, 1, (i-2), 'align')

% by M. Chiappalone (15 febbraio 2006)
% modified by V. Pasquale, October 2008
% %%%%%%%%%%%%%
fs=userParam.sf;
endSample = userParam.endTime*userParam.sf;
startSample = userParam.startTime*userParam.sf;
% %%%%%%%%%%%%%
trialFolders = dirr(PDFolder);
trialFolderNames = {trialFolders.name};
numTrials = length(trialFolders);
% %%%%%%%%%%%%%
BDTrialFiles = dirr(BDFolder);
BDTrialFilenames = {BDTrialFiles.name};
% BDTrialFilenames = BDTrialFilenames(cellfun('isempty',strfind(BDTrialFilenames,'parameters')));
% %%%%%%%%%%%%%
NBTrialFiles = dirr(NBFolder);
NBTrialFilenames = {NBTrialFiles.name};
NBTrialFilenames = NBTrialFilenames(cellfun('isempty',strfind(NBTrialFilenames,'parameters')));
% %%%%%%%%%%%%%
MEA60_elec = [(12:17)'; (21:28)'; (31:38)'; (41:48)'; (51:58)'; (61:68)'; (71:78)';(82:87)'];
% %%%%%%%%%%%%%
for f = 1:numTrials      % FOR cycle on the phase directories
    % %%%%%%%
    scrsz = get(0,'ScreenSize');
    hFig = figure('Position',[1+100 scrsz(1)+100 scrsz(3)-200 scrsz(4)-200]);
    set(gcf,'Color','w')
    % %%%%%%%
    evector = [];
    curTrialFolderName = fullfile(PDFolder,trialFolderNames{f});
    PDFiles = dirr(curTrialFolderName);
    PDFileNames = {PDFiles.name};
    %     PDFileNames = PDFileNames(~cellfun('isempty',regexp(PDFileNames,['_',num2str(userParam.col),'\d.mat'])));
    numElectrodes = length(PDFiles);
    load(fullfile(BDFolder,BDTrialFilenames{f}))
    %     load(fullfile(NBFolder,NBTrialFilenames{f}))
     
    for i = 1:numElectrodes
        load(fullfile(curTrialFolderName,PDFileNames{i}));     % peak_train and artifact are loaded
        elecNumber_string = PDFileNames{i}(end-5:end-4);
        evector = [evector; str2double(elecNumber_string)];
        if (~isempty(peak_train))
            %if (length(peak_train) < endSample)
                endSample = length(peak_train);
            %end
            realspiketimes = find(peak_train(startSample+1:endSample));
            realspiketimes = (realspiketimes+startSample)/userParam.sf; % correct X-scale [sec]
            % ???????
            spiketimes = [realspiketimes; userParam.endTime+10; userParam.endTime+11];
            % To avoid 0 or 1 spikes - at least two that will not be displayed
            % RASTER PLOT PROCESSING
            %             subplot(numElectrodes, 1, i, 'align')
            subplot(numElectrodes+1, 1, i, 'align')
            raster = bar(spiketimes, sign(spiketimes), 0.001, 'b');     % Raster Plot
            hold on
            set(raster,'EdgeColor',[0.3 0.3 0.3]);                                % Lines are blue
            %axis([userParam.startTime userParam.endTime 0.001 1.5]); % Only the time frame selected
            if userParam.endTime<0 %automatic endtime depends on filelength
            axis([userParam.startTime length(peak_train)/fs 0.001 1.5])
            else %endtime is specified
            axis([userParam.startTime userParam.endTime 0.001 1.5])
            end
            box off;
           
            %             for k = 1:size(netBursts,1)
            %                 startNB = (netBursts(k,1))/userParam.sf;
            %                 endNB = (netBursts(k,2))/userParam.sf;
            %                 line([startNB startNB],[0 0.5],'Color','g')
            %                 line([endNB endNB],[0 0.5],'Color','r')
            %             end
            space = round((60-userParam.startTime)/10); % I verified that it is ok this space
            %text((userParam.startTime-space), 0.25, elecNumber_string, 'FontSize', 5, 'FontWeight', 'bold');
            
            set(gca,'ytick',1,'yticklabel',elecNumber_string);
            set(gca,'XColor','w');
%             set(gca,'XTick',[]);
            % %%%%%%%%%%
            if ~isempty(burst_detection_cell{str2double(elecNumber_string)})
                burstTrain = burst_detection_cell{str2double(elecNumber_string)}(1:end-1,1:3);
                burst2plot = (burstTrain(:,1)>=startSample) & (burstTrain(:,2)<=endSample);
                burstTrain = burstTrain(burst2plot,:);
                for j = 1:size(burstTrain,1)
                    line(burstTrain(j,1:2)./userParam.sf,[1.3 1.3],'Color','k','LineWidth',1)
                end
            end
        end
    end
    
    % %%%%%%%%%%%%
    load(fullfile(NBFolder,NBTrialFilenames{f}))
       % subplot(numElectrodes, 1, numElectrodes, 'align')
    if ~isempty(netBursts)
        subplot(numElectrodes+1, 1, numElectrodes+1, 'align')
        NB = find((netBursts(:,1)>=startSample & netBursts(:,1)<=endSample) & ...
            (netBursts(:,2)>=startSample & netBursts(:,2)<=endSample));
        if (~isempty(NB))
            temp = [];
            temp(netBursts(NB,1)-startSample) = 1;
            temp(netBursts(NB,2)-startSample) = -1;
            NBTrain = cumsum(temp)';
            NBTrain2 = padarray(NBTrain,(endSample-startSample)-length(NBTrain),'post');
            plot((startSample+1:1:endSample)./userParam.sf,NBTrain2,'r','LineWidth',1.5)
            box off
            axis on
            %axis([userParam.startTime userParam.endTime 0 1.5]);

             if userParam.endTime<0 %automatic endtime depends on filelength
            axis([userParam.startTime length(peak_train)/fs 0.001 1.5])
            else %endtime is specified
            axis([userParam.startTime userParam.endTime 0.001 1.5])
            end
%set(gca,'XColor','w');
            set(gca,'YColor','w');
            set(gca,'YTick',[]);
            xlabel('Time [sec]')
%             for z = 1:length(NB)
%                 for k = 1:length(netBurstsPattern{NB(z)})
%                     numPlot = find(MEA60_elec == netBurstsPattern{NB(z)}(k,1));
%                     subplot(numElectrodes+1, 1, numPlot, 'align')
%                     hold on
%                     line([netBurstsPattern{NB(z)}(k,2)/userParam.sf netBurstsPattern{NB(z)}(k,2)/userParam.sf],...
%                         [0 1],'Color','r','LineWidth',1)
%                 end
%             end
        else
            subplot(numElectrodes+1, 1, numElectrodes+1, 'align')
            plot((startSample+1:1:endSample)./userParam.sf,...
                zeros(endSample-startSample,1),'r','LineWidth',1)
            %axis([userParam.startTime userParam.endTime 0 1.5]);
             if userParam.endTime<0 %automatic endtime depends on filelength
            axis([userParam.startTime length(peak_train)/fs 0.001 1.5])
            else %endtime is specified
            axis([userParam.startTime userParam.endTime 0.001 1.5])
            end
            box off
            axis on
            set(gca,'YColor','w');
            set(gca,'YTick',[]);
            xlabel('Time [sec]')
        end
    else
        subplot(numElectrodes+1, 1, numElectrodes+1, 'align')
        plot((startSample+1:1:endSample)./userParam.sf,...
            zeros(endSample-startSample,1),'r','LineWidth',1.5)
        %axis([userParam.startTime userParam.endTime 0 1.5]);
         if userParam.endTime<0 %automatic endtime depends on filelength
            axis([userParam.startTime length(peak_train)/fs 0.001 1.5])
            else %endtime is specified
            axis([userParam.startTime userParam.endTime 0.001 1.5])
        end
        box off
        axis on
        set(gca,'YColor','w');
        set(gca,'YTick',[]);
        xlabel('Time [sec]')
    end
    
   
    
    nameFigure_fig = fullfile(saveFolderName,strcat('Raster_', trialFolderNames{f}, '.fig'));
    nameFigure_jpg = fullfile(saveFolderName,strcat('Raster_', trialFolderNames{f}, '.jpg'));
%     nameFigure_tif = fullfile(saveFolderName,strcat('Raster_', trialFolderNames{f}, '.tif'));
    try
        saveas(hFig, nameFigure_fig,'fig'); % Matlab Figure file
        saveas(hFig, nameFigure_jpg,'jpg');   % JPEG format
%         print(['-f',num2str(hFig)],'-r1200','-dtiff', nameFigure_tif)
        success = 1;
    catch
        success = 0;
        errorStr = lasterror;
        errordlg(errorStr.message,errorStr.identifier)
    end
    %close all
end