function varargout = SpyCode(varargin)
% SPYCODE M-plot for SpyCode.fig
%      SPYCODE, by itself, creates a new SPYCODE or raises the existing
%      singleton*.
%
%      H = SPYCODE returns the handle to a new SPYCODE or the handle to
%      the existing singleton*.
%
%      SPYCODE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPYCODE.M with the given input arguments.
%
%      SPYCODE('Property','Value',...) creates a new SPYCODE or raises the
%      existing singleton*.  Starting from the left, property value pairs
%      are
%      applied to the GUI before SpikeManager_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SpyCode_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help SpyCode

% Last Modified by GUIDE v2.5 16-Dec-2014 16:39:37

% Begin initialization code - DO NOT EDIT
addpath(genpath('.'));
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SpyCode_OpeningFcn, ...
    'gui_OutputFcn',  @SpyCode_OutputFcn, ...
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


% --- Executes just before SpyCode is made visible.
function SpyCode_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SpyCode (see VARARGIN)

% Choose default command line output for SpyCode
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% draw SpyCode face figures
axes(handles.spycodeface) % Select the proper axes
imshow('SpyCode_logo.png');

% UIWAIT makes SpyCode wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SpyCode_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function plotrawdata8x8_Callback(hObject, eventdata, handles)
% hObject    handle to plotrawdata8x8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function plotrawdat_Callback(hObject, eventdata, handles)
% hObject    handle to plotrawdat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function FromPKD2TXT_Callback(hObject, eventdata, handles)
% hObject    handle to FromPKD2TXT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MeanFiringRate_Callback(hObject, eventdata, handles)
% hObject    handle to MeanFiringRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ISIsingle_Callback(hObject, eventdata, handles)
% hObject    handle to ISIsingle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function IBIsingle_Callback(hObject, eventdata, handles)
% hObject    handle to IBIsingle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PeakDetection_Callback(hObject, eventdata, handles)
% hObject    handle to PeakDetection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PlotmultiplePSTH_Callback(hObject, eventdata, handles)
% hObject    handle to PlotmultiplePSTH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ComputePSTH_Callback(hObject, eventdata, handles)
% hObject    handle to ComputePSTH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function BurstDetection_Callback(hObject, eventdata, handles)
% hObject    handle to BurstDetection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function FromPKD2TXT_MAT2PKD_Callback(hObject, eventdata, handles)
% hObject    handle to FromPKD2TXT_MAT2PKD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Computethreshold_Callback(hObject, eventdata, handles)
% hObject    handle to Computethreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function RasterplotTXT_Callback(hObject, eventdata, handles)
% hObject    handle to RasterplotTXT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function RasterplotMAT_Callback(hObject, eventdata, handles)
% hObject    handle to RasterplotMAT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function FromDATtoMAT_Callback(hObject, eventdata, handles)
% hObject    handle to FromDATtoMAT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PlotmultiplePSTH8x8_Callback(hObject, eventdata, handles)
% hObject    handle to PlotmultiplePSTH8x8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PSTHarea_Callback(hObject, eventdata, handles)
% hObject    handle to PSTHarea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PSTHlatency_Callback(hObject, eventdata, handles)
% hObject    handle to PSTHlatency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PlotsinglePSTH_Callback(hObject, eventdata, handles)
% hObject    handle to PlotsinglePSTH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function plotstimrastersinlge_Callback(hObject, eventdata, handles)
% hObject    handle to plotstimrastersinlge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function AboutSpikeManager_Callback(hObject, eventdata, handles)
% hObject    handle to AboutSpikeManager (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = strvcat(['SpyCode v3.8 - Release October, 2011 - ', ...
    'Developed by NBT-NeuroTech group @IIT', ...
    sprintf('\n') 'and NBT-DIBE group @University of Genova', ...
    sprintf('\n\n'), 'authors: M. Chiappalone, V. Pasquale, L.L. Bologna, ', ...
    'P.L. Baljon, M. Garofalo']);
helpdlg(str, 'About SpyCode')


% --------------------------------------------------------------------
function plot_Callback(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SpikeAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to SpikeAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function BurstAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to BurstAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PSTH_Callback(hObject, eventdata, handles)
% hObject    handle to PSTH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Crosscorrelogram_Callback(hObject, eventdata, handles)
% hObject    handle to Crosscorrelogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
% NOT USED FUNCTION - but necessary to avoid errors - MATLAB bug
function Untitled_14_Callback(hObject, eventdata, handles)
function Untitled_15_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------


% --------------------------------------------------------------------
function plotstimrasterall_Callback(hObject, eventdata, handles)
% hObject    handle to plotstimrasterall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function afr_Callback(hObject, eventdata, handles)
% hObject    handle to afr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ISImultiple_Callback(hObject, eventdata, handles)
% hObject    handle to ISImultiple (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function IBImultiple_Callback(hObject, eventdata, handles)
% hObject    handle to IBImultiple (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function statisticreport_Callback(hObject, eventdata, handles)
% hObject    handle to statisticreport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Plotrawdatapeaks_Callback(hObject, eventdata, handles)
% hObject    handle to Plotrawdatapeaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function clearall_Callback(hObject, eventdata, handles)
% hObject    handle to clearall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clr % clear from all variables the workspace and the command window


% --------------------------------------------------------------------
function conversion_Callback(hObject, eventdata, handles)
% hObject    handle to conversion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function FromTXT2PKD_Callback(hObject, eventdata, handles)
% hObject    handle to FromTXT2PKD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MCDconverter_Callback(hObject, eventdata, handles)
% hObject    handle to MCDconverter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function loadfile_Callback(hObject, eventdata, handles)
% hObject    handle to loadfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ConvertintoASCII_Callback(hObject, eventdata, handles)
% hObject    handle to ConvertintoASCII (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function statisticreportmean_Callback(hObject, eventdata, handles)
% hObject    handle to statisticreportmean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function plot3dcc_Callback(hObject, eventdata, handles)
% hObject    handle to plot3dcc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plotflag=1;
[window, binsize, fs, r_tabledir, destfolder, cancelFlag]=initcorr(plotflag);
if cancelFlag
    errordlg('Selection Failed - End of Session', 'Error');
else
    plot3Dcorrelogram (window, binsize, fs, r_tabledir, destfolder)
end


% --------------------------------------------------------------------
function plotmeancc_Callback(hObject, eventdata, handles)
% hObject    handle to plotmeancc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plotflag=2;
[window, binsize, fs, r_tabledir, destfolder,cancelFlag]=initcorr(plotflag);
if cancelFlag
    errordlg('Selection Failed - End of Session', 'Error');
else
    plotmeancorrelogram (window, binsize, fs, r_tabledir, destfolder)
end


% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function onspiketrain_Callback(hObject, eventdata, handles)
% hObject    handle to onspiketrain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function onburstevent_Callback(hObject, eventdata, handles)
% hObject    handle to onburstevent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function CrossCorrelation_Callback(hObject, eventdata, handles)
% hObject    handle to CrossCorrelation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function plotglobalibi_Callback(hObject, eventdata, handles)
% hObject    handle to plotglobalibi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PlotCorrelogram_Callback(hObject, eventdata, handles)
% hObject    handle to PlotCorrelogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function FromMATtoPKD_Callback(hObject, eventdata, handles)
% hObject    handle to FromMATtoPKD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function SpikeDetectionPTSD_Callback(hObject, eventdata, handles)
% hObject    handle to SpikeDetectionPTSD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

MAIN_mat2pkd_PTSD_autThComp



% --------------------------------------------------------------------
function MultipleMCD_Converter_Callback(hObject, eventdata, handles)
% hObject    handle to MultipleMCD_Converter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
chs = ones(1,64);
chs(1) = 0;
chs(8) = 0;
chs(57) = 0;
chs(64) = 0;

MAIN_MultipleConverter(chs,'mcd');



% --------------------------------------------------------------------
function multipleAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to multipleAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);




% --------------------------------------------------------------------
function performMultipleAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to performMultipleAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MAIN_MultipleAnalysis



% --------------------------------------------------------------------
function AdditionalTools_Callback(hObject, eventdata, handles)
% hObject    handle to AdditionalTools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function avaGUI_Callback(hObject, eventdata, handles)
% hObject    handle to avaGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
aVaGUI

% --------------------------------------------------------------------
function performMultAnAva_Callback(hObject, eventdata, handles)
% hObject    handle to performMultAnAva (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MAIN_multAnAva

% --------------------------------------------------------------------
function MultipleMedConversion_Callback(hObject, eventdata, handles)
% hObject    handle to MultipleMedConversion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MAIN_MultipleConverter('','med');



% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% --------------------------------------------------------------------
function burstDetectionNew_Callback(hObject, eventdata, handles)
% hObject    handle to burstDetectionNew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function netBurstDetect_Callback(hObject, eventdata, handles)
% hObject    handle to netBurstDetect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function RasterPlotPDF_Callback(hObject, eventdata, handles)
% hObject    handle to RasterPlotPDF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function RasterplotPDF_Callback(hObject, eventdata, handles)
% hObject    handle to RasterplotPDF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PL_PSTH_Callback(hObject, eventdata, handles)
% hObject    handle to PL_PSTH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)







% --------------------------------------------------------------------
function MBLanalysis_Callback(hObject, eventdata, handles)
% hObject    handle to MBLanalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MBL_main



% --------------------------------------------------------------------
function Untitled_8_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function filter_artSupp_salpa_Callback(hObject, eventdata, handles)
% hObject    handle to filter_artSupp_salpa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function artSupp_salpa_Callback(hObject, eventdata, handles)
% hObject    handle to artSupp_salpa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function joinRecPhases_Callback(hObject, eventdata, handles)
% hObject    handle to joinRecPhases (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function replaceArtefacts_Callback(hObject, eventdata, handles)
% hObject    handle to replaceArtefacts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function ArrayWideFiringRate_Callback(hObject, eventdata, handles)
% hObject    handle to ArrayWideFiringRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function divideRecPhases_Callback(hObject, eventdata, handles)
% hObject    handle to divideRecPhases (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function AverageFiringRate_Callback(hObject, eventdata, handles)
% hObject    handle to AverageFiringRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SpikeDetectionSDDT_Callback(hObject, eventdata, handles)
% hObject    handle to SpikeDetectionSDDT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_10_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_11_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_12_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function UserReference_Callback(hObject, eventdata, handles)
% hObject    handle to UserReference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

open('SpyCode User Reference.pdf');


% --------------------------------------------------------------------
function BI_Callback(hObject, eventdata, handles)
% hObject    handle to BI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
BurstIndx


% --------------------------------------------------------------------
function HyBrainWare_Coverter_Callback(hObject, eventdata, handles)
% hObject    handle to HyBrainWare_Coverter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
HyBrainWare_Converter
