% salpa_main.m 
% created by Valentina Pasquale, 21 January 2009
% initialization of variable used to catch the user's answer
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
            delete (mulAnParamWinHandle);
            pause(0.5);
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
%                         [mulAnWindHand,mulAnWindAnswer,chosenParameters]= multipleAnalysisWindow;
                        [filterParam, flag] = salpa_getParam();
%                         %delete the window
%                         delete (mulAnWindHand);
                        pause(0.5);
                        if flag
%                             % parameters chosen
%                             commonParameters=chosenParameters{1};
                            numFolders=size(experimentFolders,1);
                            for i=1:numFolders
                                messageWaitWind=['Please wait ... analising folder n. ' num2str(i) ' of ' num2str(numFolders)];
                                hww = waitWindow(messageWaitWind);
                                actualFolder=deblank(char(experimentFolders(i,:)));
                                % output folder
                                [saveFolderName, successFlag] = createResultFolderNoUserQuestion(actualFolder, 'FilteredData');
                                [saveSubfolderName, successFlag2] = createResultFolderNoUserQuestion(saveFolderName, 'Mat_Files');
                                if ~successFlag
                                    errordlg('Error creating output folder!','!!Error!!')
                                    return
                                end
                                outputMessage = salpa_comput(actualFolder,saveSubfolderName,filterParam);
                                if ~outputMessage
                                    errordlg('Error computing filtering!','!!Error!!')
                                    return
                                end
                            end
                            experimentFolders=[];
                            mulAnWinAnswer='Cancel';
                            pause(0.5);
                            %close all
%                             delete(hww)
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