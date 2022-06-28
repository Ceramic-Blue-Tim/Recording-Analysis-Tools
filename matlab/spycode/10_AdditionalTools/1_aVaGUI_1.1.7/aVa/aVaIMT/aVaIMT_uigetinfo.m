function [binWidths,fs,cancelFlag] = aVaIMT_uigetinfo()
% created by Michela Chiappalone (3 Maggio 2005)
% modified by Noriaki (9 giugno 2006)
% modified by Luca Leonardo Bologna (Luglio 2006)
% modified by Valentina Pasquale (September 2006)
% used to inspect the presence of the avalanches with different time bins
%----------------------------------- PARAMETER INITIALIZATION
cancelFlag = 0;         % flag to handle the halting case
binWidths = [];
fs = 0;
%----------------------------------- PROMPTING PHASE
PopupPrompt  = {'selected bin widths in increasing order [ms]', 'sampling frequency [Hz]'};
PopupTitle   = 'Set AvalancheDetection parameters';
PopupLines   = 1;
PopupDefault = {'[0.2 0.3 0.4 0.5 1 2 4 8 16]', GlobalsParams.DEFAULT_FS_CHAR};
%----------------------------------- PARAMETER CONVERSION
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault,'on');
if isempty(Ianswer) %halt condition
    cancelFlag = 1;
else
    binWidths = eval(Ianswer{1,1});
    fs = str2double(Ianswer{2,1});                 % convert to numeric value
end