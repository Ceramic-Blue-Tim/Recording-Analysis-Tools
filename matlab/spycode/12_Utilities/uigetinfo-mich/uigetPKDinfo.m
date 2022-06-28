function [art_thresh, art_dist, fs]= uigetPKDinfo();
% 
% by Michela Chiappalone (3 Maggio 2005)

PopupPrompt  = {'Artifact threshold (uV)', 'Minimum artifact distance (sec)', 'Sampling frequency (samples/sec)'};         
PopupTitle   = 'Set Artifact Detection parameters';
PopupLines   = 1;
PopupDefault = {'800', '0.5', GlobalsParams.DEFAULT_FS_CHAR};
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault);

mfactor=1000;

fs=         str2num(Ianswer{3,1});            % Sampling frequency
art_thresh= str2num(Ianswer{1,1});            % Artifact amplitude thresh
art_dist=   str2num(Ianswer{2,1})*fs;         % Minimum distance between two consecutive stimuli (samples)
