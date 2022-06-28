function varargout = waitWindow(varargin)
% WAITWINDOW M-file for waitWindow.fig
%      WAITWINDOW, by itself, creates a new WAITWINDOW or raises the existing
%      singleton*.
%
%      H = WAITWINDOW returns the handle to a new WAITWINDOW or the handle to
%      the existing singleton*.
%
%      WAITWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WAITWINDOW.M with the given input arguments.
%
%      WAITWINDOW('Property','Value',...) creates a new WAITWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before waitWindow_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to waitWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help waitWindow

% Last Modified by GUIDE v2.5 04-Mar-2007 19:41:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @waitWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @waitWindow_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
               
if nargin && ischar(varargin{1}) &&  (length(varargin{1})<25)
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before waitWindow is made visible.
function waitWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to waitWindow (see VARARGIN)

% Choose default command line output for waitWindow
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
set(handles.text1,'String',varargin{1});
guidata(hObject, handles);

% UIWAIT makes waitWindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = waitWindow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if ~strcmpi(get(hObject,'waitstatus'),'waiting')
    delete(hObject);
    return;
end
delete(hObject);