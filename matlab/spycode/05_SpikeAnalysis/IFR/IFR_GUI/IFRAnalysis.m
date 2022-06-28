function varargout = IFRAnalysis(varargin)
% IFRANALYSIS M-file for IFRAnalysis.fig
%      IFRANALYSIS, by itself, creates a new IFRANALYSIS or raises the existing
%      singleton*.
%
%      H = IFRANALYSIS returns the handle to a new IFRANALYSIS or the handle to
%      the existing singleton*.
%
%      IFRANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IFRANALYSIS.M with the given input arguments.
%
%      IFRANALYSIS('Property','Value',...) creates a new IFRANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IFRAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IFRAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IFRAnalysis

% Last Modified by GUIDE v2.5 09-Jun-2008 12:41:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IFRAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @IFRAnalysis_OutputFcn, ...
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


% --- Executes just before IFRAnalysis is made visible.
function IFRAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IFRAnalysis (see VARARGIN)

% Choose default command line output for IFRAnalysis
handles.output = hObject;
handles.answer = '';
handles.commonParameters = [];
handles.computParameters = [];
handles.saveParameters = [];
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes IFRAnalysis wait for user response (see UIRESUME)
uiwait(hObject);


% --- Outputs from this function are returned to the command line.
function varargout = IFRAnalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.answer;
varargout{3} = handles.commonParameters;
varargout{4} = handles.computParameters;
varargout{5} = handles.saveParameters;


% --- Executes on button press in pushbutton_run.
function pushbutton_run_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% sampling frequency
sf = str2double(get(handles.edit_samplFreq,'String'));
% spiking threshold (for considering active electrodes)
spkTh = str2double(get(handles.edit_spikeTh,'String'));
% autoAdjFlag = 1 --> kernel parameters are automatically adjusted
% according to single channel's MFR
% autoAdjFlag = 0 --> kernel parameters are chosen by the user
autoAdjFlag = get(handles.checkbox_auto,'Value');
% selected kernel
selectedItem = get(handles.popupmenu_kernel,'Value');
stringList = get(handles.popupmenu_kernel,'String');
selectedString = stringList{selectedItem};
if(~autoAdjFlag)
    % window length is not auto-adjusted according to the mfr but it is
    % chosen by the user
    width = str2double(get(handles.edit_kernelWidth,'String'));     % [ms]
    multFactor = [];
%     switch selectedString
%         case 'rectangular'
%             % width in ms
%             [width, cancelFlag] = uigetRectKernelParam();
%         case 'gaussian'
%             % sd in ms
%             [width, cancelFlag] = uigetGausKernelParam();
%     end
%     if(cancelFlag)
%         warndlg('Aborted by user','!!Warning!!')
%         return
%     end
%     multFactor = [];
else
    width = [];
    multFactor = eval(get(handles.edit_mfrDividFactor,'String'));
%     [multFactor, cancelFlag] = uigetMFRcoeff();
%     if(cancelFlag)
%         warndlg('Aborted by user','!!Warning!!')
%         return
%     end
%     width = [];
end
undersamplFactor = str2double(get(handles.edit_undersampling,'String'));
saveIFRSingleCh = get(handles.checkbox_single,'Value');
saveIFRArrayWide = get(handles.checkbox_all,'Value');
saveIFRFig = get(handles.checkbox_fig,'Value');
% building parameters structure
handles.commonParameters = struct('sf',sf);
handles.computParameters = struct('spikingThreshold',spkTh,...
                    'autoAdjFlag',autoAdjFlag,...
                    'selectedKernel_string',selectedString,...
                    'kernelWidth',width,...
                    'mfrMultFactor',multFactor,...
                    'undersamplingFactor',undersamplFactor);
handles.saveParameters = struct('saveIFRSingleCh',saveIFRSingleCh,...
                    'saveIFRArrayWide',saveIFRArrayWide,...
                    'saveIFRFig',saveIFRFig);
handles.answer = 'ok';
% Update handles structure
guidata(hObject, handles);
uiresume;
% success = IFR_main(parameters);
% if(~success)
%     warndlg('IFR: Execution failed','!!Warning!!')
%     return
% end

function edit_samplFreq_Callback(hObject, eventdata, handles)
% hObject    handle to edit_samplFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_samplFreq as text
%        str2double(get(hObject,'String')) returns contents of edit_samplFreq as a double


% --- Executes during object creation, after setting all properties.
function edit_samplFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_samplFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_kernel.
function popupmenu_kernel_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_kernel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_kernel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_kernel


% --- Executes during object creation, after setting all properties.
function popupmenu_kernel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_kernel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_single.
function checkbox_single_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_single (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_single


% --- Executes on button press in checkbox_all.
function checkbox_all_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_all


% --- Executes on button press in checkbox_fig.
function checkbox_fig_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_fig
if get(hObject,'Value')
    set(handles.checkbox_single,'Value',1)
    set(handles.checkbox_all,'Value',1)
    set(handles.checkbox_single,'Enable','Off')
    set(handles.checkbox_all,'Enable','Off')
else
    set(handles.checkbox_single,'Enable','On')
    set(handles.checkbox_all,'Enable','On')
end


% --- Executes on button press in checkbox_auto.
function checkbox_auto_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_auto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_auto
if get(hObject,'Value')
    set(handles.text_kernelWidth,'Enable','Off')
    set(handles.text_mfrDividFactor,'Enable','On')
    set(handles.edit_kernelWidth,'Enable','Off')
    set(handles.edit_mfrDividFactor,'Enable','On')
else
    set(handles.edit_kernelWidth,'Enable','On')
    set(handles.edit_mfrDividFactor,'Enable','Off')
    set(handles.text_kernelWidth,'Enable','On')
    set(handles.text_mfrDividFactor,'Enable','Off')
end 



function edit_spikeTh_Callback(hObject, eventdata, handles)
% hObject    handle to edit_spikeTh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_spikeTh as text
%        str2double(get(hObject,'String')) returns contents of edit_spikeTh as a double


% --- Executes during object creation, after setting all properties.
function edit_spikeTh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_spikeTh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_undersampling_Callback(hObject, eventdata, handles)
% hObject    handle to edit_undersampling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_undersampling as text
%        str2double(get(hObject,'String')) returns contents of edit_undersampling as a double


% --- Executes during object creation, after setting all properties.
function edit_undersampling_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_undersampling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_kernelWidth_Callback(hObject, eventdata, handles)
% hObject    handle to edit_kernelWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_kernelWidth as text
%        str2double(get(hObject,'String')) returns contents of edit_kernelWidth as a double


% --- Executes during object creation, after setting all properties.
function edit_kernelWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_kernelWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_mfrDividFactor_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mfrDividFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mfrDividFactor as text
%        str2double(get(hObject,'String')) returns contents of edit_mfrDividFactor as a double


% --- Executes during object creation, after setting all properties.
function edit_mfrDividFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mfrDividFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure_IFRAnalysis.
function figure_IFRAnalysis_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure_IFRAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if ~strcmpi(get(hObject,'waitstatus'),'waiting')
    delete(hObject);
    return;
end


% --- Executes on button press in pushbutton_cancel.
function pushbutton_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.answer = 'cancel';
% Update handles structure
guidata(hObject, handles);
uiresume;


