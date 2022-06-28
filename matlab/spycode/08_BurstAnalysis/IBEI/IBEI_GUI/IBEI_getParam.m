% burstDetection_getParam.m
% Get algorithm parameters from user input
function [IBEIParam, flag] = IBEI_getParam()
% initialize variables (in case they are not assigned)
IBEIParam = struct('nBinsPerDec',[],'minPeakDistance',[],'voidParamTh',[],...
'timeTh',[],'sf',[],'smoothMethod',[],'smoothSpan',[]);
flag = 0;
% user inputs
PopupPrompt  = {'Number of bins per decade','Minimum peak distance [#points]','Void parameter threshold',...
    'IBEI threshold [ms]','Sampling rate [Hz]','Smooth method','Smooth span'};
PopupTitle   = 'Inter burst event interval';
PopupLines   = 1;
PopupDefault = {'10','2','0.90','100',GlobalsParams.DEFAULT_FS_CHAR,'lowess','5'};
%----------------------------------- PARAMETER CONVERSION
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault,'on');
if isempty(Ianswer) % halt condition
    return
else
    IBEIParam.nBinsPerDec = str2double(Ianswer{1,1});
    IBEIParam.minPeakDistance = str2double(Ianswer{2,1});
    IBEIParam.voidParamTh = str2double(Ianswer{3,1});
    IBEIParam.timeTh = str2double(Ianswer{4,1});    % [ms]
    IBEIParam.sf = str2double(Ianswer{5,1});        % [Hz]
    IBEIParam.smoothMethod = Ianswer{6,1};
    IBEIParam.smoothSpan = str2double(Ianswer{7,1});
    flag = 1;
end