function [el, ibibin, ibiwin, ylim, fs, cancelFlag]= uigetIBIinfo(single)
% 
% by Michela Chiappalone (26 Maggio 2006)
% modified by Noriaki

cancelFlag = 0;
fs         =  [];
ibibin     =  [];
ibiwin     =  [];
ylim       =  [];
el = [];

PopupTitle   = 'Inter Burst Interval - IBI Histogram)';   
PopupPrompt  = {'IBI bin [sec]', 'IBI window [sec]', ...
                'Ylim [0,1]', 'Sampling frequency [samples/sec]', 'Channel number'};         
PopupLines   = 1;
PopupDefault = {'1', '20', '1', GlobalsParams.DEFAULT_FS_CHAR, '12'};

if (single==1)
    Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault);
    if isempty(Ianswer)
        cancelFlag = 1;
    else
        %Make a check on the channel name
        el      = str2double(Ianswer{5,1});           % Electrode whose IBI must be plotted
    end
else
    Ianswer = inputdlg(PopupPrompt(1:end-1),PopupTitle,PopupLines,PopupDefault(1:end-1));
    el=0;
end

if isempty(Ianswer)
    cancelFlag = 1;
else
    fs         =  str2double(Ianswer{4,1});           % Sampling frequency
    ibibin     =  str2double(Ianswer{1,1});          % Bin of the IBI [sec]
    ibiwin     =  str2double(Ianswer{2,1});      % Window of the IBI [sec]
    ylim       =  str2double(Ianswer{3,1});        % Limit of the Y-axis for the IBI plot
end