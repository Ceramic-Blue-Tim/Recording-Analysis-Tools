function [outputFoldersList] = genOutputFolders (filesList, fileTypes)
%genOutputFolders extracts the folder containing each of the file passed as
%argument in fileList on the basis of fileTypes. fileList contains the
%entire paths of the files

%number of file
filesNum = length(filesList);
outputFoldersList = cell(length(fileTypes), 1);

%
[allPath allNms allExt]= cellfun(@fileparts, filesList, 'UniformOutput', 0);

%for each file
for i = 1 : length(fileTypes)
    % convert to char and extract the entire path
    % folder = findContainingFolder(deblank(char(filesList(i))));
    
    crrFileType = fileTypes{i};
    %
    switch crrFileType
        case 128    % {'Conf', 'DMEA'}
            % extract current experiment number
            crrExpName = find_expnum(filesList{i},'_');
            
            %assigns two output folders in case of system with 120 channels
            outputFoldersList(i) = {[fullfile(strtrim(allPath{i}), [crrExpName, 'A']); fullfile(deblank(allPath{i}), [crrExpName, 'B'])]};
        case 64     % 'MEA'
            % extract current experiment number
            crrExpName = find_expnum(filesList{i},'_');
            
            % build output folder
            outputFoldersList(i) = {fullfile(deblank(allPath{i}), crrExpName)};
        otherwise
    end
end
end