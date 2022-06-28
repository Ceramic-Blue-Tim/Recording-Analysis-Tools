function [exp_num, stim_phases, pre_tetanusID, minarea, jimbo, coactive]= uigetPSTHinfo()
% Prompt a user-window for input information regarding the current
% experiment
% by Michela Chiappalone (19 Maggio 2005)

% Vector containing the information for the tetanic sites in the selected
% experiments
tetanic= [101 23 35; 102 31 86; 112 57 35; 215 52 44; 231 33 14;...          % Co-activation Jimbo
          148 36  0; 180 34  0; 187 33  0; 189 43  0; 191 28  0; ...         % Tetanus Jimbo
          209 16 74; 223 55 62; 229 38 46; 235 36 44; 237 12 23; 242 27 84]; % Co-activation isofreq

PopupPrompt  = {'Experiment number', 'Enter the number of stimulation phases', ...
                'Enter the stim phase before the tetanus', 'Enter the minimum allowed PSTH area'};         
PopupTitle   = 'Input for PSTH settings';
PopupLines   = 1;
PopupDefault = {'100', '4', 'stim2', '1'};
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault);

exp_num = str2double(Ianswer{1,1});
stim_phases = str2double(Ianswer{2,1});
pre_tetanus = Ianswer{3,1};
pre_tetanusID = str2num(pre_tetanus(end));
minarea = str2double(Ianswer{4,1});

% Number of tetanic sites from the selected experiment
index=find(exp_num==tetanic);
jimbo= tetanic (index, 2);
coactive= tetanic (index, 3);
   
clear Ianswer PopupPrompt PopupTitle PopupLines PopupDefault pre_tetanus index