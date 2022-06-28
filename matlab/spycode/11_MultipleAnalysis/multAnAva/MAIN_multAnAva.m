% % MAIN_multAnAva.m
% % created by Valentina Pasquale - 26 April 2007

multAnAvaAnswer = 'OK';
% initialization of variable used to indicate the folders to be analised
experimentFolders = [];
% ask for the folder to start from (root folder)
userfolder = uigetdir(pwd,'Select the root folder');
% check the choice of the root folder
if strcmp(num2str(userfolder),'0')
    errordlg('Selection Failed - End of Session', 'Error');
    return
else %if the chosen folder exists
    while strcmpi(multAnAvaAnswer,'OK') && isempty(experimentFolders)
        % prompt a window for the insertion of the parameters and catch the
        % answer of the user ('Cancel' or 'OK'), the parameters inserted
        % and the handle of the window
        [multAnAvaParamWinHandle, multAnAvaAnswer, chosenParameters] = experimentParametersWindow(userfolder);
        % if the answer is 'Cancel' quit the window
        if strcmpi(multAnAvaAnswer, 'Cancel')
            delete(multAnAvaParamWinHandle);
            return
        else
            %close the window used for the choice
            delete(multAnAvaParamWinHandle);
            pause(0.5);
            % if the answer is 'OK' extract the list of folders names
            % fulfilling the conditions inserted by the user
            foldersList = extractFoldersNames(userfolder, chosenParameters);
            % if some folder has been found
            if ~isempty(foldersList)
                % extract from the list only the folders containing
                % subfolders in which are stored data on which analysis can
                % be performed
                experimentFolders = extractExperimentFoldersNames(foldersList);
                % if some folder has been found
                if ~isempty(experimentFolders)
                    % prompt the user with a window from which to choose the
                    % folders to analise
                    [outputExtFoldersChoiceWinHandles, answerExtFoldersChoiceWinHandles, experimentFolders]= extractedNamesChoiceWindow(experimentFolders);
                    % if the user confirmed the operation
                    if strcmpi(answerExtFoldersChoiceWinHandles, 'OK')
                        % prompt the window to use for the multiple
                        % analysis
                        [multAnAvaWinHand, multAnAvaWinAnswer,chosenParameters] = multAnAvaWindow;
                        % delete the window
                        delete(multAnAvaWinHand);
                        pause(0.5);
                        if strcmpi(multAnAvaWinAnswer, 'OK')
                            % parameters chosen
                            commonParameters = chosenParameters{1};
                            numFolders = size(experimentFolders,1);
                            for i = 1:numFolders
                                messageWaitWind = ['Please wait ... analising folder n. ' num2str(i) ' of ' num2str(numFolders)];
                                h = waitWindow(messageWaitWind);
                                actualFolder = deblank(char(experimentFolders(i,:)));
                                % aVa analysis
                                aVaParameters = chosenParameters{2};
                                if ~isempty(aVaParameters)
                                    if aVaParameters{1,2} == 1
                                        outputMessage = MAIN_multipleAva(actualFolder, commonParameters, aVaParameters);
                                    end
                                end
                                % aVaIEI Analysis
                                aVaIEIParameters = chosenParameters{3};
                                if ~isempty(aVaIEIParameters) 
                                    if aVaIEIParameters{1,2} == 1
                                        outputMessage = MAIN_multipleAvaIEI(actualFolder, commonParameters, aVaIEIParameters);
                                    end
                                end
                            end
                            experimentFolders=[];
                            multAnAvaAnswer='Cancel';
                            pause(0.5);
                            %close all
                            EndOfProcessing (userfolder, 'Successfully accomplished');
                        else
                            multAnAvaAnswer = questdlg('Press "OK" to re-insert conditions, press "Cancel" to abort operation','','OK','Cancel','OK');
                            experimentFolders = [];
                            continue
                        end
                    else
                        % if the user pressed "Cancel"
                        multAnAvaAnswer = questdlg('Press "OK" to re-insert conditions, press "Cancel" to abort operation','','OK','Cancel','OK');
                        experimentFolders = [];
                        continue
                    end
                else
                    % if no experiment folder matches the chosen conditions
                    h = warndlg(sprintf('No experiment folder matching the chosen conditions was found.\nTry again'),'!!warning!!');
                    % wait for user's answer
                    waitfor(h);
                    continue;
                end
            else
                % if no folder matches the chosen conditions
                h = warndlg(sprintf('No folder matching the chosen conditions was found.\nTry again'),'!!warning!!');
                % wait for user's answer
                waitfor(h);
                continue;
            end
        end
    end
end