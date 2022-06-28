% GUI_ccorr_reset.m
% Script called when the reset button is pushed and when quitting the panel

% by Michela Chiappalone ( 12 Febbraio 2007)

set(handles.pushbutton_browseinput, 'Enable', 'off');
set(handles.text_input,  'String', 'Input Folder');

% Cross correlation parameters
set(handles.radiobutton_ccorr, 'Value', 0);
set(handles.uipanel_CcorrPar,  'Visible', 'off');
set(handles.edit_ccorrwindow,  'String', 150);
set(handles.edit_binsize,      'String', 5);

% Functional Connectivity parameters
set(handles.radiobutton_functcon, 'Value', 0);
set(handles.uipanel_FunctCon,     'Visible', 'off');
set(handles.edit_halfareapeak,    'String', 1);
set(handles.edit_threshold,       'String', 0.2);

% Plot parameters - TO BE ADDED
set(handles.radiobutton_plot,     'Value', 0);
set(handles.uipanel_PlotOptions,  'Visible', 'off');