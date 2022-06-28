% filter_getParam.m
% Get algorithm parameters from user input
function [filterParam, flag] = filter_getParam()
% initialize variables (in case they are not assigned)
filterParam = struct('bandwidth',[],'range',[],'sf',[],'gain',[],'resolution',[]);
flag = 0;
% user inputs
PopupPrompt  = {'Bandwidth [Hz]',...
    'Sampling rate [Hz]',...
    'Voltage range [mV]'...,
    'Gain',...
    'Resolution [bits]'};
PopupTitle   = 'Filter';
PopupLines   = 1;
PopupDefault = {'[300 3000]',GlobalsParams.DEFAULT_FS_CHAR,'819','1200','16'};
%----------------------------------- PARAMETER CONVERSION
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault,'on');
if isempty(Ianswer) % halt condition
    return
else
    filterParam.bandwidth = eval(Ianswer{1,1});    % [Hz]
    filterParam.sf = str2double(Ianswer{2,1});  % [Hz]
    filterParam.range = str2double(Ianswer{3,1}); % [mV]
    filterParam.gain = str2double(Ianswer{4,1});
    filterParam.resolution = str2double(Ianswer{5,1}); % [bits]
    flag = 1;
end