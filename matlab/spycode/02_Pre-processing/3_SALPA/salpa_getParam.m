% filter_getParam.m
% Get algorithm parameters from user input
function [filterParam, flag] = salpa_getParam()
% initialize variables (in case they are not assigned)
filterParam = struct('sf',[],'N',[],'win',[],'d',[],'hw',[],'art_thresh_analog',[]);
flag = 0;
% user inputs
PopupPrompt  = {'Sampling rate [Hz]','SALPA - N [ms]','SALPA - win [ms]','SALPA - d','SALPA - hw [ms]','Artefact threshold (Analog Raw Data) [mV]'};
PopupTitle   = 'SALPA';
PopupLines   = 1;
PopupDefault = {xhar(GlobalsParams.DEFAULT_FS),'3','50','3','2','10'};
%----------------------------------- PARAMETER CONVERSION
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault,'on');
if isempty(Ianswer) % halt condition
    return
else
    filterParam.sf = str2double(Ianswer{1,1});
    filterParam.art_thresh_analog = str2double(Ianswer{6,1});
    % salpa parameters
    filterParam.N   = single(str2num(Ianswer{2,1})*filterParam.sf/1000); % 3ms -> 30 samples at 10 kHz
    filterParam.win = single(str2num(Ianswer{3,1})*filterParam.sf/1000);% 50ms -> 500 samples at 10 kHz  
    filterParam.d   = single(str2num(Ianswer{4,1}));  % 5 (as DAW)
    filterParam.hw  = single(str2num(Ianswer{5,1})*filterParam.sf/1000);   % 2 ms -> 20 samples at 10 kHz
    flag = 1;
end