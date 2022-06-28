% plotSpikeBurstNetBurst_getParam.m
% Get algorithm parameters from user input
function [param, flag] = plotSpikeBurstNetBurst_getParam()
% initialize variables (in case they are not assigned)
param = struct('startTime',[],'endTime',[],'sf',[],'cancWin',[]);
flag = 0;
% user inputs
PopupPrompt  = {'Start time [s]',...
    'End time [s]','Sampling rate [Hz]',...
    'Blanking window for artefact [ms]'};
PopupTitle   = 'Plot Raster Plus Network Bursts';
PopupLines   = 1;
PopupDefault = {'0','-1',GlobalsParams.DEFAULT_FS_CHAR,'4'};
%----------------------------------- PARAMETER CONVERSION
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault,'on');
if isempty(Ianswer) % halt condition
    return
else
    param.sf = str2double(Ianswer{3,1});
    param.startTime = str2double(Ianswer{1,1});
    if param.startTime < 0 
        param.startTime = 0;
    end        
    param.endTime = str2double(Ianswer{2,1});
    param.cancWin = str2double(Ianswer{4,1});     % [ms]
    flag = 1;
end