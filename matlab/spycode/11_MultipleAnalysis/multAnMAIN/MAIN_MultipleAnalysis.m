%MAIN_MULTIPLEANALYSIS Summary of this function goes here
%   Detailed explanation goes here
% created by Luca Leonardo Bologna 18 February 2007
% initialization of variable used to catch the user's answer
% output file name (to be implemented later)
dt = datestr(now, 'yyyymmdd_HHMMSS');
%
mulAnWinAnswer='OK';
% initialization of variable used to indicate the folders to be analised
experimentFolders=[];
% ask for the folder to start from (root folder)
userfolder = uigetdir(pwd,'Select the root folder');
%   check the choice of the root folder
if  strcmp(num2str(userfolder),'0')
    errordlg('Selection Failed - End of Session', 'Error');
    return
else %if the chosen folder exists
    while strcmpi(mulAnWinAnswer,'OK') && isempty(experimentFolders)
        % prompt a window for the insertion of the parameters and catch the
        % answer of the user ('Cancel' or 'OK'), the parameters inserted
        % and the handle of the window
        [mulAnParamWinHandle,mulAnWinAnswer,chosenParameters]= experimentParametersWindow(userfolder);
        % if the answer is 'Cancel' quit the window
        if strcmpi(mulAnWinAnswer,'Cancel')
            delete (mulAnParamWinHandle);
            return
        else
            %close the window used for the choice
            delete(mulAnParamWinHandle);
%             pause(0.5);
            % if the answer is 'OK' extract the list of folders names
            % fulfilling the conditions inserted by the user
            foldersList=extractFoldersNames(userfolder,chosenParameters);
            % if some folder has been found
            if ~isempty(foldersList)
                % extract from the list only the folders containing
                % subfolders in which are stored data on which analysis can
                % be performed
                experimentFolders=extractExperimentFoldersNames(foldersList);
                %if some folder has been found
                if ~isempty(experimentFolders)
                    % prompt the user with a window from which to choose the
                    % folders to analise
                    [outputExtFoldersChoiceWinHandles,answerExtFoldersChoiceWinHandles,experimentFolders]= extractedNamesChoiceWindow(experimentFolders);
                    % if the user confirmed the operation
                    if strcmpi(answerExtFoldersChoiceWinHandles,'OK')
                        % prompt the window to use for the multiple
                        % analysis
                        [mulAnWindHand,mulAnWindAnswer,chosenParameters]= multipleAnalysisWindow;
                        %delete the window
                        delete (mulAnWindHand);
                        pause(0.5);
                        if strcmpi(mulAnWindAnswer,'OK')
                            % parameters chosen
                            commonParameters=chosenParameters{1};
                            numFolders=size(experimentFolders,1);
                            for i=1:numFolders
                                messageWaitWind=['Please wait ... analising folder n. ' num2str(i) ' of ' num2str(numFolders)];
                                h=waitWindow(messageWaitWind);
                                actualFolder=deblank(char(experimentFolders(i,:)));
                                
                                % Peak Detection
                                peakDetectionParameters=chosenParameters{2};
                                if peakDetectionParameters{1,2}==1;
                                    outputMessage=MAIN_multAnPeakDetection_autThCompRTSD(actualFolder,commonParameters,peakDetectionParameters);
                                end
                                
                                % Plot
                                plotParameters=chosenParameters{3};
                                if plotParameters{1,2}==1;
                                    outputMessage=MAIN_multAnPlot(actualFolder,commonParameters,plotParameters);
                                end
                                
                                %PSTH
                                psthParameters=chosenParameters{4};
                                if psthParameters{1,2}==1;
                                    outputMessage=MAIN_multAnPsth(actualFolder,commonParameters,psthParameters);
                                end
                                
                                %Spike Analysis
                                spikeAnalysisParameters=chosenParameters{5};
                                if spikeAnalysisParameters{1,2}==1;
                                    outputMessage=MAIN_multAnSpikeAnalysis(actualFolder,commonParameters,spikeAnalysisParameters);
                                end
                                
                                %Burst Analysis
                                burstAnalysisParameters=chosenParameters{6};
                                if burstAnalysisParameters{1,2}==1;
                                    outputMessage=MAIN_multAnBurstAnalysis(actualFolder,commonParameters,burstAnalysisParameters);
                                end
                                
                                %Cross-Correlogram
                                cCorrParameters=chosenParameters{7};
                                if cCorrParameters{1,2}==1;
                                    outputMessage=MAIN_multAnCrossCorrelation(actualFolder,commonParameters,cCorrParameters);
                                end
                            end
                            experimentFolders=[];
                            mulAnWinAnswer='Cancel';
                            pause(0.5);
                            %close all
                            EndOfProcessing (userfolder, 'Successfully accomplished');
                        else
                            mulAnWinAnswer = questdlg('Press "OK" to re-insert conditions, press "Cancel" to abort operation','','OK','Cancel','OK');
                            experimentFolders=[];
                            continue
                        end
                    else
                        % if the user pressed "Cancel"
                        mulAnWinAnswer = questdlg('Press "OK" to re-insert conditions, press "Cancel" to abort operation','','OK','Cancel','OK');
                        experimentFolders=[];
                        continue
                    end
                else
                    % if no experiment folder matches the chosen conditions
                    h=warndlg(sprintf('No experiment folder matching the chosen conditions was found.\nTry again'),'!!warning!!');
                    %wait for user's answer
                    waitfor(h);
                    continue;
                end
            else
                % if no folder matches the chosen conditions
                h=warndlg(sprintf('No folder matching the chosen conditions was found.\nTry again'),'!!warning!!');
                %wait for user's answer
                waitfor(h);
                continue;
            end
        end
    end
end
