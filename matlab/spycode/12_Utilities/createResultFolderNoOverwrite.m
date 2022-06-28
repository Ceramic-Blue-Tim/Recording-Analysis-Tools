function [folderPath, overwriteFlag] = createResultFolderNoOverwrite(parentDir, numDir, string)
overwriteFlag = 0;
folderPath = [];
existFolder = searchFolder(parentDir, string);

expNum = find_expnum(numDir, '_');
folderName = strcat(expNum,'_',string);

[success,message] = mkdir(parentDir,folderName);
if ~success
    errordlg(['Making new directory: ', message], '!!Error!!', 'modal');
    return
end
folderPath = [parentDir,filesep,folderName];