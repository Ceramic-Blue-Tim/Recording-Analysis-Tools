function [experimentFolders] = extractExperimentFoldersNames(foldersListOriginal)
% the function extracts from the list of directory passed through
% foldersList only the principal directories of the experiment, i.e. the
% ones containing the "..._MAT_files" folder, the "..._PeakDetectionMAT..."
% folder, etc...
% These folder will be the one pass through in order to perform the
% analysis

foldersList=foldersListOriginal;
% read complete path for each entry of the list
for i=1:length(foldersList)
    completePath=char(foldersList{i});
    % build the string that will be used as regular expression
    if(ispc())
        exprString=strcat('((.*',filesep, filesep,'[^',filesep, filesep,']*_Mat_files([^',filesep,filesep,']*))$)|',...
            '((.*',filesep, filesep,'[^',filesep, filesep,']*_PeakDetectionMAT_([^',filesep,filesep,']*))$)|',...
            '((.*',filesep, filesep,'[^',filesep, filesep,']*_PSTHfiles_([^',filesep,filesep,']*))$)|',...
            '((.*',filesep, filesep,'[^',filesep, filesep,']*_PSTHresults_([^',filesep,filesep,']*))$)|',...
            '((.*',filesep, filesep,'[^',filesep, filesep,']*(?<!BurstEvent)_CCorr_[^',filesep,filesep,']*msec([^',filesep,filesep,']*))$)|',...
            '((.*',filesep, filesep,'[^',filesep, filesep,']*_BurstDetectionMAT_[^',filesep,filesep,']*msec([^',filesep,filesep,']*))$)');
    elseif(isunix())
        exprString=strcat('((.*',filesep,'[^',filesep,']*_Mat_files([^',filesep,']*))$)|',...
            '((.*',filesep,'[^',filesep,']*_PeakDetectionMAT_([^',filesep,']*))$)|',...
            '((.*',filesep,'[^',filesep,']*_PSTHfiles_([^',filesep,']*))$)|',...
            '((.*',filesep,'[^',filesep,']*_PSTHresults_([^',filesep,']*))$)|',...
            '((.*',filesep,'[^',filesep,']*(?<!BurstEvent)_CCorr_[^',filesep,']*msec([^',filesep,']*))$)|',...
            '((.*',filesep,'[^',filesep,']*_BurstDetectionMAT_[^',filesep,']*msec([^',filesep,']*))$)');
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