
function [psthend,yaxis,list_stimel,num_stimel,cancelFlag] = uiget8x8gridinfo ();

% OUTPUT variables:
%     PSTHEND = timeframe (msec) of the PSTH plot (X-axis)
%     YAXIS = bin size (msec) used to compute the PSTH 
%     LIST_STIMEL = list of stimulus sessions
%     NUM_STIMEL = number of stimulus sessions

cancelFlag = 0;
psthend = []; 
yaxis = [];
list_stimel = [];
num_stimel = [];


prompt  = {'Stimulus sessions separated by -', 'PSTH time frame to display (msec)','Y-axis Lim'};         
title   = 'Plot multiple PSTH settings';
lines   = 1;
def     = {'1-2', '400', '2'};
Ianswer = inputdlg(prompt,title,lines,def);

if isempty(Ianswer)
    cancelFlag = 1;
else
    charStimSectionList = Ianswer{1,1};    % list of stimulus session
    psthend=  str2double(Ianswer{2,1});    % Timeframe of the PSTH plot (X-axis)
    yaxis = str2double(Ianswer{3,1});    % maximum PSTH peak
    notmarker = find(charStimSectionList ~= '-');
    selectedStimSectionList = charStimSectionList(notmarker);
    num_stimel = length(selectedStimSectionList);

    list_stimel = [];
    for i=1:num_stimel
        list_stimel = [list_stimel str2num(selectedStimSectionList(i))];
    end
    num_stimel = length(list_stimel);
end