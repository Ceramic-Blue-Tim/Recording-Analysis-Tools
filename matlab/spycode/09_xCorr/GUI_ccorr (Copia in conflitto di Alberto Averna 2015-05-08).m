function varargout = GUI_ccorr(varargin)
% GUI_CCORR M-file for GUI_ccorr.fig
%      GUI_CCORR, by itself, creates a new GUI_CCORR or raises the existing
%      singleton*.
%
%      H = GUI_CCORR returns the handle to a new GUI_CCORR or the handle to
%      the existing singleton*.
%
%      GUI_CCORR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CCORR.M with the given input arguments.
%
%      GUI_CCORR('Property','Value',...) creates a new GUI_CCORR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_ccorr_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_ccorr_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help GUI_ccorr
% Last Modified by GUIDE v2.5 16-Feb-2007 14:32:09

% by Michela Chiappalone (12 Febbraio 2007)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_ccorr_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_ccorr_OutputFcn, ...
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


% --- Executes just before GUI_ccorr is made visible.
function GUI_ccorr_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_ccorr (see VARARGIN)
% Choose default command line output for GUI_ccorr
handles.output = hObject;
% ------------> OWN VARIABLES' INITIALIZATION
handles.start_folder  = [];    % Input folder
handles.end_folder    = [];    % Output folder
handles.frequency     = GlobalsParams.DEFAULT_FS; % Sampling frequency [samples/sec]
handles.artwin        = 4;     % Artifact cancelaltion window [msec]
handles.inputdata     = 1;     % Spike Train =1 ; Burst Event =2
handles.cwindow       = 150;   % Correlation window [msec]
handles.binsize       = 5;     % Binsize [msec]
handles.halfarea      = 1;     % Half area around the correlation peak [# bins]
handles.peakID        = 1;     % Type of peak to be considered
handles.threshold     = 0.2;   % Threshold for functional connectivity
handles.arrayID       = 1;     % Type of array
handles.clusterID     = '  No cluster'; % Cluster identifier
handles.statusccorr    = 0;   % Check mark for cross-correlogram computation
handles.statusfunctcon = 0;   % Check mark on functional connectivity evaluation
handles.statusplot     = 0;   % Check mark on plot options
handles.normID         = 1;   % Define the normalization method

handles.answer= '';
handles.chosenParameters = {};

guidata(hObject, handles); % Update handles structure
uiwait(handles.Figure_GUI_ccorr); % UIWAIT makes GUI_ccorr wait for user response (see UIRESUME)


% --- Outputs from this function are returned to the command line.
function varargout = GUI_ccorr_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.answer;
varargout{3} = handles.chosenParameters;


% -------------------------------------------------------------------------------------- %
% --------------------------------  CALLBACK DEFINITION -------------------------------- %
% -------------------------------------------------------------------------------------- %

% ----------------------------> INPUT PARAMETERS PANEL
% --- Executes on button press in pushbutton_browseinput.
function pushbutton_browseinput_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_browseinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.statusccorr
    inputmessage='Select the SpikeTrain or BurstEvent folder';
else
    inputmessage= 'Select the CCorr or BurstEvent_CCorr folder';
end
start_folder = uigetdir(pwd,inputmessage);
if  strcmp(num2str(start_folder),'0')
    errordlg('Selection Failed - Folder does not exists', 'Error');
    return
elseif isempty(strfind(start_folder,'PeakDetection')) && ...
       isempty(strfind(start_folder, 'CCorr')) && isempty(strfind(start_folder, 'BurstEvent')) && isempty(strfind(start_folder, 'burstEvent'))
    errordlg('Selection Failed - The selected folder is not correct', 'Error');
    return
else
    set(handles.text_input, 'String', start_folder)
    handles.start_folder= start_folder;  
end
guidata(hObject, handles); % Update the handles structure


function edit_sfrequency_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sfrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.frequency= str2double(get(hObject,'String')); % Sampling frequency [samples/sec]
guidata(hObject, handles); % Update the handles structure

% --- Executes during object creation, after setting all properties.
function edit_sfrequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sfrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_delartwindow_Callback(hObject, eventdata, handles)
% hObject    handle to edit_delartwindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.artwin= str2double(get(hObject,'String')); % Artifact cancellation window [msec]
guidata(hObject, handles); % Update the handles structure

% --- Executes during object creation, after setting all properties.
function edit_delartwindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_delartwindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_inputdata.
function popupmenu_inputdata_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_inputdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(hObject,'String');          % Load the content of the popupmenu into a cell array
inputdata= contents{get(hObject,'Value')}; % Load the user's selection into a variable
if strcmp(inputdata, '  Spike Train')
    handles.inputdata=1; % Input is a spike train = 1
else
    handles.inputdata=2; % Input is a burst event train = 2
end
guidata(hObject, handles); % Update the handles structure

% --- Executes during object creation, after setting all properties.
function popupmenu_inputdata_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_inputdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in radiobutton_ccorr.
function radiobutton_ccorr_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_ccorr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
status = get(hObject, 'Value'); % returns toggle state of radiobutton_ccorr
if status
    set(handles.uipanel_CcorrPar, 'Visible', 'on');
    handles.statusccorr = 1;
    set(handles.pushbutton_browseinput, 'Enable', 'on');    % Enable the Input folder choice
else
   set(handles.uipanel_CcorrPar, 'Visible', 'off');
   handles.statusccorr  = 0;
   if handles.statusfunctcon == 0
       set(handles.pushbutton_browseinput, 'Enable', 'off'); % Disable the Input folder choice
       set(handles.text_input,  'String', 'Input Folder');
   end
end
guidata(hObject, handles); % Update the handles structure


% --- Executes on button press in radiobutton_functcon.
function radiobutton_functcon_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_functcon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
status = get(hObject, 'Value'); % returns toggle state of radiobutton_ccorr
if status
    set(handles.uipanel_FunctCon, 'Visible', 'on');
    handles.statusfunctcon = 1;
    set(handles.pushbutton_browseinput, 'Enable', 'on');    % Enable the Input folder choice
else
   set(handles.uipanel_FunctCon, 'Visible', 'off');
   handles.statusfunctcon = 0;
      if handles.statusccorr == 0
       set(handles.pushbutton_browseinput, 'Enable', 'off'); % Disable the Input folder choice
       set(handles.text_input,  'String', 'Input Folder');
   end
end
guidata(hObject, handles); % Update the handles structure


% --- Executes on button press in radiobutton_plot.
function radiobutton_plot_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
status = get(hObject, 'Value'); % returns toggle state of radiobutton_ccorr
if status
    set(handles.uipanel_PlotOptions, 'Visible', 'on');
    handles.statusplot = 1;
else
   set(handles.uipanel_PlotOptions, 'Visible', 'off');
   handles.statusplot = 0;
end
guidata(hObject, handles); % Update the handles structure



% ----------------------------> CROSS CORRELATION PANEL
function edit_ccorrwindow_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ccorrwindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.cwindow= str2double(get(hObject,'String')); % Correlation window [msec]
guidata(hObject, handles); % Update the handles structure

% --- Executes during object creation, after setting all properties.
function edit_ccorrwindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ccorrwindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_binsize_Callback(hObject, eventdata, handles)
% hObject    handle to edit_binsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.binsize= str2double(get(hObject,'String')); % Binsize [msec]
guidata(hObject, handles); % Update the handles structure

% --- Executes during object creation, after setting all properties.
function edit_binsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_binsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_norm.
function popupmenu_norm_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_norm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(hObject,'String');         % returns popupmenu_array contents as cell array
normID = contents{get(hObject,'Value')}; % returns selected item from popupmenu_array
switch normID
    case '  Normalize by sqrt(XY) - Symmmetric'
        handles.normID = 1;
    case '  Normalize by X - Asymmetric'
        handles.normID = 2;
    case '  Normalize by Y - Asymmetric'
        handles.normID = 3;  
end
guidata(hObject, handles); % Update the handles structure


% --- Executes during object creation, after setting all properties.
function popupmenu_norm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_norm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% ----------------------------> FUNCTIONAL CONNECTIVITY PANEL
% --- Executes on selection change in popupmenu_halfareapeak.
function popupmenu_halfareapeak_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_halfareapeak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(hObject,'String'); % returns popupmenu_halfareapeak contents as cell array
peakID = contents{get(hObject,'Value')}; % returns selected item from
if strcmp(peakID, '  Half area around the peak [# bin]')
    handles.peakID=1; % Around the peak
else
    handles.peakID=0; % Around zero
end
guidata(hObject, handles); % Update the handles structure


function edit_halfareapeak_Callback(hObject, eventdata, handles)
% hObject    handle to edit_halfareapeak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.halfarea= str2double(get(hObject,'String')); % Half-number of bins in the peak/zero zone
guidata(hObject, handles); % Update the handles structure

% --- Executes during object creation, after setting all properties.
function edit_halfareapeak_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_halfareapeak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_threshold_Callback(hObject, eventdata, handles)
% hObject    handle to edit_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.threshold= str2double(get(hObject,'String')); % Threshold for the functional connectivity map
guidata(hObject, handles); % Update the handles structure

% --- Executes during object creation, after setting all properties.
function edit_threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_array.
function popupmenu_array_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_array (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(hObject,'String');         % returns popupmenu_array contents as cell array
arrayID = contents{get(hObject,'Value')}; % returns selected item from popupmenu_array
switch arrayID
    case '  MCS MEA 60'
        handles.arrayID = 1;
        set(handles.popupmenu_cluster, 'Enable', 'off'); 
    case '  IMT Neurobit 60'
        handles.arrayID = 2;
        % set(handles.popupmenu_cluster, 'Enable', 'on'); % only when the
        % algorithm for the single cluster will be available - remember to add CLUSTER E
        set(handles.popupmenu_cluster, 'Enable', 'off'); 
    case '  IDEA HDPD 60'
        handles.arrayID = 3;
        set(handles.popupmenu_cluster, 'Enable', 'on');         
    case '  IDEA APS 4096'
        handles.arrayID = 4;
        set(handles.popupmenu_cluster, 'Enable', 'off'); 
end
guidata(hObject, handles); % Update the handles structure

% --- Executes during object creation, after setting all properties.
function popupmenu_array_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_array (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_cluster.
function popupmenu_cluster_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_cluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(hObject,'String');         % returns popupmenu_array contents as cell array
handles.clusterID= contents{get(hObject,'Value')}; % returns selected item from popupmenu_array
guidata(hObject, handles); % Update the handles structure

% --- Executes during object creation, after setting all properties.
function popupmenu_cluster_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_cluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushb_ok.
function pushb_ok_Callback(hObject, eventdata, handles)
% hObject    handle to pushb_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.answer ='OK';

if  isempty(handles.start_folder)
    errordlg('You must select the input folder', 'Error');
    return
end

if ((~handles.statusccorr)&&(~handles.statusfunctcon))
    errordlg('No operation selected - Session aborted', 'Error');
    return
end

if (handles.inputdata==1) % Spike Train
    if ~isempty(strfind(handles.start_folder, 'BurstEvent'))& handles.statusccorr
        errordlg('Please select a PeakDetection folder or switch to BurstEvent', 'Error');
        return
    end    
    if ~isempty(strfind(handles.start_folder, 'BurstEvent'))& handles.statusfunctcon
        errordlg('Please select a CCorr folder or switch to BurstEvent', 'Error');
        return
    end
else % Burst Event
    if ~isempty(strfind(handles.start_folder, 'PeakDetection'))& handles.statusccorr
        errordlg('Please select a BurstEvent folder or switch to SpikeTrain', 'Error');
        return
    end
    
    if isempty(strfind(handles.start_folder, 'BurstEvent_CCorr'))& handles.statusfunctcon
        errordlg('Please select a BurstEvent_CCorr folder or switch to SpikeTrain', 'Error');
        return
    end

end

% Fill in the ChosenParameters variable
chosenParametersTemp(1,1) = {handles.start_folder};  % Input folder
chosenParametersTemp(2,1) = {handles.end_folder};    % Output folder
chosenParametersTemp(3,1) = {handles.frequency};  % Sampling frequency [samples/sec]
chosenParametersTemp(4,1) = {handles.artwin };    % Artifact cancelaltion window [msec]
chosenParametersTemp(5,1) = {handles.inputdata }; % 1 = Spike Train; 2 = Burst Event
chosenParametersTemp(6,1) = {handles.cwindow};    % Correlation window [msec]
chosenParametersTemp(7,1) = {handles.binsize};    % Binsize [msec]
chosenParametersTemp(8,1) = {handles.halfarea};   % Half area around the peak [# bin]
chosenParametersTemp(9,1) = {handles.peakID};     % Around the peak or around zero
chosenParametersTemp(10,1)= {handles.threshold};  % Threshold for functional connectivity
chosenParametersTemp(11,1)= {handles.arrayID };   % Type of array
chosenParametersTemp(12,1)= {handles.clusterID};  % Cluster identifier
chosenParametersTemp(13,1)= {handles.statusccorr};    % Check on cross-correlation computation
chosenParametersTemp(14,1)= {handles.statusfunctcon}; % Check on functional connectivity computation
chosenParametersTemp(15,1)= {handles.statusplot};     % Check on plot options
chosenParametersTemp(16,1)= {handles.normID};     % Normalization procedure
handles.chosenParameters = chosenParametersTemp;
guidata(hObject, handles);
uiresume;


% --- Executes on button press in pushb_reset.
function pushb_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushb_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GUI_ccorr_reset

% --- Executes on button press in pushb_quit.
function pushb_quit_Callback(hObject, eventdata, handles)
% hObject    handle to pushb_quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.answer ='Cancel';
GUI_ccorr_reset % Before closing, reset everything in the panel
guidata(hObject, handles);
uiresume;

