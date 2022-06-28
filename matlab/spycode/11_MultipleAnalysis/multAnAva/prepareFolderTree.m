root = 'K:\valentina\experiments\02_mice\02_miceFromMichela_newAnalysis\DIV31-35';
[folder, bytes, folderNames] = dirr(root,'name','.*_PeakDetectionMAT');
pkdFolder = folderNames';
for ii = 1:size(pkdFolder,1)
    [curExpFolder,curpkdFolderName] = fileparts(pkdFolder{ii});
    mkdir(curExpFolder,[curpkdFolderName(1:5),'aVaAnalysis'])
    resFolder = [curExpFolder,filesep,[curpkdFolderName(1:5),'aVaAnalysis']];
    folder = dir(pkdFolder{ii});
    phase = {folder.name}; phaseNames = phase(3:end)';
    for jj = 1:size(phaseNames,1)
        ind = findstr(phaseNames{jj},'_');
        str = phaseNames{jj}(ind(end)+1:end);
        mkdir(resFolder,str)
        resFolder2 = [resFolder,filesep,str];
        mkdir(resFolder2,curpkdFolderName)
        resFolder3 = [resFolder2,filesep,curpkdFolderName];
        mkdir(resFolder3,phaseNames{jj})
        resFolder4 = [resFolder3,filesep,phaseNames{jj}];
        copyfile([pkdFolder{ii},filesep,phaseNames{jj}],resFolder4)
    end   
end