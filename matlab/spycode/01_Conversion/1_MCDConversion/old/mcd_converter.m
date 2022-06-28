function varargout = mcd_converter(varargin)
% MCD_CONVERTER M-file for mcd_converter.fig
%      MCD_CONVERTER, by itself, creates a new MCD_CONVERTER or raises the existing
%      singleton*.
%
%      H = MCD_CONVERTER returns the handle to a new MCD_CONVERTER or the handle to
%      the existing singleton*.
%
%      MCD_CONVERTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MCD_CONVERTER.M with the given input arguments.
%
%      MCD_CONVERTER('Property','Value',...) creates a new MCD_CONVERTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mcd_converter_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mcd_converter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run_conv (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help mcd_converter

% Last Modified by GUIDE v2.5 29-Mar-2007 11:07:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @mcd_converter_OpeningFcn, ...
    'gui_OutputFcn',  @mcd_converter_OutputFcn, ...
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


% --- Executes just before mcd_converter is made visible.
function mcd_converter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mcd_converter (see VARARGIN)

%inizializing vector of indices of channels to convert, and other variables
ready=[0.895 0.149 0.341];
not_ready=[0.157 0.157 0.157];
handles.ch=zeros(1,64);
handles.mcdpath=0;
handles.mcdname=0;
handles.mat=0;
handles.dat=0;
handles.ana=0;
for i=2:63
    if i==8 || i==57
        continue
    end
    h=['handles.ch_' num2str(i)];
    set(eval(h),'Value',0);
end
set(handles.uipanel6,'HighlightColor',not_ready);

% Choose default command line output for mcd_converter
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mcd_converter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mcd_converter_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in dat.
function dat_Callback(hObject, eventdata, handles)
% hObject    handle to dat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dat
if (get(hObject,'Value'))== (get(hObject,'Max'))
    handles.dat=1;
    set(handles.uipanel5,'HighlightColor',[0.895 0.149 0.341]);
elseif (get(hObject,'Value'))== (get(hObject,'Min'))
    handles.dat=0;
    if handles.mat==0
        set(handles.uipanel5,'HighlightColor',[0.157 0.157 0.157]);
    end
end

guidata(hObject, handles);
% --- Executes on button press in mat.
function mat_Callback(hObject, eventdata, handles)
% hObject    handle to mat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mat
if (get(hObject,'Value'))== (get(hObject,'Max'))
    handles.mat=1;
    set(handles.uipanel5,'HighlightColor',[0.895 0.149 0.341]);
elseif (get(hObject,'Value'))== (get(hObject,'Min'))
    handles.mat=0;
    if handles.dat==0
        set(handles.uipanel5,'HighlightColor',[0.157 0.157 0.157]);
    end
end

guidata(hObject, handles);

% --- Executes on button press in analog_checkbox.
function analog_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to analog_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% [0.895 0.149 0.341]
% Hint: get(hObject,'Value') returns toggle state of analog_checkbox
if (get(hObject,'Value'))== (get(hObject,'Max'))
    handles.ana=1;
elseif (get(hObject,'Value'))== (get(hObject,'Min'))
    handles.ana=0;
end

guidata(hObject, handles);

% --- Executes on button press in sel_all.
function sel_all_Callback(hObject, eventdata, handles)
% hObject    handle to sel_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ch=ones(1,64);
set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
for i=2:63
    if i==8 || i==57
        continue
    end
    h=['handles.ch_' num2str(i)];
    set(eval(h),'Value',1);
end
guidata(hObject, handles);
% --- Executes on button press in des_all.
function des_all_Callback(hObject, eventdata, handles)
% hObject    handle to des_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ch=zeros(1,64);
set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
for i=2:63
    if i==8 || i==57
        continue
    end
    h=['handles.ch_' num2str(i)];
    set(eval(h),'Value',0);
end

guidata(hObject, handles);
% --- Executes on button press in browse_file.
function browse_file_Callback(hObject, eventdata, handles)
% hObject    handle to browse_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.mcdname handles.mcdpath]=uigetfile('*.mcd','Select the mcd file to convert');
if length(handles.mcdpath)>1
    set(handles.uipanel3,'HighlightColor',[0.895 0.149 0.341]);
else
    set(handles.uipanel3,'HighlightColor',[0.157 0.157 0.157]);
end
guidata(hObject,handles);
% --- Executes on button press in browse_folder.
function browse_folder_Callback(hObject, eventdata, handles)
% hObject    handle to browse_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.mcdname=0;
handles.mcdpath=uigetdir(pwd,'Select the folder which contain mcd files');
if isdir(handles.mcdpath)
    cd(handles.mcdpath);
    content=dir;
    if length(content)<=2
        msgbox('Directory doesn''t contain any mcd file','WARNING','error');
        handles.mcdpath=0;
    else
        for j=3:length(content)
            filename=content(j).name;
            if (length(filename)>3) && strcmp(filename(end-3:end),'.mcd')
                set(handles.uipanel3,'HighlightColor',[0.895 0.149 0.341]);
                break
            end
            if j==length(content)
                msgbox('directory doesn''t contain any mcd file','WARNING','error');
                handles.mcdpath=0;
            end
        end
    end
else
    set(handles.uipanel3,'HighlightColor',[0.157 0.157 0.157]);
end
guidata(hObject,handles);
% --- Executes on button press in run_conv.
function run_conv_Callback(hObject, eventdata, handles)
% hObject    handle to run_conv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%if ((handles.mat==0)&&(handles.dat==0)) || (isempty(find(handles.ch))) || (length(handles.mcdpath)<=1)
if (isequal(get(handles.uipanel3,'HighlightColor'),[0.157 0.157 0.157]))||(isequal(get(handles.uipanel4,'HighlightColor'),[0.157 0.157 0.157]))||...
        (isequal(get(handles.uipanel5,'HighlightColor'),[0.157 0.157 0.157]))||(isequal(get(handles.uipanel6,'HighlightColor'),[0.157 0.157 0.157]))
    msgbox('Either no file or no conversion or no electrode was selected','WARNING','error');
else
    handles.ch(1)=0;
    handles.ch(8)=0;
    handles.ch(57)=0;
    handles.ch(64)=0;
    % disp(handles.ch);
    end_folder = uigetdir(pwd,'Select the destination folder');
    if  strcmp(num2str(end_folder),'0')
        display ('End Of Function')
        return
    end
    if (~ischar(handles.mcdname))
        create_datmat(handles.ch,handles.dat,handles.mat,handles.ana,handles.format,handles.mcdpath,end_folder);
    else
        create_datmat(handles.ch,handles.dat,handles.mat,handles.ana,handles.format,handles.mcdpath,end_folder,handles.mcdname);
    end
end



%----------------------------------------------------------
% CALLBACKS FOR CHANNELS
%----------------------------------------------------------

% --- Executes on button press in ch_2.
function ch_2_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(2)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(2)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);


% --- Executes on button press in ch_3.
function ch_3_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(3)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(3)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_4.
function ch_4_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(4)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(4)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_5.
function ch_5_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(5)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(5)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_6.
function ch_6_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(6)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(6)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_7.
function ch_7_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(7)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(7)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_9.
function ch_9_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(9)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(9)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_10.
function ch_10_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(10)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(10)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_11.
function ch_11_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(11)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(11)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_12.
function ch_12_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(12)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(12)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_13.
function ch_13_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(13)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(13)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_14.
function ch_14_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(14)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(14)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_15.
function ch_15_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(15)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(15)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_16.
function ch_16_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(16)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(16)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_17.
function ch_17_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(17)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(17)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_18.
function ch_18_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(18)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(18)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_19.
function ch_19_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(19)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(19)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_20.
function ch_20_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(20)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(20)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_21.
function ch_21_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(21)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(21)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_22.
function ch_22_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(22)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(22)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_23.
function ch_23_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(23)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(23)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_24.
function ch_24_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(24)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(24)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_25.
function ch_25_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(25)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(25)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_26.
function ch_26_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(26)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(26)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_27.
function ch_27_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(27)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(27)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_28.
function ch_28_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(28)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(28)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_29.
function ch_29_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(29)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(29)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_30.
function ch_30_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(30)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(30)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_31.
function ch_31_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(31)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(31)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_32.
function ch_32_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(32)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(32)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_33.
function ch_33_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(33)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(33)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_34.
function ch_34_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(34)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(34)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_35.
function ch_35_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(35)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(35)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_36.
function ch_36_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(36)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(36)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_37.
function ch_37_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(37)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(37)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_38.
function ch_38_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(38)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(38)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_39.
function ch_39_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(39)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(39)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_40.
function ch_40_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(40)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(40)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);



% --- Executes on button press in ch_41.
function ch_41_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(41)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(41)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_42.
function ch_42_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(42)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(42)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_43.
function ch_43_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(43)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(43)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_44.
function ch_44_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(44)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(44)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_45.
function ch_45_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(45)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(45)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_46.
function ch_46_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(46)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(46)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_47.
function ch_47_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(47)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(47)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_48.
function ch_48_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(48)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(48)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_49.
function ch_49_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(49)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(49)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_50.
function ch_50_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(50)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(50)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_51.
function ch_51_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(51)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(51)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_52.
function ch_52_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(52)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(52)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_53.
function ch_53_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(53)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(53)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_54.
function ch_54_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(54)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(54)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_55.
function ch_55_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(55)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(55)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_56.
function ch_56_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(56)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(56)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_58.
function ch_58_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(58)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(58)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_59.
function ch_59_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(59)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(59)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_60.
function ch_60_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(60)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(60)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_61.
function ch_61_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(61)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(61)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_62.
function ch_62_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(62)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(62)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);

% --- Executes on button press in ch_63.
function ch_63_Callback(hObject, eventdata, handles)
if (get(hObject,'Value'))== get(hObject,'Max')
    handles.ch(63)=1;
elseif (get(hObject,'Value'))==get(hObject,'Min')
    handles.ch(63)=0;
end
if isempty(find(handles.ch))
    set(handles.uipanel6,'HighlightColor',[0.157 0.157 0.157]);
else
    set(handles.uipanel6,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject, handles);




% --- Executes on selection change in output.
function output_Callback(hObject, eventdata, handles)
% Hints: contents = get(hObject,'String') returns output contents as cell array
%        contents{get(hObject,'Value')} returns selected item from output
val=get(hObject,'Value');
switch val
    case 1
        handles.format=0;
        set(handles.uipanel4,'HighlightColor',[0.157 0.157 0.157]);
    case 2
        handles.format='uV';
        set(handles.uipanel4,'HighlightColor',[0.895 0.149 0.341]);
    case 3
        handles.format='qLevel';
        set(handles.uipanel4,'HighlightColor',[0.895 0.149 0.341]);
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function output_CreateFcn(hObject, eventdata, handles)
% hObject    handle to output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end