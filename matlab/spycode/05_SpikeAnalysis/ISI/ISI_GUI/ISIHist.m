function varargout = ISIHist(varargin)
% ISIHIST M-file for ISIHist.fig
%      ISIHIST, by itself, creates a new ISIHIST or raises the existing
%      singleton*.
%
%      H = ISIHIST returns the handle to a new ISIHIST or the handle to
%      the existing singleton*.
%
%      ISIHIST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ISIHIST.M with the given input arguments.
%
%      ISIHIST('Property','Value',...) creates a new ISIHIST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ISIHist_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ISIHist_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ISIHist

% Last Modified by GUIDE v2.5 30-Oct-2015 10:13:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ISIHist_OpeningFcn, ...
                   'gui_OutputFcn',  @ISIHist_OutputFcn, ...
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


% --- Executes just before ISIHist is made visible.
function ISIHist_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ISIHist (see VARARGIN)

% Choose default command line output for ISIHist
set(handles.edit_SamplFreq, 'String', GlobalsParams.DEFAULT_FS_CHAR)
set(handles.edit_SamplFreq2, 'String', GlobalsParams.DEFAULT_FS_CHAR)
handles.output = hObject;
handles.answer = '';
handles.commonParameters = [];
handles.computParameters = [];
handles.saveParameters = [];
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes ISIHist wait for user response (see UIRESUME)
uiwait(hObject);


% --- Outputs from this function are returned to the command line.
function varargout = ISIHist_OutputFcn(hObject, eventdata, handles) 
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



function edit_MaxWin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_MaxWin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_MaxWin as text
%        str2double(get(hObject,'String')) returns contents of edit_MaxWin as a double


% --- Executes during object creation, after setting all properties.
function edit_MaxWin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MaxWin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_BinSize_Callback(hObject, eventdata, handles)
% hObject    handle to edit_BinSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_BinSize as text
%        str2double(get(hObject,'String')) returns contents of edit_BinSize as a double


% --- Executes during object creation, after setting all properties.
function edit_BinSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_BinSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_AutoScaling.
function checkbox_AutoScaling_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_AutoScaling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_AutoScaling
switch get(hObject,'Value')
    case 1
        set(handles.edit_MaxY, 'Enable', 'Off')
        set(handles.text_MaxY, 'Enable', 'Off')
    case 0
        set(handles.edit_MaxY, 'Enable', 'On')
        set(handles.text_MaxY, 'Enable', 'On')
end



function edit_MaxY_Callback(hObject, eventdata, handles)
% hObject    handle to edit_MaxY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_MaxY as text
%        str2double(get(hObject,'String')) returns contents of edit_MaxY as a double


% --- Executes during object creation, after setting all properties.
function edit_MaxY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MaxY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_SamplFreq_Callback(hObject, eventdata, handles)
% hObject    handle to edit_SamplFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_SamplFreq as text
%        str2double(get(hObject,'String')) returns contents of edit_SamplFreq as a double


% --- Executes during object creation, after setting all properties.
function edit_SamplFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_SamplFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_ISI8x8layout.
function checkbox_ISI8x8layout_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_ISI8x8layout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_ISI8x8layout


% --- Executes on button press in checkbox_netISI.
function checkbox_netISI_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_netISI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_netISI


% --- Executes on button press in checkbox_allISI.
function checkbox_allISI_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_allISI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_allISI


% --- Executes on button press in checkbox_ISIstat.
function checkbox_ISIstat_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_ISIstat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_ISIstat


% --- Executes on button press in checkbox_ISImaxBurst.
function checkbox_ISImaxBurst_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_ISImaxBurst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_ISImaxBurst
if get(hObject,'Value')
    set(handles.text_parameters,'Enable','On')
%     set(handles.edit_slopeTh,'Enable','On')
%     set(handles.edit_ampTh,'Enable','On')
    set(handles.edit_minPeakDist,'Enable','On')
%     set(handles.text_slopeTh,'Enable','On')
%     set(handles.text_ampTh,'Enable','On')
    set(handles.text_minPeakDist,'Enable','On')
%     set(handles.edit_diffTh,'Enable','On')
%     set(handles.text_diffTh,'Enable','On')
    set(handles.edit_ISITh,'Enable','On')
    set(handles.text_ISITh,'Enable','On')
%     set(handles.edit_mph,'Enable','On')
%     set(handles.text_mph,'Enable','On')
    set(handles.edit_voidParamTh,'Enable','On')
    set(handles.text_voidParamTh,'Enable','On')
    set(handles.checkbox_smoothing,'Value',1)
    set(handles.checkbox_smoothing,'Enable','Off')
    set(handles.popupmenu_smoothMethod,'Enable','On')
    set(handles.text_smoothMethod,'Enable','On')
    set(handles.text_smoothSpan,'Enable','On')
    set(handles.edit_smoothSpan,'Enable','On')
else
    set(handles.text_parameters,'Enable','Off')
%     set(handles.edit_slopeTh,'Enable','Off')
%     set(handles.edit_ampTh,'Enable','Off')
    set(handles.edit_minPeakDist,'Enable','Off')
%     set(handles.text_slopeTh,'Enable','Off')
%     set(handles.text_ampTh,'Enable','Off')
    set(handles.text_minPeakDist,'Enable','Off')
%     set(handles.edit_diffTh,'Enable','Off')
%     set(handles.text_diffTh,'Enable','Off')
    set(handles.edit_ISITh,'Enable','Off')
    set(handles.text_ISITh,'Enable','Off')
%     set(handles.edit_mph,'Enable','Off')
%     set(handles.text_mph,'Enable','Off')
    set(handles.edit_voidParamTh,'Enable','Off')
    set(handles.text_voidParamTh,'Enable','Off')
    set(handles.checkbox_smoothing,'Value',0)
    set(handles.checkbox_smoothing,'Enable','On')
    set(handles.popupmenu_smoothMethod,'Enable','Off')
    set(handles.text_smoothMethod,'Enable','Off')
    set(handles.text_smoothSpan,'Enable','Off')
    set(handles.edit_smoothSpan,'Enable','Off') 
end
    



function edit_SamplFreq2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_SamplFreq2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_SamplFreq2 as text
%        str2double(get(hObject,'String')) returns contents of edit_SamplFreq2 as a double


% --- Executes during object creation, after setting all properties.
function edit_SamplFreq2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_SamplFreq2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_nBinsxDec_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nBinsxDec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nBinsxDec as text
%        str2double(get(hObject,'String')) returns contents of edit_nBinsxDec as a double


% --- Executes during object creation, after setting all properties.
function edit_nBinsxDec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nBinsxDec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_AutoScaling2.
function checkbox_AutoScaling2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_AutoScaling2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_AutoScaling2
switch get(hObject,'Value')
    case 1
        set(handles.edit_MaxY2, 'Enable', 'Off')
        set(handles.text_MaxY2, 'Enable', 'Off')
    case 0
        set(handles.edit_MaxY2, 'Enable', 'On')
        set(handles.text_MaxY2, 'Enable', 'On')
end


function edit_MaxY2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_MaxY2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_MaxY2 as text
%        str2double(get(hObject,'String')) returns contents of edit_MaxY2 as a double


% --- Executes during object creation, after setting all properties.
function edit_MaxY2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MaxY2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in buttonGroup_LogVSLin.
function buttonGroup_LogVSLin_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in buttonGroup_LogVSLin 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hPanelLog = get(handles.uipanel_ISIHistLogParam,'Children');
hPanelLin = get(handles.uipanel_ISIHistLinParam,'Children');
switch get(hObject,'Tag')   % Get Tag of selected object
    case 'radiobutton_ISIHistLin'
        for i = 1:length(hPanelLog)
            set(hPanelLog(i),'Enable','Off')
        end
        for j = 1:length(hPanelLin)
            set(hPanelLin(j),'Enable','On')
        end
        set(handles.checkbox_AutoScaling, 'Value', 1)
        set(handles.edit_MaxY,'Enable','Off')
        set(handles.text_MaxY,'Enable','Off')
        set(handles.checkbox_ISImaxBurst,'Enable','Off')
        set(handles.text_parameters,'Enable','Off')
%         set(handles.edit_slopeTh,'Enable','Off')
%         set(handles.edit_ampTh,'Enable','Off')
        set(handles.edit_minPeakDist,'Enable','Off')
%         set(handles.text_slopeTh,'Enable','Off')
%         set(handles.text_ampTh,'Enable','Off')
        set(handles.text_minPeakDist,'Enable','Off')
        set(handles.popupmenu_smoothMethod,'Value',1)
        set(handles.edit_smoothSpan,'String','3')
%         set(handles.edit_diffTh,'Enable','Off')
%         set(handles.text_diffTh,'Enable','Off')
        set(handles.edit_ISITh,'Enable','Off')
        set(handles.text_ISITh,'Enable','Off')
%         set(handles.edit_mph,'Enable','Off')
%         set(handles.text_mph,'Enable','Off')
        set(handles.edit_voidParamTh,'Enable','Off')
        set(handles.text_voidParamTh,'Enable','Off')
        set(handles.checkbox_smoothing,'Enable','On')
    case 'radiobutton_ISIHistLog'
        for i = 1:length(hPanelLog)
            set(hPanelLog(i),'Enable','On')
        end
        for j = 1:length(hPanelLin)
            set(hPanelLin(j),'Enable','Off')
        end
        set(handles.checkbox_AutoScaling2, 'Value', 1)
        set(handles.edit_MaxY2,'Enable','Off')
        set(handles.text_MaxY2,'Enable','Off')
        set(handles.popupmenu_smoothMethod,'Value',2)
        set(handles.edit_smoothSpan,'String','5')
        set(handles.checkbox_ISImaxBurst,'Enable','On')
        if get(handles.checkbox_ISImaxBurst,'Value')
            set(handles.text_parameters,'Enable','On')
%             set(handles.edit_slopeTh,'Enable','On')
%             set(handles.edit_ampTh,'Enable','On')
            set(handles.edit_minPeakDist,'Enable','On')
%             set(handles.text_slopeTh,'Enable','On')
%             set(handles.text_ampTh,'Enable','On')
            set(handles.text_minPeakDist,'Enable','On')
            set(handles.checkbox_smoothing,'Value',1)
            set(handles.checkbox_smoothing,'Enable','Off')
%             set(handles.edit_diffTh,'Enable','On')
%             set(handles.text_diffTh,'Enable','On')
            set(handles.edit_ISITh,'Enable','On')
            set(handles.text_ISITh,'Enable','On')
%             set(handles.edit_mph,'Enable','On')
%             set(handles.text_mph,'Enable','On')
            set(handles.edit_voidParamTh,'Enable','On')
            set(handles.text_voidParamTh,'Enable','On')
        else
            set(handles.text_parameters,'Enable','Off')
%             set(handles.edit_slopeTh,'Enable','Off')
%             set(handles.edit_ampTh,'Enable','Off')
            set(handles.edit_minPeakDist,'Enable','Off')
%             set(handles.text_slopeTh,'Enable','Off')
%             set(handles.text_ampTh,'Enable','Off')
            set(handles.text_minPeakDist,'Enable','Off')
%             set(handles.edit_diffTh,'Enable','Off')
%             set(handles.text_diffTh,'Enable','Off')
            set(handles.edit_ISITh,'Enable','Off')
            set(handles.text_ISITh,'Enable','Off')
%             set(handles.edit_mph,'Enable','Off')
%             set(handles.text_mph,'Enable','Off')
            set(handles.edit_voidParamTh,'Enable','Off')
            set(handles.text_voidParamTh,'Enable','Off')
            set(handles.checkbox_smoothing,'Value',0)
            set(handles.checkbox_smoothing,'Enable','On')
        end
end


% --- Executes on button press in pushbutton_run.
function pushbutton_Run_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% % Select the source folder
% PDFolder = uigetdir(pwd,'Select the PeakDetectionMAT files folder');
% if strcmp(num2str(PDFolder),'0')
%     errordlg('Selection Failed - End of Session', 'Error');
%     return
% end

hSelObj = get(handles.buttonGroup_LogVSLin,'SelectedObject');
switch hSelObj
    case handles.radiobutton_ISIHistLin
%         % Create the result folder
%         [expFolderPath,PDFolderName] = fileparts(PDFolder);
%         ISIFolder = createResultFolder(expFolderPath, 'ISIHistogramLIN');
%         if(isempty(ISIFolder))
%             return
%         end
        % parameters for ISI computation
        paramISILinComp = struct('type','lin','maxWin_s',0,'binSize_ms',0,'autoSclFlag',0,'maxY',0);
        % parameters for ISI saving
        paramISILinSaving = struct('ISI8x8layoutFlag',0,'netISIFlag',0,'allISIFlag',0,'ISIstatFlag',0,'ISIsmoothingFlag',0);
        paramISILinComp.maxWin_s = str2double(get(handles.edit_MaxWin,'String'));
        paramISILinComp.binSize_ms = str2double(get(handles.edit_BinSize,'String'));
        paramISILinComp.autoSclFlag = get(handles.checkbox_AutoScaling,'Value');
        if paramISILinComp.autoSclFlag == 1
            paramISILinComp.maxY = [];
        else
            paramISILinComp.maxY = str2double(get(handles.edit_MaxY,'String'));
        end
        %%
        sf_Hz = str2double(get(handles.edit_SamplFreq,'String'));
        %%
        paramISILinSaving.ISI8x8layoutFlag = get(handles.checkbox_ISI8x8layout,'Value');
        paramISILinSaving.netISIFlag = get(handles.checkbox_netISI,'Value');
        paramISILinSaving.allISIFlag = get(handles.checkbox_allISI,'Value');
        paramISILinSaving.ISIstatFlag = get(handles.checkbox_ISIstat,'Value');
        paramISILinSaving.ISIsmoothingFlag = get(handles.checkbox_smoothing,'Value');
        if paramISILinSaving.ISIsmoothingFlag
            str = {'moving','lowess','loess','rlowess','rloess'};
            paramISILinSaving.ISIsmoothingMethod = str{get(handles.popupmenu_smoothMethod,'Value')};
            paramISILinSaving.ISIsmoothingSpan = str2double(get(handles.edit_smoothSpan,'String'));
        end
        handles.commonParameters = struct('sf',sf_Hz);
        handles.computParameters = paramISILinComp;
        handles.saveParameters = paramISILinSaving;
        clear sf_Hz paramISILinComp paramISILinSaving
        handles.answer = 'ok';
        guidata(hObject, handles);
        uiresume(handles.figure_ISIHist);
%         [success] = main_calcISILin(PDFolder, ISIFolder, paramISILinComp, paramISILinSaving);
%         if ~success
%             errordlg('calcMultISILin: Some errors have occurred! Execution terminated!', '!!Error!!', 'modal');
%             return
%         end
    case handles.radiobutton_ISIHistLog
%         % Create the result folder
%         [expFolderPath,PDFolderName] = fileparts(PDFolder);
%         ISIFolder = createResultFolder(expFolderPath, 'ISIHistogramLOG');
%         if(isempty(ISIFolder))
%             return
%         end
        % parameters for ISI computation
        paramISILogComp = struct('type','log','nBinsxDec',0,'autoSclFlag',0,'maxY',0);
        % parameters for ISI saving
        paramISILogSaving = struct('ISI8x8layoutFlag',0,'netISIFlag',0,'allISIFlag',0,'ISIstatFlag',0, ...
            'calcISImaxBurstFlag',0,'ISIsmoothingFlag',0);
        paramISILogComp.nBinsxDec = str2double(get(handles.edit_nBinsxDec,'String'));
        paramISILogComp.autoSclFlag = get(handles.checkbox_AutoScaling2,'Value');
        if paramISILogComp.autoSclFlag == 1
            paramISILogComp.maxY = [];
        else
            paramISILogComp.maxY = str2double(get(handles.edit_MaxY2,'String'));
        end
        %%
        sf_Hz = str2double(get(handles.edit_SamplFreq2,'String'));
        %%
        paramISILogSaving.ISI8x8layoutFlag = get(handles.checkbox_ISI8x8layout,'Value');
        paramISILogSaving.netISIFlag = get(handles.checkbox_netISI,'Value');
        paramISILogSaving.allISIFlag = get(handles.checkbox_allISI,'Value');
        paramISILogSaving.ISIstatFlag = get(handles.checkbox_ISIstat,'Value');
        paramISILogSaving.calcISImaxBurstFlag = get(handles.checkbox_ISImaxBurst,'Value');
        paramISILogSaving.ISIsmoothingFlag = get(handles.checkbox_smoothing,'Value');
        if paramISILogSaving.calcISImaxBurstFlag
            paramISILogSaving.ISIsmoothingFlag = 1;
%             paramISILogSaving.slopeTh = str2double(get(handles.edit_slopeTh,'String'));
%             paramISILogSaving.ampTh = str2double(get(handles.edit_ampTh,'String'));
            paramISILogSaving.minPeakDist = str2double(get(handles.edit_minPeakDist,'String'));
%             paramISILogSaving.minPeakHeight = str2double(get(handles.edit_mph,'String'));
            paramISILogSaving.voidParamTh = str2double(get(handles.edit_voidParamTh,'String'));
%             paramISILogSaving.diffTh = str2double(get(handles.edit_diffTh,'String'));
            paramISILogSaving.ISITh = str2double(get(handles.edit_ISITh,'String'));
        end
        if paramISILogSaving.ISIsmoothingFlag
            str = {'moving','lowess','loess','rlowess','rloess'};
            paramISILogSaving.ISIsmoothingMethod = str{get(handles.popupmenu_smoothMethod,'Value')};
            paramISILogSaving.ISIsmoothingSpan = str2double(get(handles.edit_smoothSpan,'String'));
        end
        handles.commonParameters = struct('sf',sf_Hz);
        handles.computParameters = paramISILogComp;
        handles.saveParameters = paramISILogSaving;
        clear paramISILogComp paramISILogSaving sf_Hz
        handles.answer = 'ok';
        guidata(hObject, handles);
        uiresume(handles.figure_ISIHist);
%         [success] = main_calcISILog(PDFolder, ISIFolder, paramISILogComp, paramISILogSaving);
%         if ~success
%             errordlg('calcMultISILog: Some errors have occurred! Execution terminated!', '!!Error!!', 'modal');
%             return
%         end
end


% --- Executes during object creation, after setting all properties.
function pushbutton_Run_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in pushbutton_cancel.
function pushbutton_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% closeGUI(handles.figure_ISIHist)
handles.answer = 'cancel';
% Update handles structure
guidata(hObject, handles);
uiresume(handles.figure_ISIHist);

% --- Executes on button press in checkbox_smoothing.
function checkbox_smoothing_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_smoothing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_smoothing
if(get(hObject,'Value'))
    set(handles.popupmenu_smoothMethod,'Enable','On')
    set(handles.text_smoothMethod,'Enable','On')
    set(handles.text_smoothSpan,'Enable','On')
    set(handles.edit_smoothSpan,'Enable','On')    
else
    set(handles.popupmenu_smoothMethod,'Enable','Off')
    set(handles.text_smoothMethod,'Enable','Off')
    set(handles.text_smoothSpan,'Enable','Off')
    set(handles.edit_smoothSpan,'Enable','Off')  
end

% function edit_ampTh_Callback(hObject, eventdata, handles)
% % hObject    handle to edit_ampTh (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'String') returns contents of edit_ampTh as text
% %        str2double(get(hObject,'String')) returns contents of edit_ampTh as a double
% 
% 
% % --- Executes during object creation, after setting all properties.
% function edit_ampTh_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to edit_ampTh (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end



function edit_minPeakDist_Callback(hObject, eventdata, handles)
% hObject    handle to edit_minPeakDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_minPeakDist as text
%        str2double(get(hObject,'String')) returns contents of edit_minPeakDist as a double


% --- Executes during object creation, after setting all properties.
function edit_minPeakDist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_minPeakDist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure_ISIHist.
function figure_ISIHist_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure_ISIHist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if ~strcmpi(get(hObject,'waitstatus'),'waiting')
    delete(hObject);
    return;
end


% --- Executes on selection change in popupmenu_smoothMethod.
function popupmenu_smoothMethod_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_smoothMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_smoothMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_smoothMethod


% --- Executes during object creation, after setting all properties.
function popupmenu_smoothMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_smoothMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_smoothSpan_Callback(hObject, eventdata, handles)
% hObject    handle to edit_smoothSpan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_smoothSpan as text
%        str2double(get(hObject,'String')) returns contents of edit_smoothSpan as a double


% --- Executes during object creation, after setting all properties.
function edit_smoothSpan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_smoothSpan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_diffTh_Callback(hObject, eventdata, handles)
% hObject    handle to edit_diffTh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_diffTh as text
%        str2double(get(hObject,'String')) returns contents of edit_diffTh as a double


% --- Executes during object creation, after setting all properties.
function edit_diffTh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_diffTh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ISITh_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ISITh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ISITh as text
%        str2double(get(hObject,'String')) returns contents of edit_ISITh as a double


% --- Executes during object creation, after setting all properties.
function edit_ISITh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ISITh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_mph_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mph as text
%        str2double(get(hObject,'String')) returns contents of edit_mph as a double


% --- Executes during object creation, after setting all properties.
function edit_mph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_voidParamTh_Callback(hObject, eventdata, handles)
% hObject    handle to edit_voidParamTh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_voidParamTh as text
%        str2double(get(hObject,'String')) returns contents of edit_voidParamTh as a double


% --- Executes during object creation, after setting all properties.
function edit_voidParamTh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_voidParamTh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
