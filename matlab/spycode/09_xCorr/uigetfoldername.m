function [subfoldername]= uigetfoldername(exp_num, bin, window, end_folder, endstring)
% Get folder names for the cross-correlation results
% by Michela Chiappalone (9 Maggio 2005, 25 Maggio 2006)

subfoldername = strcat(exp_num, '_CCorr_', num2str(bin), '-', num2str(window), endstring);

cd (end_folder)
warning off MATLAB:MKDIR:DirectoryExists
mkdir (subfoldername) % Directory for r_table cell array
cd (subfoldername)
subfoldername= pwd;   % Save the path for subfoldername1