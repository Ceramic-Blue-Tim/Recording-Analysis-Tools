% burstDetection_getParam.m
% Get algorithm parameters from user input
function [scBDParam, flag] = burstDetection_getParam()
% initialize variables (in case they are not assigned)
scBDParam = struct('MFRmin',[],'ISImaxTh',[],'maxISImaxTh',[],'minNumSpikes',[],'MBRmin',[],'sf',[],'cancWin',[]);
flag = 0;
% user inputs
PopupPrompt  = {'MFR threshold [spikes/s]',...
    'ISI threshold to detect burstlets [ms]',...
    'Maximum ISI threshold [ms]',...
    'Minimum number of intra-burst spikes',...
    'MBR threshold [bursts/min]','Sampling rate [Hz]',...
    'Blanking window for artefact [ms]'};
PopupTitle   = 'Burst Detection';
PopupLines   = 1;
PopupDefault = {'0.1','100','1000','5','0.4',GlobalsParams.DEFAULT_FS_CHAR,'4'};
%----------------------------------- PARAMETER CONVERSION
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault,'on');
if isempty(Ianswer) % halt condition
    return
else
    scBDParam.MFRmin = str2double(Ianswer{1,1});
    scBDParam.ISImaxTh = str2double(Ianswer{2,1});
    scBDParam.minNumSpikes = str2double(Ianswer{4,1});
    scBDParam.maxISImaxTh = str2double(Ianswer{3,1});
    scBDParam.MBRmin = str2double(Ianswer{5,1});
    scBDParam.sf = str2double(Ianswer{6,1});
    scBDParam.cancWin = str2double(Ianswer{7,1});     % [ms]
    flag = 1;
end