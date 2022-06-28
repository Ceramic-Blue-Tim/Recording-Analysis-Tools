% filter_getParam.m
% Get algorithm parameters from user input
function [filterParam, flag] = filterSALPA_getParam()
% initialize variables (in case they are not assigned)
filterParam = struct('bandwidth',[],'range',[],'gain',[],'resolution',[],'sf',[],'N',[],'win',[],'D',[],'hw',[],'art_thresh_analog',[]);
flag = 0;
% user inputs
PopupPrompt  = {'Bandwidth [Hz]',...
    'Sampling rate [Hz]',...
    'Voltage range [mV]'...,
    'Gain',...
    'Resolution [bits]',...
    'SALPA - N [ms]',...
    'SALPA - win [ms]',...
    'SALPA - d','SALPA - hw [ms]',...
    'Artefact threshold (Analog Raw Data) [mV]'};
PopupTitle   = 'Filter - SALPA';
PopupLines   = 1;
PopupDefault = {'[300 3000]','10000','819','1200','16','3','50','3','2','10'};
%----------------------------------- PARAMETER CONVERSION
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault,'on');
if isempty(Ianswer) % halt condition
    return
else
    filterParam.bandwidth = eval(Ianswer{1,1});    % [Hz]
    filterParam.sf = str2double(Ianswer{2,1});
    filterParam.range = str2double(Ianswer{3,1}); % [mV]
    filterParam.gain = str2double(Ianswer{4,1});
    filterParam.resolution = str2double(Ianswer{5,1}); % [bits]
    filterParam.art_thresh_analog = str2double(Ianswer{10,1});
    % salpa parameters
    filterParam.N   = single(str2num(Ianswer{6,1})*filterParam.sf/1000); % 3ms -> 30 samples at 10 kHz
    filterParam.win = single(str2num(Ianswer{7,1})*filterParam.sf/1000);% 50ms -> 500 samples at 10 kHz  
    filterParam.d   = single(str2num(Ianswer{8,1}));  % 5 (as DAW)
    filterParam.hw  = single(str2num(Ianswer{9,1})*filterParam.sf/1000);   % 2 ms -> 20 samples at 10 kHz
    flag = 1;
end