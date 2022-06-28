% FH_NBDetect_vm_getParam.m
% Get algorithm parameters from user input
function [NBDetectParam, flag] = netBurstDetection_uigetParam()
% initialize variables (in case they are not assigned)
NBDetectParam = struct('th',[],'IBeIThDef',[],'sf',[]);
% user inputs
PopupPrompt  = {'No. active electrodes threshold [%]','IBeI threshold (default) [ms]','sampling frequency [Hz]'};
PopupTitle   = 'Network Bursts detection';
PopupLines   = 1;
PopupDefault = {'20','100', GlobalsParams.DEFAULT_FS_CHAR};
%----------------------------------- PARAMETER CONVERSION
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault,'on');
if isempty(Ianswer) % halt condition
    flag = 0;
    return
else
    NBDetectParam.sf = str2double(Ianswer{3,1});
    NBDetectParam.IBeIThDef = str2double(Ianswer{2,1});
    NBDetectParam.th = str2double(Ianswer{1,1})/100;
    flag = 1;
end