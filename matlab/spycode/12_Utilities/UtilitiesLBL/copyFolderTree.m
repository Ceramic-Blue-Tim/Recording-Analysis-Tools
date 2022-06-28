function [  ] = copyFolderTree(regExpToRet, regToFulfill, level, stringToBeReplaced, stingToReplace)

% Luca Leonardo Bologna, June 2008
%
% v 1.0 04/06/08

%COPYFOLDERTREE given a starting folder, the script copies all the folders
%(and their content) to a given subfolder. The folders will be copied
%starting from the upper tree level passed through the "level" argument
% regExpToRet: regular expression used to retrieve the folder to copy
% regToFulfill: list of all the regular expressions the folders must fullfill
% level: level of the directory tree up to which the folders must be copied
% stringToBeReplaced: string to be replaced in the names of the folders
% stingToReplace: string to replace in the name of the folders
% e.g. call: copyFolderTree('PeakDetectionMat_',{'.*'},2, {},{})

startingFolder=uigetfolder('choose the folder from which to retrieve the subfolder fulfilling your regular expression');
finalFolder=uigetfolder('choose the final folder in which to copy the retrieved subfolders');
if isempty(startingFolder) || isempty(finalFolder)
    display('wrong choice of folders; check it out');
    return
end
    
%
[files, bytes, names]=dirr(startingFolder, regExpToRet, 'name'); %list all the files/folders fullfilling the given regular expression
%

dirIdxs=cellfun(@isdir, names ); %seeks the indices of temp in order to see if the corresponding name is a dir
names=names(dirIdxs); %extract only the names corresponding to directories
[namesFullfilling idxsStart]=regexp(names,regExpToRet,'match','once','start'); %find the indices corresponding to the positions of the regular expression to retrieve
names=names(~cellfun(@isempty, namesFullfilling));%keep only the nonempty names
tempIdxFinal=ones(1,length(names));%build a temporary array of ones successively used to extract the correct folders
tempIdxFinalOnes=ones(1,length(names));%build a temporary array of ones successively used to extract the correct folders 
for z=1:length(regToFulfill)  %for every regular expression the folders must fullfill
    tempIdxFinal=zeros(1,length(names));%build a temporary zeros array having the same length of names
    matchings=regexp(names, deblank(char(regToFulfill{z}))); %extract the folders' name fullfilling the current regular expression
    tempIdx=~cellfun(@isempty, matchings);%keep only the non-empty names
    tempIdxFinal=tempIdxFinal|tempIdx;%perform the logical operation OR in order to add the already kept names with the ones kept during the current instance of the for loop we are in
end
names=names(tempIdxFinal&tempIdxFinalOnes);%keep the correct names
names=unique(names); %delete duplicate names
idxsStart=idxsStart(~cellfun(@isempty, namesFullfilling));%starting indices for initially retrived names
for i=1:length(names)%for every folder to copy
    charName=char(names(i));%convert the cell array to an array of strings
    idxFileSep=find(charName==filesep);%find the indices of the file/folder separation character (either '/' or '\')
    idxPrev=idxFileSep(find(idxFileSep<idxsStart{i},1,'last'))+1;%find the index of the character following the last file separation character in the current name
    finalSubFolder=charName(idxPrev:end);%extract the name of the current final subfolder
    startName=charName(idxFileSep(max(1,length(idxFileSep)-level))+1:(idxPrev-2));%extract the path containing up to the "upper" level the user want to copy
    for j=1:length(stringToBeReplaced)%replace all the string passed through "stringToBeReplaced" with the ones contained in "stingToReplace"
        finalSubFolder=strrep(finalSubFolder,char(stringToBeReplaced{j}),char(stingToReplace{j}));
    end
    finalFolderComplete=fullfile(finalFolder,startName,finalSubFolder);%build the complete name of the folder to copy
    if ~isdir(finalFolderComplete) %if it is not an existing directory, create it
        mkdir(finalFolderComplete);
    end
    copyfile(char(names(i)),finalFolderComplete,'f'); %copy the folder
end