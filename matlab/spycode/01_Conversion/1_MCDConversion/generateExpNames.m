function [ expNames] = generateExpNames(namesList, fileTypes)
% GENERATEEXPNUM extracts the names of the experiments referring to each of
% the file passed as argument in fileList on the basis of fileTypes.
% FileList contains the entire paths of the files

% error message in case parameters lengths do not correspond
if length(namesList) ~= length(fileTypes)
    error('Argument lengths do not correspond in function generateExpNames. Program is exiting');
end

%number of file
filesNum = size(namesList,2);

%
expNames = cell(length(filesNum), 1);

%for each file
for i = 1 : filesNum
    %convert to char and extract the experiment number
    currExpNum = find_expnum(strtrim(char(namesList(i))),'_');
    
    % delete trailing and leading blanks
    currentExpName = strtrim(char(namesList(i)));
    
    % extract filename parts
    [crrExpNmpath currentExpName] = fileparts(currentExpName);
    
    % find index of the first occurrence of currExpNum in currentExpName
    expNumIdx = findstr(currentExpName, currExpNum);
    
    % extract current fileTypes
    crrFileType = fileTypes{i};
    
    % build folder name on the basis of the number of channel
    switch crrFileType
        case 128 % {'Conf', 'DMEA'}
            %assigns two output folders
            expNames(i) = {[[currExpNum 'A' currentExpName(expNumIdx(1)+length(currExpNum):end)]; ...
                [currExpNum 'B' currentExpName(expNumIdx(1)+length(currExpNum):end)]]};
        case 64 % 'MEA'
            expNames(i) = {currentExpName};
        otherwise
    end
end 