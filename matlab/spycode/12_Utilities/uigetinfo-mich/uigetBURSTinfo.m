function [nspikes, ISImax, min_mbr, cwin, fs, cancelFlag]= uigetBURSTinfo()
% Prompt a user-window for input information regarding the current
% experiment for computing PSTH
% by Michela Chiappalone (18 Gennaio 2006, 16 Marzo 2006)
% modified by Noriaki (9 giugno 2006)

cancelFlag = 0;
nspikes= [];
ISImax = [];
min_mbr= [];
cwin   = [];
fs     = [];

PopupPrompt = {'Min number of intra-burst spikes', 'Max intra-burst ISI [msec]', ...
               'Bursting Rate threshold [burst/min]', ...
               'Blanking window for artifact [msec]', 'Sampling frequency [spikes/sec]'};         
PopupTitle  =  'Burst Detection Settings';
PopupLines  =  1;
PopupDefault= {'5', '100', '0.4', '4', GlobalsParams.DEFAULT_FS_CHAR};
Ianswer     = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault);

if isempty(Ianswer)
    cancelFlag = 1;
else
    nspikes= str2num(Ianswer{1,1});
    ISImax = str2num(Ianswer{2,1});
    min_mbr= str2num(Ianswer{3,1});
    cwin   = str2num(Ianswer{4,1});
    fs     = str2num(Ianswer{5,1});
end

clear Ianswer PopupPrompt PopupTitle PopupLines PopupDefault
