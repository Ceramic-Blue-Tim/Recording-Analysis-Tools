function [mainRegExp,regExprToFullfill,numSplit, flag] = splitRecPhases_getParam()
% initialize variables (in case they are not assigned)
mainRegExp = '';
regExprToFullfill = '';
flag = 0;
% user inputs
PopupPrompt  = {sprintf('Main PeakDetection folder name \n(default is native Spycode peak train folder)'), ...
    sprintf('Names of the experimental phases you want to split  \n(separated by commas)'), ...
    'Number of chunks you want to split the peak trains into'};
PopupTitle   = 'Split recording phases';
PopupLines   = 1;
PopupDefault = {'PeakDetectionMAT', '01_nbasal1, 02_nbasal2', '2'};

%----------------------------------- PARAMETER CONVERSION
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault,'on');
if isempty(Ianswer) % halt condition
    display('No parameters inserted');
    return
else

    mainRegExp = Ianswer{1,1};
    regExprToFullfill = Ianswer{2,1};
    numSplit = str2double (Ianswer{3,1});
    flag = 1;
end