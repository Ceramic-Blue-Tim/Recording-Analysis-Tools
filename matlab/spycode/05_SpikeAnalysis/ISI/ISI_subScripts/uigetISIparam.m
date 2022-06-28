% uigetISIparam.m
% by Valentina Pasquale - March, 2008
function [retArgs] = uigetISIparam()
% User inputs for ISI calculation:
% retArgs.nBinsPerDec = number of bins the histogram must have per decade
% retArgs.sf = sampling frequency (to be cancelled in future versions)
% retArgs.cancelFlag = flag for aborting
retArgs = struct('nBinsPerDec',[],'sf',[],'cancelFlag',0);
PopupPrompt  = {'Number of bins per decade', 'Sampling frequency [Hz]'};         
PopupTitle   = 'Inter Spike Interval - ISI Histogram - 8x8 layout)';
PopupLines   = 1;
PopupDefault = {'10', GlobalsParams.DEFAULT_FS_CHAR};
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault);
if isempty(Ianswer)
    retArgs.cancelFlag = 1;
else
    retArgs.sf              =  str2double(Ianswer{2,1});    
    retArgs.nBinsPerDec     =  str2double(Ianswer{1,1});    
end