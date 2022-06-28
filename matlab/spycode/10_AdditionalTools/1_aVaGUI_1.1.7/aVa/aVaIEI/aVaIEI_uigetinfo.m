function [IEIbin, IEIwin, ylim, fs, cancelFlag]= aVaIEI_uigetinfo()
% by Michela Chiappalone (14 Marzo 2006)
% modified by Noriaki (9 giugno 2006)
% modified by Valentina Pasquale (January 2007)
cancelFlag = 0;
fs         = []; 
IEIbin     = [];
IEIwin     = [];
ylim       = [];
PopupPrompt  = {'IEI bin [msec]', 'IEI window [msec]', 'Ylim [0,1]', 'Sampling frequency [samples/sec]'};         
PopupTitle   = 'Inter-Event Interval - IEI Histogram)';
PopupLines   = 1;
PopupDefault = {'0.1', '20', '1', GlobalsParams.DEFAULT_FS_CHAR};
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault);
if isempty(Ianswer)
    cancelFlag = 1;
else
    fs         =  str2num(Ianswer{4,1});                     % Sampling frequency
    IEIbin     =  (str2num(Ianswer{1,1})/1000)*fs;           % Bin of the ISI [samples]
    IEIwin     =  (str2num(Ianswer{2,1})/1000)*fs;           % Window of the ISI [samples]
    ylim       =  str2double(Ianswer{3,1});                  % Limit of the Y-axis for the ISI plot
end