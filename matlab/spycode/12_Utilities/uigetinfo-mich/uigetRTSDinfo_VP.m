function [plp, rp, alignFlag, art_thresh_analog, art_thresh_elec, art_dist, nstd, fs, w_pre, w_post, interpolation, cancelFlag]= uigetRTSDinfo_VP()
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
alignFlag = [];
art_dist = [];
nstd = [];
w_pre = [];
w_post = [];
interpolation = [];

PopupPrompt  = {'Standard deviation coefficient', 'Peak Lifetime Period (PLP) (ms)', 'Refractory Period (RP) (ms)',  'Alignment (0 = higher peak; !0 = negative peak)',...
                'Artefact threshold (for Analog Raw Data stream) (mV)','Artefact threshold (for Electrode Raw Data stream) (uV)','Maximum stimulation frequency (Hz)','Sampling frequency (samples/sec)',...
                'w_pre (samples)',...
                'w_post (samples)',...
                'Spike waveform interpolation?'};         
PopupTitle   = 'Set PTSD parameters';
PopupLines   = 1;
PopupDefault = {'8','2.0','1.0','0','200','200','50',GlobalsParams.DEFAULT_FS_CHAR,'10','22','Yes'};
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault);

if isempty(Ianswer)
    cancelFlag = 1;    
else
    fs=         str2double(Ianswer{8,1});            % Sampling frequency
    nstd=       str2double(Ianswer{1,1});            % Coefficient for defining the PD threshold
    plp=        str2double(Ianswer{2,1})*fs/mfactor; % Peak Lifetime Period in number of samples
    rp=         str2double(Ianswer{3,1})*fs/mfactor; % Refractory Period in number of samples
    alignFlag=  str2double(Ianswer{4,1});
    art_thresh_analog = str2double(Ianswer{5,1});            % Artifact amplitude thresh for Analog Raw Data stream (mV)
    art_thresh_elec = str2double(Ianswer{6,1});            % Artifact amplitude thresh for Electrode Raw Data stream (uV)
    art_dist=   (1/str2double(Ianswer{7,1}))*fs;         % Minimum distance between two consecutive stimuli (samples) 
    w_pre = str2double(Ianswer{9,1});
    w_post = str2double(Ianswer{10,1});
    if strcmp(Ianswer{11,1},'Yes'), interpolation = 1; else interpolation = 0; end
end