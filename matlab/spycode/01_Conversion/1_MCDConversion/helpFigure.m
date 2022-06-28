function varargout = helpFigure(varargin)
% HELPFIGURE M-file for helpFigure.fig
%      HELPFIGURE, by itself, creates a new HELPFIGURE or raises the existing
%      singleton*.
%
%      H = HELPFIGURE returns the handle to a new HELPFIGURE or the handle to
%      the existing singleton*.
%
%      HELPFIGURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HELPFIGURE.M with the given input arguments.
%
%      HELPFIGURE('Property','Value',...) creates a new HELPFIGURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before helpFigure_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to helpFigure_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help helpFigure

% Last Modified by GUIDE v2.5 05-Mar-2007 01:23:53

% Begin initialization code - DO NOT EDIT

% Created by Luca Leonardo Bologna on February 2007

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @helpFigure_OpeningFcn, ...
                   'gui_OutputFcn',  @helpFigure_OutputFcn, ...
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


% --- Executes just before helpFigure is made visible.
function helpFigure_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to helpFigure (see VARARGIN)

% Choose default command line output for helpFigure
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes helpFigure wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = helpFigure_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function helpTextEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to helpTextEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in okPushbutton.
function okPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to okPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
closereq;


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if ~strcmpi(get(hObject,'waitstatus'),'waiting')
    delete(hObject);
    return;
else
    delete(hObject);
end