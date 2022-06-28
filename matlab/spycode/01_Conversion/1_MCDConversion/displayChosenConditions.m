function [answer] = displayChosenConditions(chosenFolder,allMcdCheckboxValue, allFoldersRadiobuttonValue, allFilesRadiobuttonValue,...
    andFoldersEditString, orFoldersEditString, andFilesEditString, orFilesEditString)

% DISPLAYCHOSENCONDITIONS take as input arguments the parameters the user
% inserted in the parameters choice window and check them. If some choice
% is incoherent an error message is displayed and "Cancel" is returned as
% answer (just as if the user had chosen to abort the operation), otherwise
% user's choices are displayed in a further window and the answer to this
% window ("Cancel" or "OK") is returned
% created by Luca Leonardo Bologna 24 January 2007

% used to check errors on the choice of folders
wrongFolders=0;
% used to check errors on the choice of files
wrongFiles=0;
startMessage='You have chosen to convert';
% replace the file separator of the system "\" (or "/" depending on the
% system) with "\\" (or "//") in order to manage regular expression used
% later
if(ispc)
    chosenFolder=regexprep(chosenFolder,{strcat(filesep,filesep),strcat(filesep,'.')},{strcat(filesep,filesep,filesep),'.'});
end
% if the user chose to convert all files the application will find
if (allMcdCheckboxValue==1 || (allFoldersRadiobuttonValue==1 && allFilesRadiobuttonValue==1))
    messageString=sprintf(strcat(startMessage, ' all files contained in\n', chosenFolder, ...
        '\nand in its subfolders.\n\nPress ''OK '' to confirm your choice (the process could take a few minutes), press ''Cancel'' otherwise'));
    %confirmation window
    answer = questdlg(messageString,'','OK','Cancel','OK');
    pause(1);
    return
    % build the messages that will be displayed and set appropriately the
    % variables if some errore occured, both for FOLDERS CONDITIONS and for
    % FILES CONDITIONS
    %-------------------
    % Folders conditions
    %-------------------
    
elseif (allFoldersRadiobuttonValue==1)
    messageFolders=sprintf(strcat('\n\ncontained in all folders and subfolders of \n',chosenFolder));
elseif (isempty(andFoldersEditString) && isempty(orFoldersEditString))
    messageFolders=sprintf('Wrong choice of conditions for folders');
    wrongFolders=1;
elseif (isempty(andFoldersEditString))
    tempOrFoldersMessage=strcat(orFoldersEditString,',');
    tempOrFoldersMessage{end}(end)='';
    orFoldersMessage=strcat(tempOrFoldersMessage{:});
    messageFolders=sprintf(strcat('\n\ncontained in folders and subfolders of \n',chosenFolder,'\nwhose names',...
        ' match at least one of the following substrings:',orFoldersMessage));
elseif (isempty(orFoldersEditString))
    tempAndFoldersMessage=strcat(andFoldersEditString,',');
    tempAndFoldersMessage{end}(end)='';
    andFoldersMessage=strcat(tempAndFoldersMessage{:});
    messageFolders=sprintf(strcat('\n\ncontained in folders and subfolders of\n',chosenFolder,'\nwhose names',...
        ' match \nall the following substrings:',andFoldersMessage));
else
    tempOrFoldersMessage=strcat(orFoldersEditString,',');
    tempOrFoldersMessage{end}(end)='';
    orFoldersMessage=strcat(tempOrFoldersMessage{:});
    tempAndFoldersMessage=strcat(andFoldersEditString,',');
    tempAndFoldersMessage{end}(end)='';
    andFoldersMessage=strcat(tempAndFoldersMessage{:});
    messageFolders=sprintf(strcat('\n\ncontained in folders and subfolders of\n',chosenFolder,'\nwhose names',...
        ' match \nall the following substrings:',andFoldersMessage, '\nand at least one of the following substrings:',...
        orFoldersMessage));
end
%-----------------
% Files conditions
%-----------------
if (allFilesRadiobuttonValue==1)
    messageFiles=sprintf(' all files');
elseif (isempty(andFilesEditString) && isempty(orFilesEditString))
    messageFiles=sprintf('\nWrong choice of conditions for files');
    wrongFiles=1;
elseif (isempty(andFilesEditString))
    tempOrFilesMessage=strcat(orFilesEditString,',');
    tempOrFilesMessage{end}(end)='';
    orFilesMessage=strcat(tempOrFilesMessage{:});
    messageFiles=sprintf(strcat(' all files whose names ',...
        ' match at least one of the following substrings:',orFilesMessage));
elseif (isempty(orFilesEditString))
    tempAndFilesMessage=strcat(andFilesEditString,',');
    tempAndFilesMessage{end}(end)='';
    andFilesMessage=strcat(tempAndFilesMessage{:});
    messageFiles=sprintf(strcat(' all files whose names ',...
        ' match \nall the following substrings:',andFilesMessage));
else
    tempOrFilesMessage=strcat(orFilesEditString,',');
    tempOrFilesMessage{end}(end)='';
    orFilesMessage=strcat(tempOrFilesMessage{:});
    tempAndFilesMessage=strcat(andFilesEditString,',');
    tempAndFilesMessage{end}(end)='';
    andFilesMessage=strcat(tempAndFilesMessage{:});
    messageFiles=sprintf(strcat(' all files whose names',...
        ' match \nall the following substrings:',andFilesMessage, '\nand at least one of the following substrings:',...
        orFilesMessage));
end
%---------------------- Display messages ----------------------------------
%----- if wrong choice of parameters has been done
if (wrongFolders==1 || wrongFiles==1)
    if (wrongFolders==1)
        if (wrongFiles==1)
            warndlg(strcat(messageFolders,sprintf('\n'),messageFiles),'!! Warning !!');
        else
            warndlg(messageFolders,'!! Warning !!');
        end
    else
        warndlg(messageFiles,'!! Warning !!');
    end
    answer='Cancel';
    return
else
    %----- if right choice of parameters has been done
    answer = questdlg(strcat(startMessage, messageFiles,sprintf(strcat('\n')),messageFolders,sprintf('\n\nPress "OK" to continue, press "Cancel" otherwise')),'','OK','Cancel','OK');
end