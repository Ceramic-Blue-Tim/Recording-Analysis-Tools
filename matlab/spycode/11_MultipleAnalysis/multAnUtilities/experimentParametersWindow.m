function varargout = experimentParametersWindow(varargin)
% EXPERIMENTPARAMETERSWINDOW M-file for experimentParametersWindow.fig
%      EXPERIMENTPARAMETERSWINDOW, by itself, creates a new EXPERIMENTPARAMETERSWINDOW or raises the existing
%      singleton*.
%
%      H = EXPERIMENTPARAMETERSWINDOW returns the handle to a new EXPERIMENTPARAMETERSWINDOW or the handle to
%      the existing singleton*.
%
%      EXPERIMENTPARAMETERSWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPERIMENTPARAMETERSWINDOW.M with the given input arguments.
%
%      EXPERIMENTPARAMETERSWINDOW('Property','Value',...) creates a new EXPERIMENTPARAMETERSWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before experimentParametersWindow_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to experimentParametersWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help experimentParametersWindow

% Last Modified by GUIDE v2.5 05-Mar-2007 00:33:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @experimentParametersWindow_OpeningFcn, ...
    'gui_OutputFcn',  @experimentParametersWindow_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})&& ~isdir(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before experimentParametersWindow is made visible.
function experimentParametersWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to experimentParametersWindow (see VARARGIN)

% Choose default command line output for experimentParametersWindow
handles.output = hObject;
% create internal variables used when exiting the window
handles.answer='';
handles.chosenParameters={};
handles.rootFolder=varargin{1};
set(findobj('Tag','rootFolderPathText'),'String',handles.rootFolder);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes experimentParametersWindow wait for user response (see UIRESUME)
uiwait(hObject);

% --- Outputs from this function are returned to the command line.
function varargout = experimentParametersWindow_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.answer;
varargout{3} = handles.chosenParameters;

% --- Executes during object creation, after setting all properties.
function orFoldersEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to orFoldersEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function andFoldersEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to andFoldersEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in allFoldersRadiobutton.
function allFoldersRadiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to allFoldersRadiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of allFoldersRadiobutton
if (get(hObject,'Value')==1)
    set(findobj('Tag','conditionalFoldersRadiobutton'),'Value',0);
    set(findobj('-regexp','Tag','.*FoldersText.*'),'Enable','off');
    set(findobj('-regexp','Tag','.*FoldersEdit.*'),'Enable','off');
    set(findobj('-regexp','Tag','.*FoldersEdit.*'),'String','');
    set(findobj('-regexp','Tag','.*reset.*Folders.*'),'Enable','off');
else
    set(hObject,'Value',1);
end
% --- Executes on button press in conditionalFoldersRadiobutton.
function conditionalFoldersRadiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to conditionalFoldersRadiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value')==1)
    %set objects properties
    set(findobj('-regexp','Tag','.*allFoldersRadiobutton.*'),'Value',0);
    set(findobj('-regexp','Tag','.*FoldersEdit.*'),'Enable','on');
    set(findobj('-regexp','Tag','.*FoldersEdit.*'),'String','');
    set(findobj('-regexp','Tag','.*FoldersText.*'),'Enable','on');
    set(findobj('-regexp','Tag','.*reset.*Folders.*'),'Enable','on');
    uicontrol(findobj('-regexp','Tag','andFoldersEdit*'));
else
    set(hObject,'Value',1);
end
% Hint: get(hObject,'Value') returns toggle state of conditionalFoldersRadiobutton
function andFoldersEdit_Callback(hObject, eventdata, handles)
% hObject    handle to andFoldersEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of andFoldersEdit as text
%        str2double(get(hObject,'String')) returns contents of andFoldersEdit as a double

function orFoldersEdit_Callback(hObject, eventdata, handles)
% hObject    handle to orFoldersEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of orFoldersEdit as text
%        str2double(get(hObject,'String')) returns contents of orFoldersEdit as a double

% --- Executes on button press in resetAndFoldersPushbutton.
function resetAndFoldersPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to resetAndFoldersPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(findobj('Tag','andFoldersEdit'),'String','');


% --- Executes on button press in resetOrFoldersPushbutton.
function resetOrFoldersPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to resetOrFoldersPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(findobj('Tag','orFoldersEdit'),'String','');


% --- Executes on button press in okPushbutton.
function okPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to okPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
allFoldersRadiobuttonValue=get(findobj('Tag','allFoldersRadiobutton'),'Value');
andFoldersEditString=regexp(get(findobj('Tag','andFoldersEdit'),'String'),'\w*','match');
orFoldersEditString=regexp(get(findobj('Tag','orFoldersEdit'),'String'),'\w*','match');
answer = displayMultipleAnalysisChosenConditions(handles.rootFolder, allFoldersRadiobuttonValue, ...
    andFoldersEditString, orFoldersEditString);
% if the user decided not to abort operation
if (~strcmp(answer,'Cancel'))
    handles.answer ='OK';
    chosenParametersTemp(1)={allFoldersRadiobuttonValue};
    chosenParametersTemp(2)={andFoldersEditString};
    chosenParametersTemp(3)={orFoldersEditString};
    handles.chosenParameters=chosenParametersTemp;
    guidata(hObject, handles);
    uiresume;
end

% --- Executes on button press in cancelPushbutton.
function cancelPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.answer ='Cancel';
guidata(hObject, handles);
uiresume;


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
handles.answer ='Cancel';
guidata(hObject, handles);
uiresume;





% --- Executes on button press in helpPushbutton.
function helpPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to helpPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpMuFigure;

