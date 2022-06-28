function [fs, starttime, endtime, startend , cancelFlag]=uigetRASTERinfo()
%
%
% by Michela Chiappalone (6 Febbraio 2006)
% modified by Noriaki (9 giugno 2006)

cancelFlag = 0;
fs = [];
starttime = [];
endtime   = [];
startend  = [];
    

prompt  = {'Start time (sec)', 'End time (sec) | -1 = automatic', ...
           'Sampling frequency (samples/sec)'};         
title   = 'Plot settings';
lines   = 1;
def     = {'0', '-1', GlobalsParams.DEFAULT_FS_CHAR};
Ianswer = inputdlg(prompt,title,lines,def);

if isempty(Ianswer)    
    cancelFlag = 1;
else
    fs        = str2num(Ianswer{3,1});    % Sampling frequency
    starttime = str2num(Ianswer{1,1})*fs; % beginning of the raster [sample]
    endtime   = str2num(Ianswer{2,1})*fs; % end of the raster       [sample]
    startend  = strcat(Ianswer{1,1}, '-', Ianswer{2,1}, 'sec');
    clear title prompt lines def
    if  isempty(starttime)|isempty(endtime)|isempty(fs)
        msgbox ('Not Valid Input','End of Function', 'error')
        return
    end

    if (Ianswer{1,1}=='0')
        starttime=1;
    end
end
