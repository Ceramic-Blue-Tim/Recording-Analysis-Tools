function varargout = extractedNamesChoiceWindow(varargin)
% EXTRACTEDNAMESCHOICEWINDOW M-file for extractedNamesChoiceWindow.fig
%      EXTRACTEDNAMESCHOICEWINDOW, by itself, creates a new EXTRACTEDNAMESCHOICEWINDOW or raises the existing
%      singleton*.
%
%      H = EXTRACTEDNAMESCHOICEWINDOW returns the handle to a new EXTRACTEDNAMESCHOICEWINDOW or the handle to
%      the existing singleton*.
%
%      EXTRACTEDNAMESCHOICEWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXTRACTEDNAMESCHOICEWINDOW.M with the given input arguments.
%
%      EXTRACTEDNAMESCHOICEWINDOW('Property','Value',...) creates a new EXTRACTEDNAMESCHOICEWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before extractedNamesChoiceWindow_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to extractedNamesChoiceWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help extractedNamesChoiceWindow

% Begin initialization code - DO NOT EDIT

% Created by Luca Leonardo Bologna 02 February 2007

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @extractedNamesChoiceWindow_OpeningFcn, ...
    'gui_OutputFcn',  @extractedNamesChoiceWindow_OutputFcn, ...
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


% --- Executes just before extractedNamesChoiceWindow is made visible.
function extractedNamesChoiceWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to extractedNamesChoiceWindow (see VARARGIN)

% Choose default command line output for extractedNamesChoiceWindow
handles.output = hObject;
handles.validMcdFilesNames=varargin;
% handles variable containing the answer the user give when closing the
% window
handles.answer='';
% handles variable containing the files fulfilling the conditions the user
% inserted
handles.filesToConvert=[];
% set window's objects
set(handles.namesListbox,'String',sortrows(char(handles.validMcdFilesNames{:}),1));
set(handles.namesListbox,'Max',length(varargin{:}));
set(handles.namesListbox,'Value',1);
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes extractedNamesChoiceWindow wait for user response (see UIRESUME)
uiwait(handles.extractedNamesChoiceWindow);

% --- Outputs from this function are returned to the command line.
function varargout = extractedNamesChoiceWindow_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
% variable
varargout{1}=handles.output;
varargout{2}=handles.answer;
varargout{3}=handles.filesToConvert;
delete (hObject);

function extractedNamesChoiceWindow_CreateFcn(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function namesListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to namesListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in selectAllButton.
function selectAllButton_Callback(hObject, eventdata, handles)
% hObject    handle to selectAllButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.namesListbox,'Value',1:size((get(handles.namesListbox,'String')),1));

% --- Executes on button press in cancelPushbutton.
function cancelPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.answer ='Cancel';
guidata(hObject, handles);
uiresume;

% --- Executes on button press in okPushbutton.
function okPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to okPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(get(handles.namesListbox,'Value'))
    warndlg('No files selected','!! Warning !!');
else
    handles.answer ='OK';
    filesToConvertTemp=get(handles.namesListbox,'String');
    handles.filesToConvert=filesToConvertTemp(get(handles.namesListbox,'Value'),:);
    guidata(hObject, handles);
    uiresume;
end

% --- Executes when user attempts to close extractedNamesChoiceWindow.
function extractedNamesChoiceWindow_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to extractedNamesChoiceWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if ~strcmpi(get(hObject,'waitstatus'),'waiting')
    delete(hObject);
    return;
end
handles.answer ='Cancel';
guidata(hObject, handles);
uiresume;