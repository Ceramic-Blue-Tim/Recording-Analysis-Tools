function [startEndFolder name] = extractConversionNames(actualFileToConvert)

% EXTRACTCONVERSIONPARAMETERS extracts the name of the ".mcd" file that must be
% converted (without path) and the name of its containing folder (with
% complete path) starting from the complete path\name.mcd string

% startEndFolder        used to return the name of the folder the .mcd, .med, ... file
%                       and the Mat_files folder will be created (same
%                       directory)
% name                  used to return the name of the file will be
%                       converted without extension
% actualFileToConvert   string containing the complete name of the ".mcd" file
%                       that will be converted including its complete path

% re-implementation PL Baljon, June 2007

sep_idx = strfind(actualFileToConvert,filesep); % find all file separators (backslashes)
if ~isempty(sep_idx)
    % Now, the last filesep (sep_idx(end)) separates the path from the filename.
    name = actualFileToConvert(sep_idx(end)+1:end);
    startEndFolder  = actualFileToConvert(1:sep_idx(end));
end