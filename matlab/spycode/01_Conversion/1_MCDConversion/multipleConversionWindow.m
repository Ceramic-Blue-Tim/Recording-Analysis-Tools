function varargout = multipleConversionWindow(varargin)
% MULTIPLECONVERSIONWINDOW M-file for multipleConversionWindow.fig
%      MULTIPLECONVERSIONWINDOW, by itself, creates a new MULTIPLECONVERSIONWINDOW or raises the existing
%      singleton*.
%
%      H = MULTIPLECONVERSIONWINDOW returns the handle to a new MULTIPLECONVERSIONWINDOW or the handle to
%      the existing singleton*.
%
%      MULTIPLECONVERSIONWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MULTIPLECONVERSIONWINDOW.M with the given
%      input arguments.
%
%      MULTIPLECONVERSIONWINDOW('Property','Value',...) creates a new MULTIPLECONVERSIONWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before multipleConversionWindow_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property
%      application
%      stop.  All inputs are passed to multipleConversionWindow_Fcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help multipleConversionWindow
% Last Modified by GUIDE v2.5 28-Mar-2007 12:54:54
% Begin initialization code - DO NOT EDIT
%
%  Created by Luca Leonardo Bologna January 2007


gui_Singleton = 1;
gui_State = struct('gui_Name', mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @multipleConversionWindow_OpeningFcn, ...
    'gui_OutputFcn',  @multipleConversionWindow_OutputFcn, ...
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
% --- Executes just before multipleConversionWindow is made visible.
function multipleConversionWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to multipleConversionWindow (see VARARGIN)
% Choose default command line output for multipleConversionWindow
handles.output = hObject;
% create internal variables used when exiting the window
handles.answer='';
handles.chosenParameters={};
handles.rootFolder=varargin{1};
handles.extension=varargin{2};

set(findobj('Tag','rootFolderText'),'String',handles.rootFolder);
set(hObject,'Name',['Multiple '  handles.extension ' conversion parameters']);
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes multipleConversionWindow wait for user response (see UIRESUME)
uiwait(handles.MultipleConversionWindow);

% --- Outputs from this function are returned to the command line.
function varargout = multipleConversionWindow_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure

varargout{1}=handles.output;
varargout{2}=handles.answer;
varargout{3}=handles.chosenParameters;
% close (handles.MultipleConversionWindow);

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
function andFilesEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to andFilesEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function orFilesEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to orFilesEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in allMcdCheckbox.
function allMcdCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to allMcdCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of allMcdCheckbox
if (get(hObject,'Value')==1)
    %set objects properties
    foldersPanelChildren=get(handles.foldersPanel,'Children');
    set(foldersPanelChildren(:),'Enable','off');
    filesPanelChildren=get(handles.filesPanel,'Children');
    set(filesPanelChildren(:),'Enable','off');
    set(findobj('Style','edit'),'String','');
    set(findobj('-regexp','Tag','.*Radiobutton.*'),'Value',0);
else
    %set objects properties
    set(findobj('-regexp','Tag','.*Radiobutton.*'),'Enable','on');
    set(findobj('-regexp','Tag','.*all.*Radiobutton.*'),'Value',1);
    set(findobj('-regexp','Tag','(files|folders)Text'),'Enable','on');
end

% --- Executes on button press in allFoldersRadiobutton.
function allFoldersRadiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to allFoldersRadiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of allFoldersRadiobutton
if (get(hObject,'Value')==1)
    set(findobj('Tag','foldersRadiobutton'),'Value',0);
    set(findobj('-regexp','Tag','.*FoldersText.*'),'Enable','off');
    set(findobj('-regexp','Tag','.*FoldersEdit.*'),'Enable','off');
    set(findobj('-regexp','Tag','.*FoldersEdit.*'),'String','');
    set(findobj('-regexp','Tag','.*reset.*Folders.*'),'Enable','off');
else
    set(hObject,'Value',1);
end
% --- Executes on button press in foldersRadiobutton.
function foldersRadiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to foldersRadiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of foldersRadiobutton
if (get(hObject,'Value')==1)
    %set objects properties
    set(findobj('-regexp','Tag','.*FoldersEdit.*'),'Enable','on');
    set(findobj('-regexp','Tag','.*FoldersEdit.*'),'String','');
    set(findobj('-regexp','Tag','.*FoldersText.*'),'Enable','on');
    set(findobj('-regexp','Tag','.*allFoldersRadiobutton.*'),'Value',0);
    set(findobj('-regexp','Tag','.*reset.*Folders.*'),'Enable','on');
    uicontrol(findobj('-regexp','Tag','andFoldersEdit*'));
else
    set(hObject,'Value',1);
end

% --- Executes on button press in allFilesRadiobutton.
function allFilesRadiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to allFilesRadiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of allFilesRadiobutton
if (get(hObject,'Value')==1)
    %set objects properties
    set(findobj('Tag','filesRadiobutton'),'Value',0);
    set(findobj('-regexp','Tag','.*FilesText.*'),'Enable','off');
    set(findobj('-regexp','Tag','.*FilesEdit.*'),'Enable','off');
    set(findobj('-regexp','Tag','.*FilesEdit.*'),'String','');
    set(findobj('-regexp','Tag','.*reset.*Files.*'),'Enable','off');
else
    set(hObject,'Value',1);
end
% --- Executes on button press in filesRadiobutton.
function filesRadiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to filesRadiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of filesRadiobutton
if (get(hObject,'Value')==1)
    %set objects properties
    set(findobj('-regexp','Tag','.*FilesEdit.*'),'Enable','on');
    set(findobj('-regexp','Tag','.*FilesEdit.*'),'String','');
    set(findobj('-regexp','Tag','.*FilesText.*'),'Enable','on');
    set(findobj('-regexp','Tag','.*allFilesRadiobutton.*'),'Value',0);
    set(findobj('-regexp','Tag','.*reset.*Files.*'),'Enable','on');
    uicontrol(findobj('-regexp','Tag','andFilesEdit*'));
else
    set(hObject,'Value',1);
end

% --- Executes on button press in resetAndFolders.
function resetAndFolders_Callback(hObject, eventdata, handles)
% hObject    handle to resetAndFolders (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(findobj('Tag','andFoldersEdit'),'String','');

% --- Executes on button press in resetOrFolders.
function resetOrFolders_Callback(hObject, eventdata, handles)
% hObject    handle to resetOrFolders (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(findobj('Tag','orFoldersEdit'),'String','');

% --- Executes on button press in resetOrFiles.
function resetOrFiles_Callback(hObject, eventdata, handles)
% hObject    handle to resetOrFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(findobj('Tag','orFilesEdit'),'String','');

% --- Executes on button press in resetAndFiles.
function resetAndFiles_Callback(hObject, eventdata, handles)
% hObject    handle to resetAndFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(findobj('Tag','andFilesEdit'),'String','');

% --- Executes on button press in okButton.
function okButton_Callback(hObject, eventdata, handles)
% hObject    handle to okButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% read component value
allMcdCheckboxValue=get(findobj('Tag','allMcdCheckbox'),'Value');
deleteMcdFilesCheckboxValue=get(findobj('Tag','deleteMcdFilesCheckbox'),'Value');

allFoldersRadiobuttonValue=get(findobj('Tag','allFoldersRadiobutton'),'Value');
allFilesRadiobuttonValue=get(findobj('Tag','allFilesRadiobutton'),'Value');
andFoldersEditString=regexpi(get(findobj('Tag','andFoldersEdit'),'String'),'\w*','match');
orFoldersEditString=regexpi(get(findobj('Tag','orFoldersEdit'),'String'),'\w*','match');
andFilesEditString=regexpi(get(findobj('Tag','andFilesEdit'),'String'),'\w*','match');
orFilesEditString=regexpi(get(findobj('Tag','orFilesEdit'),'String'),'\w*','match');
answer = displayChosenConditions(handles.rootFolder,allMcdCheckboxValue, allFoldersRadiobuttonValue, allFilesRadiobuttonValue,...
    andFoldersEditString, orFoldersEditString, andFilesEditString, orFilesEditString);
% if the user decided not to abort operation
if (~strcmp(answer,'Cancel'))
    handles.answer ='OK';
    chosenParametersTemp(1)={allMcdCheckboxValue};
    chosenParametersTemp(2)={allFoldersRadiobuttonValue};
    chosenParametersTemp(3)={allFilesRadiobuttonValue};
    chosenParametersTemp(4)={andFoldersEditString};
    chosenParametersTemp(5)={orFoldersEditString};
    chosenParametersTemp(6)={andFilesEditString};
    chosenParametersTemp(7)={orFilesEditString};
    chosenParametersTemp(8)={deleteMcdFilesCheckboxValue};
    handles.chosenParameters=chosenParametersTemp;
    guidata(hObject, handles);
    uiresume;
end

% --- Executes on button press in cancelButton.
function cancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.answer ='Cancel';
guidata(hObject, handles);
uiresume;

% --- Executes on button press in helpPushbutton.
function helpPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to helpPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpFigure

% --- Executes when user attempts to close MultipleConversionWindow.
function MultipleConversionWindow_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to MultipleConversionWindow (see GCBO)
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

% --- Executes on button press in deleteMcdFilesCheckbox.
function deleteMcdFilesCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to deleteMcdFilesCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of deleteMcdFilesCheckbox


