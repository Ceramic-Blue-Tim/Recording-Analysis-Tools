function [fs, binsize, cancwin, timeframe, cancelFlag]= uigetPSTHinfo2()
% Prompt a user-window for input information regarding the current
% experiment for computing PSTH
% by Michela Chiappalone (18 Gennaio 2006, 16 Marzo 2006)
% modified by Noriaki (9 giugno 2006)

cancelFlag = 0;
binsize  = [];
cancwin  = [];
timeframe= [];
fs       = [];

PopupPrompt = {'PSTH bin size [msec]', 'Blanking window for artefact [msec]', ...
               'PSTH time frame [msec]', 'Sampling frequency [spikes/sec]'};         
PopupTitle  =  'Input for PSTH settings';
PopupLines  =  1;
PopupDefault= {'2', '4', '600', GlobalsParams.DEFAULT_FS_CHAR};
Ianswer     = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault);

if isempty (Ianswer)
    cancelFlag = 1;
else
    binsize  = str2double(Ianswer{1,1});
    cancwin  = str2double(Ianswer{2,1});
    timeframe= str2double(Ianswer{3,1});
    fs       = str2double(Ianswer{4,1});
end
clear Ianswer PopupPrompt PopupTitle PopupLines PopupDefault
