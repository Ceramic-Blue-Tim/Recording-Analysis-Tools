% searchFolder.m
% by Valentina Pasquale, 2008-03-10
% ARGUMENTS:
% parentDir: the directory which the algorithm searches in (only 1st level, not every subdirectory)
% string: a string that identifies the folder to look for in parentDir
%   (e.g. SpikeAnalysis, BurstAnalysis)
% OUTPUT:
% folderPath: the absolute path(s) of the matching folder(s) (in a cell
%   array of strings if more than one); empty if there's no matching folder
function [folderPath] = searchFolder(parentDir, string)
% files&folders in parentDir
f = dir(parentDir);
% files' names
folderNames = {f.name};
% in chronological order with respect to the date modified
% lastModDate = [f.datenum];
% [y,sortIndxs] = sort(lastModDate,2,'ascend');
% folderNames = folderNames(sortIndxs);
% find indexes of matching folderNames
folderIdxs = find(~cellfun('isempty',strfind(folderNames,string)));
if ~isempty(folderIdxs)     % there is AT LEAST ONE matching folder
    % build path
    folderPath = strcat(parentDir,filesep,folderNames(folderIdxs));
else
    folderPath = [];
end