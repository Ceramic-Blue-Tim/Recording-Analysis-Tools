function [plp, rp , art_thresh_analog, art_thresh_elec, art_dist, nstd, fs, cancelFlag]= uigetRTSDinfo()
% 
% by Mauro Gandolfo (28 Ottobre 2006)
% by VP, March 2010


mfactor=1000;
cancelFlag = 0;
fs = [];
plp = [];
rp = [];
art_thresh_analog = [];
art_thresh_elec = [];
art_dist = [];
nstd = [];

PopupPrompt  = {'Standard deviation coefficient', 'Peak Lifetime Period (PLP) (ms)', 'Refractory Period (RP) (ms)',  ...
                'Artefact threshold (for Analog Raw Data stream) (mV)','Artefact threshold (for Electrode Raw Data stream) (uV)','Maximum stimulation frequency (Hz)','Sampling frequency (samples/sec)'};         
PopupTitle   = 'Set PTSD parameters';
PopupLines   = 1;
PopupDefault = {'8','2.0','1.0','200','200','50', GlobalsParams.DEFAULT_FS_CHAR};
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault);

if isempty(Ianswer)
    cancelFlag = 1;    
else
    fs=         str2double(Ianswer{7,1});            % Sampling frequency
    nstd=       str2double(Ianswer{1,1});            % Coefficient for defining the PD threshold
    plp=        str2double(Ianswer{2,1})*fs/mfactor; % Peak Lifetime Period in number of samples
    rp=         str2double(Ianswer{3,1})*fs/mfactor; % Refractory Period in number of samples
    art_thresh_analog = str2double(Ianswer{4,1});            % Artifact amplitude thresh for Analog Raw Data stream (mV)
    art_thresh_elec = str2double(Ianswer{5,1});            % Artifact amplitude thresh for Electrode Raw Data stream (uV)
    art_dist=   (1/str2double(Ianswer{6,1}))*fs;         % Minimum distance between two consecutive stimuli (samples) 
end