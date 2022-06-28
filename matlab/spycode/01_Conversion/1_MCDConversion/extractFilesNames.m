function [filesNames, startingFolders] = extractFilesNames (givenUserfolder, parameters, ext)
% extractFilesNames takes as input the folder from which to start in
% retrieving files and the parameters the user selected and returns
% a string matrix containing the full path (including the name) of each
% file fulfilling the chosen parameters

% givenUserfolder        folder from which to start in retrieving files
% parameters        parameters the user has chosen for retrieving
%                   files
% ext               extension of the files to be found (ex. 'mcd', 'med')
% FilesNames     array of strings contatining the full path (including
% the name) of each files fulfilling the chosen parameters

% created by Luca Leonardo Bologna 01 February 2007
% modifie by Luca Leonardo Bologna on the 13 March 2011 - implemented
% compatibility for Neuroshare library

%   entry of the andFoldersEditString
andFoldersEditString = parameters{4};

% entry of the orFoldersEditString
orFoldersEditString = parameters{5};

% entry of the andFilesEditString
andFilesEditString = parameters{6};

% entry of the orFilesEditString
orFilesEditString = parameters{7};

% extract the paths (including name and extension of all files
% contained in the root folder and in its subfolders
extToFind = ['\.' ext '\>'];
[Files,Bytes,Names] = dirr(givenUserfolder,extToFind,'name');

filesNames = Names;
%---------------------------
%----- folders' name parsing
%---------------------------
% format appropriately the userfolder string in order to apply regular
% expression manipulation
% % % % userfolder=regexprep(givenUserfolder,{strcat(filesep,filesep),strcat(filesep,'.')},{strcat(filesep,filesep,filesep),strcat(filesep,filesep,'.')});
% % % % userfolder = givenUserfolder;

% create the regular expression used to retrieve the files
% % % % tempExpress=strcat('(?<=',userfolder,').*');
%   extract the path of the files eliminating the path up to the
%   root folder
% pwdFilesNames=regexpi(Names, tempExpress,'match','once');

if isempty(Names)
    filesNames = {};
    startingFolders = {};
    return
end


% pwdFilesNamesIdx=strfind(Names, givenUserfolder);
for i = 1 : length(Names)
    crrFlNm = Names{i};
    pwdFilesNames{i} = crrFlNm(length(givenUserfolder) + 1 : end);
end

if ~isempty(andFoldersEditString)
    subStringLen = length(andFoldersEditString);
    % the loop create the regular expression containing all the AND
    % conditions on the folders'names chosen by the user that must be used
    % in retrieving the files and extract from the list of names the ones
    % matching the conditions
    for i = 1:subStringLen
        subString = andFoldersEditString{i};
        expr = strcat('.*',subString,'.*',filesep,filesep,'.*');
        pwdFilesNames = regexpi(pwdFilesNames, expr,'match','once');
    end
end

if ~isempty(orFoldersEditString)
    subStringLen = length(orFoldersEditString);
    expr = '.*(';
    % the loop create the regular expression containing all the OR
    % conditions on the folders' names chosen by the user that must be used
    % in retrieving the files
    for i = 1:subStringLen
        expr = strcat(expr,orFoldersEditString{i},'|');
    end
    expr = strcat(expr(1:end-1),')','.*',filesep,filesep,'.*');
    pwdFilesNames = regexpi(pwdFilesNames, expr,'match','once');
end
%-------------------------
%----- files' name parsing
%-------------------------
%if AND condition has been inserted
if ~isempty(andFilesEditString)
    subStringLen = length(andFilesEditString);
    % the loop create the regular expression containing all the AND
    % conditions on the files'names chosen by the user that must be used
    % in retrieving the files and extract from the list of names the ones
    % matching the conditions
    for i=1:subStringLen
        subString = andFilesEditString{i};
        expr = ['.*' filesep filesep '[^' filesep filesep ']*' subString '[^' filesep filesep ']*.' ext];
        pwdFilesNames = regexpi(pwdFilesNames, expr,'match','once');
    end
end
%if OR condition has been inserted
if ~isempty(orFilesEditString)
    subStringLen = length(orFilesEditString);
    orExprTemp = '(';
    % the loop create the regular expression containing all the OR
    % conditions on the files' names chosen by the user that must be used
    % in retrieving the files
    for i = 1:subStringLen
        orExprTemp = strcat(orExprTemp,orFilesEditString{i},'|');
    end
    orExpr = strcat(orExprTemp(1:end-1),')');
    expr = ['.*' filesep filesep '[^' filesep filesep ']*' orExpr '[^' filesep filesep ']*' ext];
    pwdFilesNames = regexpi(pwdFilesNames, expr,'match','once');
end
% vector containing the indices of non empty rows
idx = find(~strcmp(pwdFilesNames(:),''));

% select only appropriate files
filesNames = Names(idx);

% indices of directory not to be chosen
idxNotDir = ~(cellfun(@isdir, filesNames));

% extract only file names (not directory names)
filesNames = filesNames(idxNotDir);

% extract starting folder for each file
[startingFolders] = cellfun(@fileparts, filesNames, 'UniformOutput' ,0);