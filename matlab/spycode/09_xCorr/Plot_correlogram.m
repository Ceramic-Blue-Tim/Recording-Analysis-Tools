function varargout = Plot_correlogram(varargin)
% PLOT_CORRELOGRAM M-file for Plot_correlogram.fig
%      PLOT_CORRELOGRAM, by itself, creates a new PLOT_CORRELOGRAM or raises the existing
%      singleton*.
%
%      H = PLOT_CORRELOGRAM returns the handle to a new PLOT_CORRELOGRAM or the handle to
%      the existing singleton*.
%
%      PLOT_CORRELOGRAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOT_CORRELOGRAM.M with the given input arguments.
%
%      PLOT_CORRELOGRAM('Property','Value',...) creates a new PLOT_CORRELOGRAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Plot_correlogram_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Plot_correlogram_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Plot_correlogram

% Last Modified by GUIDE v2.5 06-Jun-2006 12:27:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Plot_correlogram_OpeningFcn, ...
                   'gui_OutputFcn',  @Plot_correlogram_OutputFcn, ...
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


% --- Executes just before Plot_correlogram is made visible.
function Plot_correlogram_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% varargin   command line arguments to Plot_correlogram (see VARARGIN)

% Choose default command line output for Plot_correlogram
handles.output = hObject;

% Variables' initialization
handles.chx     = [];
handles.chy     = [];
handles.xyLim   = [0;0;0;0];
handles.dataplot= [];
% handles.meael   = [(12:17)'; (21:28)'; (31:38)'; (41:48)'; ...
%                    (51:58)'; (61:68)'; (71:78)';(82:87)'];
handles.meael   = [(11:18)'; (21:28)'; (31:38)'; (41:48)'; ...
                   (51:58)'; (61:68)'; (71:78)';(81:88)'];


% Objects' initialization
set(handles.PlotCorrelogram,'Enable','off')
axis([-150 150 0 2])

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Plot_correlogram wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Plot_correlogram_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SelectFolder.
function SelectFolder_Callback(hObject, eventdata, handles)
% hObject    handle to SelectFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.start_folder = uigetdir(pwd,'Select a Correlogram folder');
if  strcmp(num2str(handles.start_folder),'0')
    errordlg('Selection Failed', 'Error');
    return
end
set(handles.PlotCorrelogram,'Enable','on')
set(handles.xmin,'Enable','off')
set(handles.xmax,'Enable','off')
set(handles.ymin,'Enable','off')
set(handles.ymax,'Enable','off')
guidata(hObject, handles);



% --- Executes on selection change in Selectchx.
function Selectchx_Callback(hObject, eventdata, handles)
% hObject    handle to Selectchx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = get(hObject,'String') returns Selectchx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Selectchx
if get(hObject,'Value') == 1
% Add error check
else
    selx= get(hObject,'Value')- 1;
    handles.chx= handles.meael(selx);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Selectchx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Selectchx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in Selectchy.
function Selectchy_Callback(hObject, eventdata, handles)
% hObject    handle to Selectchy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = get(hObject,'String') returns Selectchy contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Selectchy
if get(hObject,'Value') == 1
% Add error check
else
    sely= get(hObject,'Value')- 1;
    handles.chy= handles.meael(sely);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Selectchy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Selectchy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in PlotCorrelogram.
function PlotCorrelogram_Callback(hObject, eventdata, handles)
% hObject    handle to PlotCorrelogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.chx)||isempty(handles.chy)
    errordlg('You must selct two channels','Bad Input','modal')
    return
end
cd(handles.start_folder) % Go to the directory selected by the user
content=dir;
filename=strcat(content(3).name(1:end-6), num2str(handles.chx), '.mat');
if fullfile(handles.start_folder, filename)
    load(fullfile(handles.start_folder, filename)) % Cell array r_table is loaded
    if length(r_table)==87 %added for compatibility with previous versions of SM
        r_table(end+1)=[];
    end
else
    % Error Check
end
rtoplot=r_table{handles.chy,1}; % Save the selected correlogram into the handles
[r,c]=size(rtoplot);

% Get bin size and window info
slashindex=strfind(handles.start_folder, filesep);
foldername=handles.start_folder(slashindex(end-1):slashindex(end));
window=str2double(foldername(strfind(foldername, '-')+1:strfind(foldername, 'msec')-1));
% underscoreindex=strfind(foldername, '_');
% bin=str2double(foldername(underscoreindex(end):strfind(foldername, '-')-1));
x=[-window:(2*window/(r-1)):window];

% Plot the correlogram
plot(handles.axes1, x, rtoplot);
axis([-window window 0 max(rtoplot)+max(rtoplot)/10])
titolo=strcat('Cross correlogram ', num2str(handles.chx), '-', num2str(handles.chy));
title (titolo)

% Enable Axis Property
set(handles.xmin,'Enable','on')
set(handles.xmax,'Enable','on')
set(handles.ymin,'Enable','on')
set(handles.ymax,'Enable','on')
guidata(hObject, handles);



function Hold_Callback(hObject, eventdata, handles)
% hObject    handle to Hold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hold on
% This button is no more available - It is necessary to add it in a second
% version of the software



% --- Executes on button press in zoomin.
function zoomin_Callback(hObject, eventdata, handles)
% hObject    handle to zoomin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom on



% --- Executes on button press in zoomout.
function zoomout_Callback(hObject, eventdata, handles)
% hObject    handle to zoomout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom off
zoom (0.25)



function ymin_Callback(hObject, eventdata, handles)
% hObject    handle to ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of ymin as text
%        str2double(get(hObject,'String')) returns contents of ymin as a double
ymin=str2double(get(hObject,'String'));
if isnan(ymin)
    errordlg('You must enter a numeric value','Bad Input','modal')
else
    handles.xyLim(1,1)=ymin;
    ylimits=ylim;
    ylim([ymin ylimits(2)])
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function ymin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ymax_Callback(hObject, eventdata, handles)
% hObject    handle to ymax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of ymax as text
%        str2double(get(hObject,'String')) returns contents of ymax as a double
ymax=str2double(get(hObject,'String'));
if isnan(ymax)
    errordlg('You must enter a numeric value','Bad Input','modal')
else
    handles.xyLim(2,1)=ymax;
    ylimits=ylim;
    ylim([ylimits(1) ymax])
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function ymax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xmin_Callback(hObject, eventdata, handles)
% hObject    handle to xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of xmin as text
%        str2double(get(hObject,'String')) returns contents of xmin as a double
xmin=str2double(get(hObject,'String'));
if isnan(xmin)
    errordlg('You must enter a numeric value','Bad Input','modal')
else
    handles.xyLim(3,1)=xmin;
    xlimits=xlim;
    xlim([xmin xlimits(2)])
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function xmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xmax_Callback(hObject, eventdata, handles)
% hObject    handle to xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of xmax as text
%        str2double(get(hObject,'String')) returns contents of xmax as a double
xmax=str2double(get(hObject,'String'));
if isnan(xmax)
    errordlg('You must enter a numeric value','Bad Input','modal')
else
    handles.xyLim(4,1)=xmax;
    xlimits=xlim;
    xlim([xlimits(1) xmax])
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function xmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in closepanel.
function closepanel_Callback(hObject, eventdata, handles)
% hObject    handle to closepanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close

% MENUBAR - to be added in a second time
% we must give the user the following possibilities:
% - hold on the previous graph
% - save the current graph
% - print the current graph
% --------------------------------------------------------------------
function savefigure_Callback(hObject, eventdata, handles)
% hObject    handle to savefigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function printfigure_Callback(hObject, eventdata, handles)
% hObject    handle to printfigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)