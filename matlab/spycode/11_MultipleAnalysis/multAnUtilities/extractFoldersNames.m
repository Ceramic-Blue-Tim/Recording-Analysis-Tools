function foldersNames = extractFoldersNames (userfolder,parameters)
% EXTRACTMCDFILESNAMES takes as input the folder from which to start in
% retrieving folders and the parameters the user selected and returns
% a string matrix containing the full path  of each folders fulfilling the chosen parameters
% userfolder        folder from which to start in retrieving ".mcd" files
% parameters        parameters the user has chosen for retrieving ".mcd"
%                   files
% foldersNames      array of strings contatining the full path of each
%                   folders fulfilling the parameters chosen by the user
% created by Luca Leonardo Bologna 18 February 2007

andFoldersEditString=parameters{2};
orFoldersEditString=parameters{3};
% extract the paths (including name and extension of all ".mcd" files
% contained in the root folder and in its subfolders
[Files,Bytes,Names] = dirr(userfolder,'name');
% 
foldersNames = Names;
for i = 1 : 1 : length(foldersNames) 
    if ~isdir(char(foldersNames{i}))
        foldersNames{i} = '';
    end
end
%
idx = find(~strcmp(foldersNames(:),''));
foldersNames = foldersNames(idx);
%---------------------------
%----- folders' name parsing
%---------------------------
% format appropriately the userfolder string in order to apply regular
% expression manipulation
if(ispc())
    userfolder=regexprep(userfolder,{strcat(filesep,filesep),strcat(filesep,'.')},{strcat(filesep,filesep,filesep),strcat(filesep,filesep,'.')});
end
if ~ispc()
    userfolder = regexprep(userfolder, {'[', ']'},{'\\[', '\\]'});
end
% create the regular expression used to retrieve the files
tempExpress = strcat('(?<=',userfolder,').*');
%   extract the path of the ".mcd" files eliminating the path up to the
%   root folder
pwdFoldersNames = regexpi(foldersNames, tempExpress,'match','once');
if ~isempty(andFoldersEditString)
    subStringLen=length(andFoldersEditString);
    % the loop create the regular expression containing all the AND
    % conditions on the folders'names chosen by the user that must be used
    % in retrieving the files and extract from the list of names the ones
    % matching the conditions
    for i=1:subStringLen
        subString=andFoldersEditString{i};
        if(ispc())
            expr=strcat('.*',subString,'.*',filesep,filesep,'.*');
        else if(isunix())
            expr=strcat('.*',subString,'.*',filesep,'.*');
            end
        end
        pwdFoldersNames=regexpi(pwdFoldersNames, expr,'match','once');
    end
end
%
if ~isempty(orFoldersEditString)
    subStringLen=length(orFoldersEditString);
    expr='.*(';
    % the loop create the regular expression containing all the OR 
    % conditions on the folders' names chosen by the user that must be used
    % in retrieving the files
    for i=1:subStringLen
        expr=strcat(expr,orFoldersEditString{i},'|');
    end
    if(ispc())
        expr=strcat(expr(1:end-1),')','.*',filesep,filesep,'.*');
    else if(isunix())
            expr=strcat(expr(1:end-1),')','.*',filesep,'.*');
        end
    end
    pwdFoldersNames=regexpi(pwdFoldersNames, expr,'match','once');
end
% vector containing the indices of non empty rows
idxUsefulFolders=find(~strcmp(pwdFoldersNames(:),''));
% list of folders containing fulfilling the inserted parameters
foldersNames=foldersNames(idxUsefulFolders);
%
foldersNames=cellstr(foldersNames);