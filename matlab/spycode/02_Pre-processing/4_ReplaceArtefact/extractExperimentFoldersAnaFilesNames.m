function [experimentFolders] = extractExperimentFoldersAnaFilesNames(foldersListOriginal)
% the function extracts from the list of directories passed through
% foldersListOriginal only those ones containing the "..._Ana_files" folder and the "..._PeakDetectionMAT..."
% folder.
% These folders will be passed through in order to perform the
% analysis

foldersList=foldersListOriginal;
% read complete path for each entry of the list
for i=1:length(foldersList)
    completePath=char(foldersList{i});
    % build the string that will be used as regular expression
    if(ispc())
        exprString=strcat('((.*',filesep, filesep,'[^',filesep, filesep,']*_Ana_files([^',filesep,filesep,']*))$)|',...
            '((.*',filesep, filesep,'[^',filesep, filesep,']*_PeakDetectionMAT_([^',filesep,filesep,']*))$)|');
    elseif(isunix())
        exprString=strcat('((.*',filesep,'[^',filesep,']*_Ana_files([^',filesep,']*))$)|',...
            '((.*',filesep,'[^',filesep,']*_PeakDetectionMAT_([^',filesep,']*))$)|');
    end
    % extract the name of the folder if matching the chosen conditions
    expFolder=regexpi(completePath,exprString,'match','once');
    % if one of the condition is verified
    if ~isempty(expFolder)
        cd(expFolder);
        cd ..
        % save the correct path to the folder in the list
        foldersList{i}=pwd;
    else
        foldersList{i}='';
    end
end
foldersList=foldersList(~strcmp(foldersList(:),''));
if ~isempty(foldersList)
    experimentFolders=unique(char(foldersList{:}),'rows');
    experimentFolders=sortrows(experimentFolders);
    experimentFolders=cellstr(experimentFolders);
else
    experimentFolders=cellstr(foldersList);
end