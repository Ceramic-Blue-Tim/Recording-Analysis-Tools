function [pdwin, art_thresh, art_dist, nstd, fs, cancelFlag]= uigetPDinfo();
% 
% by Michela Chiappalone (3 Maggio 2005)
% modified by Noriaki (9 giugno 2006)

mfactor=1000;
cancelFlag = 0;
fs = [];
pdwin = [];
art_thresh = [];
art_dist = [];
nstd = [];

PopupPrompt  = {'Sliding window length (msec)', 'Artifact threshold (uV)', ...
                'Minimum artifact distance (sec)', 'Standard deviation coefficient', ...
                'Sampling frequency (samples/sec)'};         
PopupTitle   = 'Set Peak Detection parameters';
PopupLines   = 1;
PopupDefault = {'2', '800', '0.5', '8', GlobalsParams.DEFAULT_FS_CHAR};
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault);

if isempty(Ianswer)
    cancelFlag = 1;    
else
    fs=         str2num(Ianswer{5,1});            % Sampling frequency
    pdwin=      str2num(Ianswer{1,1})*fs/mfactor; % PD window in number of samples
    art_thresh= str2num(Ianswer{2,1});            % Artifact amplitude thresh
    art_dist=   str2num(Ianswer{3,1})*fs;         % Minimum distance between two consecutive stimuli (samples)
    nstd=       str2num(Ianswer{4,1});            % Coefficient for defining the PD threshold
end