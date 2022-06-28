function [window, binsize, binpeak, cancwin, fs, cancelFlag]= uigetcorrinfo();
% Get information for cross-correlation
% by Michela Chiappalone (6 Maggio 2005)
% modified by Noriaki (9 giugno 2006)

mfactor=1000;
cancelFlag = 0;
fs=      [];
window=  [];
binsize= [];
binpeak= [];
cancwin= [];

PopupPrompt  = {'Correlation window (msec)', 'Binsize (msec)', ...
                'Half area around the correlation peak (# of bin)', ...
                'Artifact cancellation window (msec)', 'Sampling frequency (samples/sec)'};         
PopupTitle   = 'Set Cross Correlation parameters';
PopupLines   = 1;
PopupDefault = {'150', '5', '1', '4', GlobalsParams.DEFAULT_FS_CHAR};
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault);

if isempty(Ianswer)
    cancelFlag = 1;
else
    fs=      str2num(Ianswer{5,1});            % Sampling frequency
    window=  str2num(Ianswer{1,1})*fs/mfactor; % Correlation window [samples]
    binsize= str2num(Ianswer{2,1})*fs/mfactor; % Binsize for correlation [samples]
    binpeak= str2num(Ianswer{3,1});            % Half-number of bins in the peak zone
    cancwin= str2num(Ianswer{4,1})*fs/mfactor; % Artifact cancwin [samples]
end