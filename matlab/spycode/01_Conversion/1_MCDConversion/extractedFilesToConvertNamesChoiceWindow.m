function varargout = extractedFilesToConvertNamesChoiceWindow(varargin)
% extractedFilesToConvertNamesChoiceWindow MULTIPLEMEATEXT-file for extractedFilesToConvertNamesChoiceWindow.fig
%      EXTRACTEDFILESTOCONVERTNAMESCHOICEWINDOW, by itself, creates a new EXTRACTEDFILESTOCONVERTNAMESCHOICEWINDOW or raises the existing
%      singleton*.
%
%      H = EXTRACTEDFILESTOCONVERTNAMESCHOICEWINDOW returns the handle to a new EXTRACTEDFILESTOCONVERTNAMESCHOICEWINDOW or the handle to
%      the existing singleton*. 
%
%      EXTRACTEDFILESTOCONVERTNAMESCHOICEWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXTRACTEDFILESTOCONVERTNAMESCHOICEWINDOW.MULTIPLEMEATEXT with the given input arguments.
%
%      EXTRACTEDFILESTOCONVERTNAMESCHOICEWINDOW('Property','Value',...) creates a new EXTRACTEDFILESTOCONVERTNAMESCHOICEWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before extractedFilesToConvertNamesChoiceWindow_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to extractedFilesToConvertNamesChoiceWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help extractedFilesToConvertNamesChoiceWindow

% Begin initialization code - DO NOT EDIT

% Created by Luca Leonardo Bologna 02 February 2007
% 
%   - modified by Luca Leonardo Bologna 14 October 2007 in order to fix the bug
%     on the flag related to the setting of the offset to zero

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @extractedFilesToConvertNamesChoiceWindow_OpeningFcn, ...
    'gui_OutputFcn',  @extractedFilesToConvertNamesChoiceWindow_OutputFcn, ...
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

% --- Executes just before extractedFilesToConvertNamesChoiceWindow is made visible.
function extractedFilesToConvertNamesChoiceWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to extractedFilesToConvertNamesChoiceWindow (see VARARGIN)

% Choose default command line output for extractedFilesToConvertNamesChoiceWindow
handles.output = hObject;
%files between which the user will choose the file to convert
handles.filesToConvert = varargin(1);
%file types (either 64 or 128 channels) to be used during the conversion
%phase
handles.fileTypes = varargin(2);
%list of the Names used as experiment names for the conversion
handles.endNames = varargin(3);
%list of the folders set as default output
handles.outFolders = varargin(4);
%list of the folders containing the files stored in handles.filesToConvert
handles.startingFoldersList = varargin(5);
% handles variable containing the answer the user give when closing the
% window
handles.answer = '';
%number of meas the data recorded in the mcd files refers to
handles.nMeas = 0;
%flag for dat conversion
handles.dat = get(handles.datConversionCheckbox,'Value');
% flag for mat conversion
handles.mat = get(handles.matConversionCheckbox,'Value');
% flag for analog stream conversion
handles.ana = get(handles.anaConversionCheckbox,'Value');
% flag for setting the offset to zero
handles.setOffsetToZero = get(handles.setOffsetToZeroCheckbox,'Value');
% flag for filtering data
handles.filt = get(handles.filtConversionCheckbox,'Value');
% flag for converting electrode raw data
handles.rawDataConversion = get(handles.rawDataConversionCheckbox,'Value');
%cutoff frequencies and type of filter chosen for applying the filters
[handles.cutoffFrequency,handles.performfilter] = initializeVariables(handles.endNames);
% set window's objects
set(handles.namesListbox,'String',char(handles.filesToConvert{:}));
set(handles.namesListbox,'Max',length(varargin{1}));
set(handles.namesListbox,'Value',1);

set(handles.datConversionCheckbox,'Enable','off')
namesListbox_Callback(handles.namesListbox, eventdata, handles);
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes extractedFilesToConvertNamesChoiceWindow wait for user response (see UIRESUME)
uiwait(handles.extractedFilesToConvertNamesChoiceWindow);

% --- Outputs from this function are returned to the command line.
function varargout = extractedFilesToConvertNamesChoiceWindow_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
% variable
%output
varargout{1} = handles.output;
%answer chosen by the user (whether "OK" or "Cancel")
varargout{2} = handles.answer;
%list of files to be converted
varargout{3} = handles.filesToConvert;
%name of the experiments that will be used for the conversion
varargout{4} = handles.endNames;
%output folders used for the conversion
varargout{5} = handles.outFolders;
%type of the files to be converted (either 64 or 128 channels file)
varargout{6} = handles.fileTypes;
%number of meas each files stores the data of
varargout{7} = handles.nMeas;
%filters to be applied to the data (if the user chose any)
varargout{8} = handles.performfilter;
%cutoff frequencies in case a filter will be applied
varargout{9} = handles.cutoffFrequency;
%dat conversion flag (checked if dat conversion is required)
varargout{10} = handles.dat;
%mat conversion flag (checked if dat conversion is required)
varargout{11} = handles.mat;
%ana conversion flag (checked if dat conversion is required)
varargout{12} = handles.ana;
%flag for the setting of the offset to zero (checked if dat conversion is required)
varargout{13} = handles.setOffsetToZero;
%flag for filtered data conversion
varargout{14} = handles.filt;
%flag for converting raw data
varargout{15} = handles.rawDataConversion;
%delete the figure
delete (hObject);

%createFunction for the GUI
function extractedFilesToConvertNamesChoiceWindow_CreateFcn(hObject, eventdata, handles)

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
set(handles.multipleMeaText,'String','Multiple selection');
disablePanelChildren(handles.meaAPanel);
disablePanelChildren(handles.meaBPanel);

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
    handles.answer = 'OK';
    %indices of the files to be converted used for appropriately setting
    %the output parameters
    filesIdxs = get(handles.namesListbox,'Value');
    %get the names of the files to convert
    handles.filesToConvert = handles.filesToConvert{1}(filesIdxs);
    %get the number of the experiments referring to the files to convert
    handles.endNames = handles.endNames{1}(filesIdxs);
    %get the output folders of the files to convert
    handles.outFolders = handles.outFolders{1}(filesIdxs);
    %save the type of the files to be converted
    handles.fileTypes = handles.fileTypes{1}(filesIdxs);
    %extract the number of Meas each file stores tha data inside
    handles.nMeas = extractNMeas (handles.fileTypes);
    %filters to be applied to the data (if the user chose any)
    handles.performfilter = handles.performfilter{1}(filesIdxs);
    %cutoff frequencies in case a filter will be applied
    handles.cutoffFrequency = handles.cutoffFrequency{1}(filesIdxs);
    %save changes in the handles
    guidata(hObject, handles);
    %resume execution
    uiresume;
end

% --- Executes when user attempts to close extractedFilesToConvertNamesChoiceWindow.
function extractedFilesToConvertNamesChoiceWindow_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to extractedFilesToConvertNamesChoiceWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if ~strcmpi(get(hObject,'waitstatus'),'waiting')
    delete(hObject);
    return;
end
handles.answer = 'Cancel';
guidata(hObject, handles);
uiresume;

% --- Executes on selection change in namesListbox.
function namesListbox_Callback(hObject, eventdata, handles)
% hObject    handle to namesListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns namesListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from namesListbox

%in case only one file from MCS120 system has been selected
if ((length(get(hObject,'Value'))==1) && (size(handles.endNames{1}{get(hObject,'Value')},1)==2))
    set(handles.meaAPanel,'Title','Mea A');
    set(handles.meaBPanel,'Title','Mea B');
    set(handles.multipleMeaText,'String',['The file you have chosen has been recorded with the MCS 120 channels system. Thus, it stores data from two different experiments ("MeaA" and "MeaB").'...
        sprintf('\n') 'If needed, change the experiments name and the output folders in the panels below']);%
    %enable appropriate panels
    enablePanelChildren(handles.meaAPanel);
    enablePanelChildren(handles.meaBPanel);
    %change the popupmenu referring the filtering
    set(handles.meaAFilterPopupmenu,'Value',handles.performfilter{1}{get(hObject,'Value')}(1,:));
    meaAFilterPopupmenu_Callback(handles.meaAFilterPopupmenu, eventdata, handles);
    set(handles.meaBFilterPopupmenu,'Value',handles.performfilter{1}{get(hObject,'Value')}(2,:));
    meaBFilterPopupmenu_Callback(handles.meaBFilterPopupmenu, eventdata, handles);
    %change the edits referring the experiments names
    set(handles.meaAExpNameEdit,'String',deblank(char(handles.endNames{1}{get(hObject,'Value')}(1,:))));
    set(handles.meaBExpNameEdit,'String',char(handles.endNames{1}{get(hObject,'Value')}(2,:)));
    %change the edits referring to the experiments number (MeaA)
    expNum=find_expnum(deblank(char(handles.endNames{1}{get(hObject,'Value')}(1,:))),'_');
    set(handles.meaAGenPanelExpNumText,'String',expNum);
    %change the edits referring to the experiments number (MeaB)
    expNum=find_expnum(deblank(char(handles.endNames{1}{get(hObject,'Value')}(2,:))),'_');
    set(handles.meaBGenPanelExpNumText,'String',expNum);
    %change the edit referring the output folders
    set(handles.meaAOutFolderValueEdit,'String',char(handles.outFolders{1}{get(hObject,'Value')}(1,:)));
    set(handles.meaBOutFolderValueEdit,'String',char(handles.outFolders{1}{get(hObject,'Value')}(2,:)));
elseif (length(get(hObject,'Value'))==1)    %in case only one file from a 64 channels file has been selected
    set(handles.multipleMeaText,'String',['Recording done with a 64 channels mea'...
        sprintf('\n') 'If needed, change the experiment name and the output folder in the panel below']);
    set(handles.meaAPanel,'Title','64 channels Mea');
    set(handles.meaBPanel,'Title','');
    %disable appropriate channels
    disablePanelChildren(handles.meaBPanel);
    %enable the appropriate panel
    enablePanelChildren(handles.meaAPanel);
    %change the popupmenu referring the filtering
    set(handles.meaAFilterPopupmenu,'Value',handles.performfilter{1}{get(hObject,'Value')}(1,:));
    meaAFilterPopupmenu_Callback(handles.meaAFilterPopupmenu, eventdata, handles);
    %change the edits referring the experiments name
    set(handles.meaAExpNameEdit,'String',deblank(char(handles.endNames{1}{get(hObject,'Value')}(1,:))));
    %change the edit referring the output folder
    set(handles.meaAOutFolderValueEdit,'String',char(handles.outFolders{1}{get(hObject,'Value')}(1,:)));
    %change the edits referring to the experiments number (MeaA)
    expNum=find_expnum(deblank(char(handles.endNames{1}{get(hObject,'Value')}(1,:))),'_');
    set(handles.meaAGenPanelExpNumText,'String',expNum);
else %in case of multiple selection
    set(handles.meaAPanel,'Title','');
    set(handles.meaBPanel,'Title','');
    set(handles.multipleMeaText,'String','Multiple selection');
    disablePanelChildren(handles.meaAPanel);
    disablePanelChildren(handles.meaBPanel);
end

% --- Executes on button press in meaAOutFolderPushbutton.
function meaAOutFolderPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to meaAOutFolderPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ianswer = {uigetdir};
if strcmp(num2str(ianswer),'0')
    tempCell=cellstr(char(handles.outFolders{1}(get(handles.namesListbox,'Value'))));
    tempCell(1)=ianswer;
    handles.outFolders{1}(get(handles.namesListbox,'Value'))={char(tempCell)};
    set(handles.meaAOutFolderValueEdit,'String',char(handles.outFolders{1}{get(handles.namesListbox,'Value')}(1,:)));
    % Update handles structure
    guidata(hObject, handles);
end

% --- Executes on button press in meaBOutFolderPushbutton.
function meaBOutFolderPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to meaBOutFolderPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in meaaexpnamepushbutton.
ianswer={uigetdir};
if strcmp(num2str(ianswer),'0')
    tempCell=cellstr(char(handles.outFolders{1}(get(handles.namesListbox,'Value'))));
    tempCell(2)=ianswer;
    handles.outFolders{1}(get(handles.namesListbox,'Value'))={char(tempCell)};
    set(handles.meaBOutFolderValueEdit,'String',char(handles.outFolders{1}{get(handles.namesListbox,'Value')}(2,:)));
    % Update handles structure
    guidata(hObject, handles);
end

% --- Executes on button press in datConversionCheckbox.
function datConversionCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to datConversionCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of datConversionCheckbox

if (get(hObject,'Value'))== (get(hObject,'Max'))
    handles.dat=1;
elseif (get(hObject,'Value'))== (get(hObject,'Min')) && handles.mat==0
    warndlg('At least one type of conversion (".dat"/".mat") must be selected');
    set(hObject,'Value',get(hObject,'Max'));
    handles.dat=1;
else
    handles.dat=0;
end
guidata(hObject, handles);


% --- Executes on button press in matConversionCheckbox.
function matConversionCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to matConversionCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of matConversionCheckbox

if (get(hObject,'Value'))== (get(hObject,'Max'))
    handles.mat=1;
elseif (get(hObject,'Value'))== (get(hObject,'Min')) && handles.dat==0
    warndlg('At least one type of conversion (".dat"/".mat") must be selected');
    set(hObject,'Value',get(hObject,'Max'));
    handles.mat=1;
else
    handles.mat=0;
end
guidata(hObject, handles);

% --- Executes on button press in anaConversionCheckbox.
function anaConversionCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to anaConversionCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of anaConversionCheckbox
if (get(hObject,'Value'))== (get(hObject,'Max'))
    handles.ana=1;
else
    handles.ana=0;
end
guidata(hObject, handles);

% --- Executes on button press in setOffsetToZeroCheckbox.
function setOffsetToZeroCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to setOffsetToZeroCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of setOffsetToZeroCheckbox
if (get(hObject,'Value'))== (get(hObject,'Max'))
    handles.setOffsetToZero=1;
elseif (get(hObject,'Value'))== (get(hObject,'Min'))
    handles.setOffsetToZero=0;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function meaACutoffEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to meaACutoffEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function meaAFilterPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to meaAFilterPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function meaBCutoffEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to meaBCutoffEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function meaBFilterPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to meaBFilterPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function meaACutoffEdit_Callback(hObject, eventdata, handles)
% hObject    handle to meaACutoffEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of meaACutoffEdit as text
%        str2double(get(hObject,'String')) returns contents of meaACutoffEdit as a double

if isempty(regexpi(get(hObject,'String'),'^[0-9]+[.]{0,1}[0-9]+$','match'))
    warndlg('Only numeric values are allowed');
    set(handles.meaACutoffEdit,'String',handles.cutoffFrequency{1}{get(handles.namesListbox,'Value')}(1,:));
else
    ianswer=str2num(get(hObject,'String'));
    temp=handles.cutoffFrequency{1}{get(handles.namesListbox,'Value')};
    temp(1)=ianswer;
    handles.cutoffFrequency{1}(get(handles.namesListbox,'Value'))={temp};
    % Update handles structure
    guidata(hObject, handles);
end

%
function meaBCutoffEdit_Callback(hObject, eventdata, handles)
% hObject    handle to meaBCutoffEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of meaBCutoffEdit as text
%        str2double(get(hObject,'String')) returns contents of meaBCutoffEdit as a double
if isempty(regexpi(get(hObject,'String'),'^[0-9]+[.]{0,1}[0-9]+$','match'))
    warndlg('Only numeric values are allowed');
    set(handles.meaBCutoffEdit,'String',handles.cutoffFrequency{1}{get(handles.namesListbox,'Value')}(2,:));
else
    ianswer=str2num(get(hObject,'String'));
    temp=handles.cutoffFrequency{1}{get(handles.namesListbox,'Value')};
    temp(2)=ianswer;
    handles.cutoffFrequency{1}(get(handles.namesListbox,'Value'))={temp};
    % Update handles structure
    guidata(hObject, handles);
end

% --- Executes on selection change in meaAFilterPopupmenu.
function meaAFilterPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to meaAFilterPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns meaAFilterPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from meaAFilterPopupmenu
if get(hObject,'Value')==1 %case in which no filter has been chosen
    set(handles.meaACutoffEdit,'Enable', 'off');
    set(handles.meaACutoffText,'Enable', 'off');
    set(handles.meaACutoffEdit,'String', '');
else
    handles.performfilter{1}{get(handles.namesListbox,'Value')}(1,:)=int8(get(hObject,'Value'));
    set(handles.meaACutoffEdit,'Enable', 'on');
    set(handles.meaACutoffText,'Enable', 'on');
    set(handles.meaACutoffEdit,'String', num2str(handles.cutoffFrequency{1}{get(handles.namesListbox,'Value')}(1,:)));
    guidata(hObject, handles);
end

% --- Executes on selection change in meaBFilterPopupmenu.
function meaBFilterPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to meaBFilterPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns meaBFilterPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from meaBFilterPopupmenu
if get(hObject,'Value')==1 %case in which no filter has been chosen
    set(handles.meaBCutoffEdit,'Enable', 'off');
    set(handles.meaBCutoffText,'Enable', 'off');
    set(handles.meaBCutoffEdit,'String', '');
else
    handles.performfilter{1}{get(handles.namesListbox,'Value')}(2,:)=int8(get(hObject,'Value'));
    set(handles.meaBCutoffEdit,'Enable', 'on');
    set(handles.meaBCutoffText,'Enable', 'on');
    set(handles.meaBCutoffEdit,'String', num2str(handles.cutoffFrequency{1}{get(handles.namesListbox,'Value')}(2,:)));
    guidata(hObject, handles);
end


% =========================================================================
% =========================================================================
% =========================================================================
% ================= Useful functions start ================================
% =========================================================================
% =========================================================================
% =========================================================================
% extract the number of meas the recording stores the data of
function [nMeas] = extractNMeas (fileTypesChosen)

nMeas = cell2mat(fileTypesChosen)./64;

% =========================================================================
%set up the cell array that will be used to store the cutoff frequency used
%to filter the data
function [cutoffFrequencyCellArray,performfilter] = initializeVariables (endNamesCellArray)
fileNum = size(endNamesCellArray{1},2);
for i = 1:fileNum
    if size(endNamesCellArray{1}{i},1) == 2
        cutoffFrequencyCellArray(i) = {[100; 100]};
        performfilter(i) = {[1;1]};
    else
        cutoffFrequencyCellArray(i) = {100};
        performfilter(i) = {1};
    end
end
cutoffFrequencyCellArray = {cutoffFrequencyCellArray};
performfilter = {performfilter};

% =========================================================================
function disablePanelChildren(panelHandle)
childrenHandles=allchild(panelHandle);
%
childrenEnablingHandles = findobj(childrenHandles,'-property','Enable');
set(childrenEnablingHandles,'Enable', 'off');
%
childrenEditHandles = findobj(childrenHandles,'Style','edit');
set(childrenEditHandles,'String', '');
%
childrenPopupmenuHandles = findobj(childrenHandles,'Style','popupmenu');
set(childrenPopupmenuHandles,'Value', 1);
%
childrenCheckboxHandles = findobj(childrenHandles,'Style','checkbox');
set(childrenCheckboxHandles,'Value', 'default');
% =========================================================================

function enablePanelChildren(panelHandle)
childrenHandles=allchild(panelHandle);
%
childrenEnablingHandles = findobj(childrenHandles,'-property','Enable');
set(childrenEnablingHandles,'Enable', 'on');
%
childrenEditHandles = findobj(childrenHandles,'Style','edit');
set(childrenEditHandles,'String', '');
%
childrenPopupmenuHandles = findobj(childrenHandles,'Style','popupmenu');
set(childrenPopupmenuHandles,'Value',1);
%
childrenCheckboxHandles = findobj(childrenHandles,'Style','checkbox');
set(childrenCheckboxHandles,'Value', 'default');

% =========================================================================
% =========================================================================
% =========================================================================
% ===================== Useful functions end ==============================
% =========================================================================
% =========================================================================
% =========================================================================


function meaAExpNameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to meaAExpNameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of meaAExpNameEdit as text
%        str2double(get(hObject,'String')) returns contents of meaAExpNameEdit as a double
string=get(hObject,'String');
if ~isempty(string)
    tempCell=cellstr(char(handles.endNames{1}(get(handles.namesListbox,'Value'))));
    tempCell(1)={string};
    handles.endNames{1}(get(handles.namesListbox,'Value'))={char(tempCell)};
    set(handles.meaAExpNameEdit,'String',char(handles.endNames{1}{get(handles.namesListbox,'Value')}(1,:)));
    %change the edits referring to the experiments number (MeaA)
    expNum=find_expnum(deblank(char(handles.endNames{1}{get(handles.namesListbox,'Value')}(1,:))),'_');
    set(handles.meaAGenPanelExpNumText,'String',expNum);
    % Update handles structure
    guidata(hObject, handles);
else
    hWarn=warndlg('Insert a valid name, please');
    uiwait(hWarn);
    pause(0.1);
    set(handles.meaAExpNameEdit,'String',char(handles.endNames{1}{get(handles.namesListbox,'Value')}(1,:)));
end


function meaBExpNameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to meaBExpNameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of meaBExpNameEdit as text
%        str2double(get(hObject,'String')) returns contents of meaBExpNameEdit as a double
string=get(hObject,'String');
if ~isempty(string)
    tempCell=cellstr(char(handles.endNames{1}(get(handles.namesListbox,'Value'))));
    tempCell(2)={string};
    handles.endNames{1}(get(handles.namesListbox,'Value'))={char(tempCell)};
    set(handles.meaBExpNameEdit,'String',char(handles.endNames{1}{get(handles.namesListbox,'Value')}(2,:)));
    %change the edits referring to the experiments number (MeaB)
    expNum=find_expnum(deblank(char(handles.endNames{1}{get(handles.namesListbox,'Value')}(2,:))),'_');
    set(handles.meaBGenPanelExpNumText,'String',expNum);
    % Update handles structure
    guidata(hObject, handles);
else
    hWarn=warndlg('Insert a valid name, please');
    uiwait(hWarn);
    pause(0.1);
    set(handles.meaBExpNameEdit,'String',char(handles.endNames{1}{get(handles.namesListbox,'Value')}(2,:)));

end
%
function meaBOutFolderValueEdit_Callback(hObject, eventdata, handles)
% hObject    handle to meaBOutFolderValueEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of meaBOutFolderValueEdit as text
%        str2double(get(hObject,'String')) returns contents of meaBOutFolderValueEdit as a double

currentString=get(hObject,'String');
if ~isdir(currentString)
    hWarn=warndlg('The path you inserted is not valid. Please insert a valid path');
    uiwait(hWarn);
    pause(0.1);
    set(handles.meaBOutFolderValueEdit,'String',char(handles.outFolders{1}{get(handles.namesListbox,'Value')}(2,:)));
    pause(0.2);
    meaBOutFolderPushbutton_Callback(handles.meaBOutFolderPushbutton, eventdata, handles);
else
    tempCell=cellstr(char(handles.outFolders{1}(get(handles.namesListbox,'Value'))));
    tempCell(2)=currentString;
    handles.outFolders{1}(get(handles.namesListbox,'Value'))={char(tempCell)};
    set(handles.meaBOutFolderValueEdit,'String',char(handles.outFolders{1}{get(handles.namesListbox,'Value')}(2,:)));
    % Update handles structure
    guidata(hObject, handles);
end
%
function meaAOutFolderValueEdit_Callback(hObject, eventdata, handles)
% hObject    handle to meaAOutFolderValueEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of meaAOutFolderValueEdit as text
%        str2double(get(hObject,'String')) returns contents of meaAOutFolderValueEdit as a double

currentString=get(hObject,'String');
if ~isdir(currentString)
    hWarn=warndlg('The path you inserted is not valid. Please insert a valid path');
    uiwait(hWarn);
    pause(0.1);
    set(handles.meaAOutFolderValueEdit,'String',char(handles.outFolders{1}{get(handles.namesListbox,'Value')}(1,:)));
    pause(0.2);
    meaAOutFolderPushbutton_Callback(handles.meaAOutFolderPushbutton, eventdata, handles);
else
    tempCell=cellstr(char(handles.outFolders{1}(get(handles.namesListbox,'Value'))));
    tempCell(1)=currentString;
    handles.outFolders{1}(get(handles.namesListbox,'Value'))={char(tempCell)};
    set(handles.meaAOutFolderValueEdit,'String',char(handles.outFolders{1}{get(handles.namesListbox,'Value')}(1,:)));
    % Update handles structure
    guidata(hObject, handles);
end


% --- Executes on button press in meaAGeneralizedPushbutton.
function meaAGeneralizedPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to meaAGeneralizedPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set the output folder for the specified file to all the files contained
% in the same folder as the current file
sameFolderFilesIdx=strcmp(deblank(handles.startingFoldersList{1}),deblank(handles.startingFoldersList{1}(get(handles.namesListbox,'Value'))));
%
chosenOutFolder=cellstr(char(deblank(handles.outFolders{1}(get(handles.namesListbox,'Value')))));
chosenOutFolderFirst=chosenOutFolder(1);
%
chosenEndName=cellstr(char(deblank(handles.endNames{1}(get(handles.namesListbox,'Value')))));
chosenEndNameFirst=chosenEndName(1);
%
chosenPerformFilterFirst=handles.performfilter{1}{get(handles.namesListbox,'Value')}(1,:);
%
choseCutoffFrequency=handles.cutoffFrequency{1}{get(handles.namesListbox,'Value')}(1,:);
%
sameFolderFilesIdx=find(sameFolderFilesIdx);
lenSameFolderFilesIdx=length(sameFolderFilesIdx);
for i=1:lenSameFolderFilesIdx
    % set the appropriate output folder
    tempCell=cellstr(char(handles.outFolders{1}(sameFolderFilesIdx(i))));
    tempCell(1)=chosenOutFolderFirst;
    handles.outFolders{1}(sameFolderFilesIdx(i))={char(tempCell)};
    %set the appropriate filtering settings
    handles.performfilter{1}{sameFolderFilesIdx(i)}(1,:)=chosenPerformFilterFirst;
    handles.cutoffFrequency{1}{sameFolderFilesIdx(i)}(1,:)=choseCutoffFrequency;
    %set the appropriate end name
    chosenExpNum=find_expnum(deblank(char(chosenEndNameFirst)),'_');
    tempCell=cellstr(char(handles.endNames{1}(sameFolderFilesIdx(i))));
    currentExpNum=find_expnum(deblank(char(tempCell(1))),'_');
    tempString=regexprep(deblank(char(tempCell(1))),currentExpNum,chosenExpNum);
    tempCell(1)={tempString};
    handles.endNames{1}(sameFolderFilesIdx(i))={char(tempCell)};
end
guidata(hObject, handles);


% --- Executes on button press in meaBGeneralizedPushbutton.
function meaBGeneralizedPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to meaBGeneralizedPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sameFolderFilesIdx=strcmp(deblank(handles.startingFoldersList{1}),deblank(handles.startingFoldersList{1}(get(handles.namesListbox,'Value'))));
%
chosenOutFolder=cellstr(char(deblank(handles.outFolders{1}(get(handles.namesListbox,'Value')))));
chosenEndName=cellstr(char(deblank(handles.endNames{1}(get(handles.namesListbox,'Value')))));
chosenOutFolderFirst=chosenOutFolder(2);
chosenEndNameFirst=chosenEndName(2);
%
chosenPerformFilterFirst=handles.performfilter{1}{get(handles.namesListbox,'Value')}(2,:);
%
choseCutoffFrequency=handles.cutoffFrequency{1}{get(handles.namesListbox,'Value')}(2,:);
%
sameFolderFilesIdx = find(sameFolderFilesIdx);
lenSameFolderFilesIdx = length(sameFolderFilesIdx);
for i = 1 : lenSameFolderFilesIdx
    if size(char(handles.outFolders{1}(sameFolderFilesIdx(i))),1) == 2
        % set the appropriate output folder
        tempCell = cellstr(char(handles.outFolders{1}(sameFolderFilesIdx(i))));
        tempCell(2) = chosenOutFolderFirst;
        handles.outFolders{1}(sameFolderFilesIdx(i)) = {char(tempCell)};
        %
        %set the appropriate filtering settings
        handles.performfilter{1}{sameFolderFilesIdx(i)}(2,:) = chosenPerformFilterFirst;
        handles.cutoffFrequency{1}{sameFolderFilesIdx(i)}(2,:) = choseCutoffFrequency;

        %set the appropriate end name
        chosenExpNum = find_expnum(deblank(char(chosenEndNameFirst)),'_');
        tempCell = cellstr(char(handles.endNames{1}(sameFolderFilesIdx(i))));
        currentExpNum = find_expnum(deblank(char(tempCell(2))),'_');
        tempString = regexprep(deblank(char(tempCell(2))),currentExpNum,chosenExpNum);
        tempCell(2) = {tempString};
        handles.endNames{1}(sameFolderFilesIdx(i)) = {char(tempCell)};
    end
    guidata(hObject, handles);
end



% --- Executes on button press in filtConversionCheckbox.
function filtConversionCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to filtConversionCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filtConversionCheckbox
if (get(hObject,'Value')) == (get(hObject,'Max'))
    handles.filt = 1;
else
    handles.filt = 0;
end
guidata(hObject, handles);


% --- Executes on button press in rawDataConversionCheckbox.
function rawDataConversionCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to rawDataConversionCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rawDataConversionCheckbox
if (get(hObject,'Value')) == (get(hObject,'Max'))
    handles.rawDataConversion = 1;
    set(handles.matConversionCheckbox,'Enable','on')
    % set(handles.datConversionCheckbox,'Enable','on')
else
    handles.rawDataConversion = 0;
    set(handles.matConversionCheckbox,'Enable','off')
    set(handles.datConversionCheckbox,'Enable','off')
end
guidata(hObject, handles);
