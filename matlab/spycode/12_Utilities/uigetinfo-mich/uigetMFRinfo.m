function [mfr_thresh, cancwin, fs, cancelFlag]= uigetMFRinfo();
% 
% by Michela Chiappalone (14 Marzo 2006)
% modified by Noriaki (10 giugno 2006)

cancelFlag = 0;
fs         = [];
mfr_thresh = [];
cancwin    = [];

PopupPrompt  = {'Firing Rate threshold [spikes/sec]', ...
                'Blanking window for artifact [msec]:','Sampling frequency [samples/sec]'};         
PopupTitle   = 'Mean Firing Rate - MFR)';
PopupLines   = 1;
PopupDefault = {'0.1', '4', GlobalsParams.DEFAULT_FS_CHAR};
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault);

if isempty(Ianswer)
    cancelFlag = 1;
else
    fs         = str2num(Ianswer{3,1});  % Sampling frequency
    mfr_thresh = str2num(Ianswer{1,1});  % Threshold on the firing rate
    cancwin    = str2num(Ianswer{2,1});  % Blanking window after artifact - for electrical stimulation only
end
