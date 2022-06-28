function varargout = aVaGUI(varargin)
% AVAGUI M-file for aVaGUI.fig
%      AVAGUI, by itself, creates a new AVAGUI or raises the existing
%      singleton*.
%
%      H = AVAGUI returns the handle to a new AVAGUI or the handle to
%      the existing singleton*.
%
%      AVAGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AVAGUI.M with the given input arguments.
%
%      AVAGUI('Property','Value',...) creates a new AVAGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before aVaGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to aVaGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help aVaGUI

% Last Modified by GUIDE v2.5 14-May-2007 10:06:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @aVaGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @aVaGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% -------------------------------------------------------------------------
% --- Executes just before aVaGUI is made visible.
function aVaGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to aVaGUI (see VARARGIN)
% Choose default command line output for aVaGUI
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes aVaGUI wait for user response (see UIRESUME)
% uiwait(handles.aVaGUI);

% -------------------------------------------------------------------------
% --- Outputs from this function are returned to the command line.
function varargout = aVaGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;


% -------------------------------------------------------------------------
% --- Executes on button press in button_aVa.
function button_aVa_Callback(hObject, eventdata, handles)
% hObject    handle to button_aVa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
aVa

% -------------------------------------------------------------------------
% --- Executes on button press in button_IEI.
function button_IEI_Callback(hObject, eventdata, handles)
% hObject    handle to button_IEI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
aVaIEI

% -------------------------------------------------------------------------
% --- Executes on button press in button_aVaIMT.
function button_aVaIMT_Callback(hObject, eventdata, handles)
% hObject    handle to button_aVaIMT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
aVaIMT

% -------------------------------------------------------------------------
% --- Executes on button press in button_fig.
function button_fig_Callback(hObject, eventdata, handles)
% hObject    handle to button_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% select the aVa results folder
exp_folder = uigetdir(pwd,'Select the aVa results folder');
if strcmp(num2str(exp_folder),'0')          % halting case
    errordlg('Selection failed: end of session','Error')
    return
end
cd(exp_folder)
% look for figures in the selected folder
[files,bytes,names] = dirr(exp_folder,['\.fig'],'name');
if isempty(names)
    errordlg(['No .fig file in ', exp_folder, ' and its subdirectories'],'Error')
    return
end
indexes = cellfun('isempty',regexp(names, '(expBinning)*','once'));
% convert structure to an array of strings
temp = char(names);
charNames = temp(indexes,:);
maxValue = size(charNames,1);
% associate data with UserData properties
set(hObject,'UserData',charNames)
% set min and max value of the slider and enable it
set(handles.slider_fig, 'Min', 1)
set(handles.slider_fig, 'Max', maxValue)
set(handles.slider_fig, 'Value', 1)
set(handles.slider_fig, 'SliderStep', [1/maxValue 2/maxValue])
set(handles.slider_fig, 'Enable', 'on')
% open the first figure
hFig = openfig(deblank(charNames(1,:)), 'new', 'visible');
% set the position and the dimension of the figure
set(hFig, 'position', [440 230 540 400])
% make the button_close visible
set(handles.button_close, 'enable', 'on')

% -------------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% -------------------------------------------------------------------------
% --- Executes on button press in button_close.
function button_close_Callback(hObject, eventdata, handles)
% hObject    handle to button_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% get the handle of the current figure and close it
% hCurFig = get(handles.button_rew, 'UserData');
% make the buttons ff,rew and close invisible
set(handles.slider_fig, 'enable', 'off')
set(hObject, 'enable', 'off')
%close all

% -------------------------------------------------------------------------
function aboutaVa_Callback(hObject, eventdata, handles)
% hObject    handle to aboutaVa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpdlg('aVa v1.1.7 - Released January, 2008','About aVa')


% --- Executes on slider movement.
function slider_fig_Callback(hObject, eventdata, handles)
% hObject    handle to slider_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
index = round((get(hObject, 'Value')));         %trova il valore dello slider, lo arrotonda all'intero
absIndex = abs(index);                          %ne fa il modulo
set(hObject, 'Value', absIndex);                %setta il Value dello slider al valore arrotondato
% retrieve file names
charNames = get(handles.button_fig, 'UserData');
% open the requested fig and set position
figName = deblank(charNames(absIndex,:));
hFig = findobj('FileName',figName);
if(~isempty(hFig))
    figure(hFig)
else
    hFig = openfig(figName);
end
set(hFig, 'position', [440 230 540 400])


% --- Executes during object creation, after setting all properties.
function slider_fig_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --------------------------------------------------------------------
function aVaHelp_Callback(hObject, eventdata, handles)
% hObject    handle to aVaHelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpdlg('Coming soon...','!!Help!!')



% --- Executes on button press in button_aVaRS.
function button_aVaRS_Callback(hObject, eventdata, handles)
% hObject    handle to button_aVaRS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
aVaRS

