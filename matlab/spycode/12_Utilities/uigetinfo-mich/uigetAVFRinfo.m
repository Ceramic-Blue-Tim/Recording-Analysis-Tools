function [bin, mfr_thresh, cancwin, fs, cancelFlag]= uigetAVFRinfo()
% 
% by Michela Chiappalone (3 Maggio 2005)

mfactor = 1000;
cancelFlag = 0;
fs         = [];
bin        = [];
mfr_thresh = [];
cancwin    = [];

PopupPrompt  = {'Bin size (msec)', 'Firing Rate threshold (spikes/sec)', ...
                'Blanking windowfor artifact (msec):','Sampling frequency (samples/sec)'};         
PopupTitle   = 'Average Firing Rate (t) - AFR(t)';
PopupLines   = 1;
PopupDefault = {'10', '0.1', '4', GlobalsParams.DEFAULT_FS_CHAR};
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault);

if isempty(Ianswer)
    cancelFlag = 1;
else        
    fs         = str2num(Ianswer{4,1});  % Sampling frequency
    bin        = str2num(Ianswer{1,1});  % Binsize
    mfr_thresh = str2num(Ianswer{2,1});  % Threshold on the firing rate
    cancwin    = str2num(Ianswer{3,1});  % Blanking window after artifact - for electrical stimulation only

    minbin = 1/fs;  % 0.1 msec  = usually equal to the sampling frequency
    maxbin = 300000;   % 5 minutes = total duration of the acquisition

    % -----------> ERROR CONTROL FOR BIN SIZE
    if isempty(bin)
        bin=0;
    end
    while ((minbin>=bin)|(bin>=maxbin))
        errordlg('The bin size is out of range','Input Error');
        break; % end of function
    end
end
