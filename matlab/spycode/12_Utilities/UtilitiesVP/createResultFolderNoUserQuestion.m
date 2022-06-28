% createResultFolderNoUserQuestion.m
% by Valentina Pasquale, 2009-01-21
function [folderPath, success] = createResultFolderNoUserQuestion(parentDir, string)
success = 1;
existFolder = searchFolder(parentDir, string);
if(~isempty(existFolder))
    [path,name] = fileparts(existFolder{end});
    openParenIdx = strfind(name,'(');
    closeParenIdx = strfind(name,')');
    if ~isempty(openParenIdx) && ~isempty(closeParenIdx)
        folderNum = str2double(name(openParenIdx+1:closeParenIdx-1))+1;
        folderName = strcat(name(1:openParenIdx-1),'(',num2str(folderNum),')');
    else
        folderName = strcat(name,'(1)');
    end
else
    expNum = find_expnum(parentDir, '_');
    folderName = strcat(expNum,'_',string);
end
try
    mkdir(parentDir,folderName);
catch
    success = 0;
    folderPath = [];
    return
end
folderPath = [parentDir,filesep,folderName];