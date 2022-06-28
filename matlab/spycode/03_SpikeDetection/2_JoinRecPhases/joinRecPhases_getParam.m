function [mainRegExp,regExprToFullfill,regToFulfillInName,flag] = joinRecPhases_getParam()
% initialize variables (in case they are not assigned)
mainRegExp = '';
regExprToFullfill = '';
regToFulfillInName = '';
flag = 0;
% user inputs
PopupPrompt  = {'Main PeakDetection folder name',...
    'Phases'' names',...
    'Sub-folders'' names'};
PopupTitle   = 'Join recording phases';
PopupLines   = 1;
PopupDefault = {'PeakDetectionMAT','{''01_nbasal1'',''03_nbasal2''}','{''div45'',''div48'',''div46'',''div49''}'};
%----------------------------------- PARAMETER CONVERSION
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault,'on');
if isempty(Ianswer) % halt condition
    return
else

    mainRegExp = Ianswer{1,1};
    regExprToFullfill = eval(Ianswer{2,1});
    regToFulfillInName = eval(Ianswer{3,1});
    flag = 1;
end