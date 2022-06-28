function varargout = multAnAvaWindow(varargin)
% multAnAvaWindow M-file for multAnAvaWindow.fig
%      multAnAvaWindow, by itself, creates a new multAnAvaWindow or raises the existing
%      singleton*.
%
%      H = multAnAvaWindow returns the handle to a new multAnAvaWindow or the handle to
%      the existing singleton*.
%
%      multAnAvaWindow('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in multAnAvaWindow.M with the given input arguments.
%
%      multAnAvaWindow('Property','Value',...) creates a new multAnAvaWindow or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before multAnAvaWindow_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to multAnAvaWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help multAnAvaWindow

% Last Modified by GUIDE v2.5 14-May-2007 10:38:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @multAnAvaWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @multAnAvaWindow_OutputFcn, ...
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


% --- Executes just before multAnAvaWindow is made visible.
function multAnAvaWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to multAnAvaWindow (see VARARGIN)

% Choose default command line output for multAnAvaWindow
handles.output = hObject;
handles.answer = '';
handles.multFactor = 1000;
handles.samplingFrequency = 0;
handles.chosenParameters = {};
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes multAnAvaWindow wait for user response (see UIRESUME)
uiwait(hObject);


% --- Outputs from this function are returned to the command line.
function varargout = multAnAvaWindow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.answer;
varargout{3} = handles.chosenParameters;

% --- Executes during object creation, after setting all properties.
function samplingFrequencyEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to samplingFrequencyEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function aVabinValuesEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aVabinValuesEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function aVaIEIWinEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aVaIEIWinEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function aVaIEIYlimEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aVaIEIYlimEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function aVaIEIBinEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aVaIEIBinEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in okButton.
function okButton_Callback(hObject, eventdata, handles)
% hObject    handle to okButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% saving sampling frequency
handles.samplingFrequency = str2double(get(handles.samplingFrequencyEdit,'String'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Common Parameters %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
commonParameters{1,1} = get(handles.samplingFrequencyEdit,'Tag');
commonParameters{1,2} = str2double(get(handles.samplingFrequencyEdit,'String'));
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% aVa Analysis Parameters %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
aVaParameters{1,1} = get(handles.performAvaDetectCheckbox,'Tag');
aVaParameters{1,2} = get(handles.performAvaDetectCheckbox,'Value');
aVaParameters{1,3} = get(handles.aVabinValuesEdit,'Tag');
aVaParameters{1,4} = eval(get(handles.aVabinValuesEdit,'String'));
aVaParameters{1,5} = get(handles.aVaperformExpBinning,'Tag');
aVaParameters{1,6} = get(handles.aVaperformExpBinning,'Value');
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% aVa IEI Analysis Parameters %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
aVaIEIParameters{1,1} = get(handles.performaVaIEIAnalCheckbox,'Tag');
aVaIEIParameters{1,2} = get(handles.performaVaIEIAnalCheckbox,'Value');
aVaIEIParameters{1,3} = get(handles.aVaIEIBinEdit,'Tag');
aVaIEIParameters{1,4} = str2double(get(handles.aVaIEIBinEdit,'String'))/handles.multFactor*handles.samplingFrequency;
aVaIEIParameters{1,5} = get(handles.aVaIEIWinEdit,'Tag');
aVaIEIParameters{1,6} = str2double(get(handles.aVaIEIWinEdit,'String'))/handles.multFactor*handles.samplingFrequency;
aVaIEIParameters{1,7} = get(handles.aVaIEIYlimEdit,'Tag');
aVaIEIParameters{1,8} = str2double(get(handles.aVaIEIYlimEdit,'String'));
%
%%% save data in handles variables
handles.chosenParameters{1} = commonParameters;
handles.chosenParameters{2} = aVaParameters;
handles.chosenParameters{3} = aVaIEIParameters;
handles.answer ='OK';
guidata(hObject, handles);
uiresume;

% --- Executes on button press in cancelButton.
function cancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.answer = 'Cancel';
guidata(hObject, handles);
uiresume;

% --- Executes on button press in performaVaIEIAnalCheckbox.
function performaVaIEIAnalCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to performaVaIEIAnalCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of performaVaIEIAnalCheckbox
if (get(hObject,'Value')==1)
    set(get(handles.aVaIEIParamValuePanel,'Children'),'Enable','on');
else
    set(get(handles.aVaIEIParamValuePanel,'Children'),'Enable','off');
end

% --- Executes when user attempts to close multAnAvaWindow.
function multAnAvaWindow_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to multAnAvaWindow (see GCBO)
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

% --- Executes on button press in aVaperformExpBinning.
function aVaperformExpBinning_Callback(hObject, eventdata, handles)
% hObject    handle to aVaperformExpBinning (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of aVaperformExpBinning




% --- Executes on button press in performAvaDetectCheckbox.
function performAvaDetectCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to performAvaDetectCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of performAvaDetectCheckbox
if (get(hObject,'Value')==1)
    set(get(handles.aVaParamValuePanel,'Children'),'Enable','on');
else
    set(get(handles.aVaParamValuePanel,'Children'),'Enable','off');
end


