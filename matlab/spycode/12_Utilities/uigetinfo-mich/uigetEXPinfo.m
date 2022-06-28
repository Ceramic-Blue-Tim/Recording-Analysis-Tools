function [fs, nstd, cancelFlag]= uigetEXPinfo();
% 
% by Michela Chiappalone (7 Febbraio 2006)
% modified by Noriaki (9 giugno 2006)

cancelFlag = 0;
fs = [];
nstd = [];

PopupPrompt  = {'Sampling frequency (samples/sec)', 'Standard deviation coefficient'};         
PopupTitle   = 'Experiment info';
PopupLines   = 1;
PopupDefault = {GlobalsParams.DEFAULT_FS_CHAR, '8'};
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault);


if isempty(Ianswer)
    cancelFlag = 1;    
else
    fs   = str2num(Ianswer{1,1}); % Sampling frequency
    nstd = str2num(Ianswer{2,1}); % Coefficient for standard deviation
end

