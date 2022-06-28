function [bin, mfr_thresh, cancwin, fs, cancelFlag] = uigetAFRinfo()

cancelFlag = 0;
fs         = [];
bin        = [];
mfr_thresh = [];
cancwin    = [];

PopupPrompt  = {'Bin size [s]', 'Firing Rate threshold [spikes/s]', ...
                'Blanking window for artifact [msec]', 'Sampling frequency [samples/s]'};         
PopupTitle   = 'Average Firing Rate (t) - AFR(t)';
PopupLines   = 1;
PopupDefault = {'10', '0.1', '4', GlobalsParams.DEFAULT_FS_CHAR};
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault);

if isempty(Ianswer)
    cancelFlag = 1;
else        
    fs         = str2double(Ianswer{4,1});  % Sampling frequency
    bin        = str2double(Ianswer{1,1});  % Binsize
    mfr_thresh = str2double(Ianswer{2,1});  % Threshold on the firing rate
    cancwin    = str2double(Ianswer{3,1});  % Blanking window after artifact - for electrical stimulation only
end