function [answer] = displayMultipleAnalysisChosenConditions(chosenFolder, allFoldersRadiobuttonValue,...
    andFoldersEditString, orFoldersEditString)

% created by Luca Leonardo Bologna 18 February 2007

% used to check errors on the choice of folders
wrongFolders=0;
startMessage='You have chosen to analise all data stored ';
% replace the file separator of the system "\" (or "/" depending on the
% system) with "\\" (or "//") in order to manage regular expression used
% later
if(ispc)
    chosenFolder=regexprep(chosenFolder,strcat(filesep,filesep),strcat(filesep,filesep,filesep));
end
% if the user chose to convert all files the application will find
if (allFoldersRadiobuttonValue==1)
    messageString=[startMessage, sprintf('\n'), 'in all the folders contained in', sprintf('\n'),sprintf(chosenFolder), ...
        sprintf('\n'),'and in its subfolders.',sprintf('\n'),sprintf('\n'),'Press ''OK '' to confirm your choice (the process could take a few minutes), press ''Cancel'' otherwise'];
    %confirmation window
    answer = questdlg(messageString,'','OK','Cancel','OK');
    pause(1);
    return
    % build the messages that will be displayed and set appropriately the
    % variables if some errore occured, for FOLDERS CONDITIONS
    %-------------------
    % Folders conditions
    %-------------------
elseif (isempty(andFoldersEditString) && isempty(orFoldersEditString))
    messageFolders=sprintf('Wrong choice of conditions for folders');
    wrongFolders=1;
elseif (isempty(andFoldersEditString))
    tempOrFoldersMessage=strcat(orFoldersEditString,',');
    tempOrFoldersMessage{end}(end)='';
    orFoldersMessage=strcat(tempOrFoldersMessage{:});
    messageFolders=['in folders and subfolders of ',sprintf('\n'),sprintf(chosenFolder),sprintf('\n'),'whose names',...
        ' match at least one of the following substrings: ',orFoldersMessage];
    if(ispc())
        messageFolders=regexprep(messageFolders,strcat(filesep,filesep),strcat(filesep,filesep,filesep));
    end
elseif (isempty(orFoldersEditString))
    tempAndFoldersMessage=strcat(andFoldersEditString,',');
    tempAndFoldersMessage{end}(end)='';
    andFoldersMessage=strcat(tempAndFoldersMessage{:});
    messageFolders=['in folders and subfolders of ' sprintf('\n'),sprintf(chosenFolder),sprintf('\n'),'whose names',...
        ' match',sprintf('\n'),'all the following substrings:',andFoldersMessage];
    if(ispc())
        messageFolders=regexprep(messageFolders,strcat(filesep,filesep),strcat(filesep,filesep,filesep));
    end
else
    tempOrFoldersMessage=strcat(orFoldersEditString,',');
    tempOrFoldersMessage{end}(end)='';
    orFoldersMessage=strcat(tempOrFoldersMessage{:});
    tempAndFoldersMessage=strcat(andFoldersEditString,',');
    tempAndFoldersMessage{end}(end)='';
    andFoldersMessage=strcat(tempAndFoldersMessage{:});
    messageFolders=['in folders and subfolders of ',sprintf('\n'),sprintf(chosenFolder),sprintf('\n'),'whose names',...
        ' match',sprintf('\n'),'all the following substrings: ',andFoldersMessage,sprintf('\n') 'and at least one of the following substrings:',...
        orFoldersMessage];
    if(ispc())
        messageFolders=regexprep(messageFolders,strcat(filesep,filesep),strcat(filesep,filesep,filesep));
    end
end
%---------------------- Display messages ----------------------------------
%----- if wrong choice of parameters has been done
if (wrongFolders)
    warnMessage=[messageFolders sprintf('\n')];
    warndlg(warnMessage,'!! Warning !!');
    answer='Cancel';
    return
else
    %----- if right choice of parameters has been done
    messageQuestDlg=[ startMessage sprintf(messageFolders) sprintf('\n\n') 'Press "OK" to continue, press "Cancel" otherwise'];
    answer = questdlg(messageQuestDlg,'','OK','Cancel','OK');
end