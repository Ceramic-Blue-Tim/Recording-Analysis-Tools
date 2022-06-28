function [exp_num] = find_expnum(string, subString)
% The method takes as input parameters two strings. Given that the second
% substrings is the string of character (even a single character)
% immediately following the number of the experiment, the method extracts a
% single string (in case a path is passed) representing the last folder (or
% a file) of the path

[path, name, ext] = fileparts(string);

% extracts the indices the subString starts in string
stringIdcs = strfind(name, subString);

% if subString has been found
if ~isempty(stringIdcs)
    exp_num = name(1:stringIdcs(1)-1);
else
    exp_num = name;
end