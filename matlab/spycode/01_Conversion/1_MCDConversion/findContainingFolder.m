function [ folder ] = findContainingFolder( fileName )
%FINDCONTAININGFOLDER Summary of this function goes here
%   Detailed explanation goes here

filesepIdx = strfind(fileName,filesep);

if ~isempty(filesepIdx)
    folder=fileName(1:filesepIdx(end));
end