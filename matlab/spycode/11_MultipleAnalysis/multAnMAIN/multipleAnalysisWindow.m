function varargout = multipleAnalysisWindow(varargin)
% MULTIPLEANALYSISWINDOW M-file for multipleAnalysisWindow.fig
%      MULTIPLEANALYSISWINDOW, by itself, creates a new MULTIPLEANALYSISWINDOW or raises the existing
%      singleton*.
%
%      H = MULTIPLEANALYSISWINDOW returns the handle to a new MULTIPLEANALYSISWINDOW or the handle to
%      the existing singleton*.
%
%      MULTIPLEANALYSISWINDOW('CALLBACK',hObject,eventData,handles,...)
%      calls the local
%      function named CALLBACK in MULTIPLEANALYSISWINDOW.M with the given
%      input arguments.
%
%      MULTIPLEANALYSISWINDOW('Property','Value',...) creates a new MULTIPLEANALYSISWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before multipleAnalysisWindow_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to multipleAnalysisWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% peaklifetimeperiodedit the above text to modify the response to help multipleAnalysisWindow

% Last Modified by GUIDE v2.5 10-Nov-2017 17:16:10

% Begin initialization code - DO NOT PEAKLIFETIMEPERIODEDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @multipleAnalysisWindow_OpeningFcn, ...
    'gui_OutputFcn',  @multipleAnalysisWindow_OutputFcn, ...
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
% End initialization code - DO NOT PEAKLIFETIMEPERIODEDIT

% --- Executes just before multipleAnalysisWindow is made visible.
function multipleAnalysisWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to multipleAnalysisWindow (see VARARGIN)

% Choose default command line output for multipleAnalysisWindow
handles.output = hObject;
handles.answer='';
handles.multFactor=1000;
handles.samplingFrequency=0;
handles.chosenParameters={};
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes multipleAnalysisWindow wait for user response (see UIRESUME)
uiwait(handles.multipleAnalysisWindow);

% --- Outputs from this function are returned to the command line.
function varargout = multipleAnalysisWindow_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1}=handles.output;
varargout{2}=handles.answer;
varargout{3}=handles.chosenParameters;

function samplingFrequencyEdit_Callback(hObject, eventdata, handles)
% hObject    handle to samplingFrequencyEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of samplingFrequencyEdit as text
%        str2double(get(hObject,'String')) returns contents of samplingFrequencyEdit as a double


% --- Executes during object creation, after setting all properties.
function samplingFrequencyEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to samplingFrequencyEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: peakLifetimePeriodEdit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function compMfrBinSizeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to samplingFrequencyEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: peakLifetimePeriodEdit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function slidingWindowLengthEdit_Callback(hObject, eventdata, handles)
% hObject    handle to slidingWindowLengthEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of slidingWindowLengthEdit as text
%        str2double(get(hObject,'String')) returns contents of slidingWindowLengthEdit as a double

% --- Executes during object creation, after setting all properties.
function slidingWindowLengthEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slidingWindowLengthEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: peakLifetimePeriodEdit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: peakLifetimePeriodEdit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function minimumArtifactDistanceEdit_Callback(hObject, eventdata, handles)
% hObject    handle to minimumArtifactDistanceEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minimumArtifactDistanceEdit as text
%        str2double(get(hObject,'String')) returns contents of minimumArtifactDistanceEdit as a double


% --- Executes during object creation, after setting all properties.
function minimumArtifactDistanceEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minimumArtifactDistanceEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: peakLifetimePeriodEdit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function standardDeviationCoefficientEdit_Callback(hObject, eventdata, handles)
% hObject    handle to standardDeviationCoefficientEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of standardDeviationCoefficientEdit as text
%        str2double(get(hObject,'String')) returns contents of standardDeviationCoefficientEdit as a double

% --- Executes during object creation, after setting all properties.
function standardDeviationCoefficientEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to standardDeviationCoefficientEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: peakLifetimePeriodEdit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function artifactThreshold_anal_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to artifactThreshold_anal_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of artifactThreshold_anal_Edit as text
%        str2double(get(hObject,'String')) returns contents of artifactThreshold_anal_Edit as a double

% --- Executes during object creation, after setting all properties.
function artifactThreshold_anal_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to artifactThreshold_anal_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: peakLifetimePeriodEdit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function peakDetectionTitlePanel_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to peakDetectionTitlePanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% title panels
set(findobj('-regexp','Tag','.*TitlePanel'),'BorderType','line');
set(hObject,'BorderType','beveledout');
uistack(findobj('-regexp','Tag','.*(?<=Title)Panel'),'bottom');
uistack(findobj('Tag','peakDetectionTitlePanel'),'top');
% send back
uistack(findobj('-regexp','Tag','.*ValuesPanel'),'bottom');
% bring to front
uistack(findobj('Tag','peakDetectionValuesPanel'),'top');
% set visible property 'on' and 'off'
set(findobj('-regexp','Tag','.*ValuesPanel'),'Visible','off');
set(findobj('Tag','peakDetectionValuesPanel'),'Visible','on');

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to artifactThreshold_anal_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: peakLifetimePeriodEdit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function commonParametersTitlePanel_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to commonParametersTitlePanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% title panels
set(findobj('-regexp','Tag','.*TitlePanel'),'BorderType','line');
set(hObject,'BorderType','beveledout');
uistack(findobj('-regexp','Tag','.*(?<=Title)Panel'),'bottom');
uistack(findobj('Tag','commonParametersTitlePanel'),'top');
% panels
uistack(findobj('-regexp','Tag','.*ValuesPanel'),'bottom');
uistack(findobj('Tag','commonParametersPanel'),'top');
% set visible property 'on' and 'off'
set(findobj('-regexp','Tag','.*ValuesPanel'),'Visible','off');
set(findobj('Tag','commonParametersValuesPanel'),'Visible','on');

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over commonParametersTitleText.
function commonParametersTitleText_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to commonParametersTitleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
commonParametersTitlePanel_ButtonDownFcn(get(hObject,'Parent'), eventdata, handles);



% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over peakDetectionTitleText.
function peakDetectionTitleText_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to peakDetectionTitleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
peakDetectionTitlePanel_ButtonDownFcn(get(hObject,'Parent'), eventdata, handles);



% --- Executes on button press in okPushbutton.
function okPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to okPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles.

%sampling frequency
handles.samplingFrequency=str2num(get(handles.samplingFrequencyEdit,'String'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Common Parameters %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
commonParameters{1,1}=get(handles.samplingFrequencyEdit,'Tag');
commonParameters{1,2}=str2num(get(handles.samplingFrequencyEdit,'String'));
commonParameters{1,3}=get(handles.artifactThreshold_anal_Edit,'Tag');
commonParameters{1,4}=str2num(get(handles.artifactThreshold_anal_Edit,'String'));
commonParameters{1,5}=get(handles.blankWindForArtEdit,'Tag');
commonParameters{1,6}=str2num(get(handles.blankWindForArtEdit,'String'))*handles.samplingFrequency/handles.multFactor;
commonParameters{1,7}=get(handles.artifactThreshold_spkTrn_Edit,'Tag');
commonParameters{1,8}=str2num(get(handles.artifactThreshold_spkTrn_Edit,'String'));
commonParameters{1,9}=get(handles.minArtefactDistEdit,'Tag');
commonParameters{1,10}=str2num(get(handles.minArtefactDistEdit,'String'));
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Peak Detection Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
peakDetectionParameters{1,1}=get(handles.performPeakDetectionCheckbox,'Tag');
peakDetectionParameters{1,2}=get(handles.performPeakDetectionCheckbox,'Value');
%
peakDetectionParameters{2,1}=get(handles.pddtRadiobutton,'Tag');
peakDetectionParameters{2,2}=get(handles.pddtRadiobutton,'Value');
peakDetectionParameters{2,3}=get(handles.slidingWindowLengthEdit,'Tag');
peakDetectionParameters{2,4}=str2num(get(handles.slidingWindowLengthEdit,'String'))*handles.samplingFrequency/handles.multFactor;
% peakDetectionParameters{2,5}=get(handles.minimumArtifactDistanceEdit,'Tag');
% peakDetectionParameters{2,6}=str2num(get(handles.minimumArtifactDistanceEdit,'String'))*handles.samplingFrequency;
peakDetectionParameters{2,7}=get(handles.standardDeviationCoefficientEdit,'Tag');
peakDetectionParameters{2,8}=str2num(get(handles.standardDeviationCoefficientEdit,'String'));
%

peakDetectionParameters{3,1}=get(handles.rtsdRadiobutton,'Tag');
peakDetectionParameters{3,2}=get(handles.rtsdRadiobutton,'Value');
peakDetectionParameters{3,3}=get(handles.peakLifetimePeriodEdit,'Tag');
peakDetectionParameters{3,4}=str2num(get(handles.peakLifetimePeriodEdit,'String'))*handles.samplingFrequency/handles.multFactor;
peakDetectionParameters{3,5}=get(handles.refractoryPeriodEdit,'Tag');
peakDetectionParameters{3,6}=str2num(get(handles.refractoryPeriodEdit,'String'))*handles.samplingFrequency/handles.multFactor;
% peakDetectionParameters{3,7}=get(handles.rtsdMinArtEdit,'Tag');
% peakDetectionParameters{3,8}=str2num(get(handles.rtsdMinArtEdit,'String'))*handles.samplingFrequency;
% peakDetectionParameters{3,8}=str2num(get(handles.rtsdMinArtEdit,'String'));
peakDetectionParameters{3,9}=get(handles.standardDeviationCoefficientRTSDEdit,'Tag');
peakDetectionParameters{3,10}=str2num(get(handles.standardDeviationCoefficientRTSDEdit,'String'));

%%%%%%%%%%%%%%%%%%%
%%% Plot Parameters
%%%%%%%%%%%%%%%%%%%
plotParameters{1,1}=get(handles.rasterPlotCheckbox,'Tag');
plotParameters{1,2}=get(handles.rasterPlotCheckbox,'Value');
plotParameters{1,3}=get(handles.rasterPlotStartTimeEdit,'Tag');
plotParameters{1,4}=str2num(get(handles.rasterPlotStartTimeEdit,'String'))*handles.samplingFrequency;
plotParameters{1,5}=get(handles.rasterPlotEndTimeEdit,'Tag');
plotParameters{1,6}=str2num(get(handles.rasterPlotEndTimeEdit,'String'))*handles.samplingFrequency;

%%%%%%%%%%%%%%%%%%%
%%% PSTH Parameters
%%%%%%%%%%%%%%%%%%%
psthParameters{1,1}=get(handles.performPsthCheckbox,'Tag');
psthParameters{1,2}=get(handles.performPsthCheckbox,'Value');
%
psthParameters{2,1}=get(handles.performPsthCompPsthLatencyCheckbox,'Tag');
psthParameters{2,2}=get(handles.performPsthCompPsthLatencyCheckbox,'Value');
psthParameters{2,3}=get(handles.psthBinSizeEdit,'Tag');
psthParameters{2,4}=str2num(get(handles.psthBinSizeEdit,'String'))*handles.samplingFrequency/handles.multFactor;
psthParameters{2,5}=get(handles.psthTimeFrameEdit,'Tag');
psthParameters{2,6}=str2num(get(handles.psthTimeFrameEdit,'String'))*handles.samplingFrequency/handles.multFactor;
%
psthParameters{3,1}=get(handles.performPsthPlotMulPsthCheckbox,'Tag');
psthParameters{3,2}=get(handles.performPsthPlotMulPsthCheckbox,'Value');
psthParameters{3,3}=get(handles.plotMulPsthNumStimSesEdit,'Tag');
psthParameters{3,4}=str2num(get(handles.plotMulPsthNumStimSesEdit,'String'));
psthParameters{3,5}=get(handles.plotMulPsthXAxisLimitEdit,'Tag');
psthParameters{3,6}=str2num(get(handles.plotMulPsthXAxisLimitEdit,'String'));
%
psthParameters{4,1}=get(handles.performPsthPlotMulPsth8x8Checkbox,'Tag');
psthParameters{4,2}=get(handles.performPsthPlotMulPsth8x8Checkbox,'Value');
psthParameters{4,3}=get(handles.plotMulPsth8x8StimSesEdit,'Tag');
psthParameters{4,4}=get(handles.plotMulPsth8x8StimSesEdit,'String');
psthParameters{4,5}=get(handles.plotMulPsth8x8PsthTimeFrameEdit,'Tag');
psthParameters{4,6}=str2num(get(handles.plotMulPsth8x8PsthTimeFrameEdit,'String'));
psthParameters{4,7}=get(handles.plotMulPsth8x8PsthYAxisLimEdit,'Tag');
psthParameters{4,8}=str2num(get(handles.plotMulPsth8x8PsthYAxisLimEdit,'String'));
%
psthParameters{5,1}=get(handles.performPsthPlotStimRastAllPhCheckbox,'Tag');
psthParameters{5,2}=get(handles.performPsthPlotStimRastAllPhCheckbox,'Value');
%
psthParameters{6,1}=get(handles.performPsthCompAreaPsthCheckbox,'Tag');
psthParameters{6,2}=get(handles.performPsthCompAreaPsthCheckbox,'Value');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Spike Analysis Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

spikeAnalysisParameters{1,1}=get(handles.performSpikeAnalysisCheckbox,'Tag');
spikeAnalysisParameters{1,2}=get(handles.performSpikeAnalysisCheckbox,'Value');
%Mean firing rate
spikeAnalysisParameters{2,1}=get(handles.performSpikeAnalysisCompMeanFiringRateCheckbox,'Tag');
spikeAnalysisParameters{2,2}=get(handles.performSpikeAnalysisCompMeanFiringRateCheckbox,'Value');
spikeAnalysisParameters{2,3}=get(handles.compMfrFrthreshEdit,'Tag');
spikeAnalysisParameters{2,4}=str2num(get(handles.compMfrFrthreshEdit,'String'));
% Average firing rate
spikeAnalysisParameters{3,1}=get(handles.performSpikeAnalysisCompAvFirRateCheckbox,'Tag');
spikeAnalysisParameters{3,2}=get(handles.performSpikeAnalysisCompAvFirRateCheckbox,'Value');
spikeAnalysisParameters{3,3}=get(handles.compAfrBinSizeEdit,'Tag');
spikeAnalysisParameters{3,4}=str2num(get(handles.compAfrBinSizeEdit,'String'))*handles.samplingFrequency/handles.multFactor;
spikeAnalysisParameters{3,5}=get(handles.compAfrFrthreshEdit,'Tag');
spikeAnalysisParameters{3,6}=str2num(get(handles.compAfrFrthreshEdit,'String'));
% Multiple ISI Plot
spikeAnalysisParameters{4,1}=get(handles.performSpikeAnalysisPlotMulIsiCheckbox,'Tag');
spikeAnalysisParameters{4,2}=get(handles.performSpikeAnalysisPlotMulIsiCheckbox,'Value');
spikeAnalysisParameters{4,3}=get(handles.plotMulIsiIsiBinEdit,'Tag');
spikeAnalysisParameters{4,4}=str2num(get(handles.plotMulIsiIsiBinEdit,'String'))*handles.samplingFrequency/handles.multFactor;
spikeAnalysisParameters{4,5}=get(handles.plotMulIsiIsiWinEdit,'Tag');
spikeAnalysisParameters{4,6}=str2num(get(handles.plotMulIsiIsiWinEdit,'String'))/handles.multFactor;
spikeAnalysisParameters{4,7}=get(handles.plotMulIsiIsiYLimEdit,'Tag');
spikeAnalysisParameters{4,8}=str2num(get(handles.plotMulIsiIsiYLimEdit,'String'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Burst Analysis Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
burstAnalysisParameters{1,1}=get(handles.performBurstAnalysisCheckbox,'Tag');
burstAnalysisParameters{1,2}=get(handles.performBurstAnalysisCheckbox,'Value');
%
burstAnalysisParameters{2,1}=get(handles.performBurstAnalysisBurstDetectionCheckbox,'Tag');
burstAnalysisParameters{2,2}=get(handles.performBurstAnalysisBurstDetectionCheckbox,'Value');
burstAnalysisParameters{2,3}=get(handles.performBurstAnalysisMinNumIntraSpikesEdit,'Tag');
burstAnalysisParameters{2,4}=str2num(get(handles.performBurstAnalysisMinNumIntraSpikesEdit,'String'));
burstAnalysisParameters{2,5}=get(handles.performBurstAnalysisMaxIntraIsiEdit,'Tag');
burstAnalysisParameters{2,6}=str2num(get(handles.performBurstAnalysisMaxIntraIsiEdit,'String'))*handles.samplingFrequency/handles.multFactor;
burstAnalysisParameters{2,7}=get(handles.performBurstAnalysisBurstRateThreshEdit,'Tag');
burstAnalysisParameters{2,8}=str2num(get(handles.performBurstAnalysisBurstRateThreshEdit,'String'));
%
burstAnalysisParameters{3,1}=get(handles.performBurstAnalysisPlotMultipleIBI8x8Checkbox,'Tag');
burstAnalysisParameters{3,2}=get(handles.performBurstAnalysisPlotMultipleIBI8x8Checkbox,'Value');
burstAnalysisParameters{3,3}=get(handles.plotMultipleIbi8x8IbiBinEdit,'Tag');
burstAnalysisParameters{3,4}=str2num(get(handles.plotMultipleIbi8x8IbiBinEdit,'String'));
burstAnalysisParameters{3,5}=get(handles.plotMultipleIbi8x8IbiWindowEdit,'Tag');
burstAnalysisParameters{3,6}=str2num(get(handles.plotMultipleIbi8x8IbiWindowEdit,'String'));
burstAnalysisParameters{3,7}=get(handles.plotMultipleIbi8x8YLimEdit,'Tag');
burstAnalysisParameters{3,8}=str2num(get(handles.plotMultipleIbi8x8YLimEdit,'String'));
%
burstAnalysisParameters{4,1}=get(handles.performBurstAnalysisStatisticReportCheckbox,'Tag');
burstAnalysisParameters{4,2}=get(handles.performBurstAnalysisStatisticReportCheckbox,'Value');
%
burstAnalysisParameters{5,1}=get(handles.performBurstAnalysisStatisticReportMeanCheckbox,'Tag');
burstAnalysisParameters{5,2}=get(handles.performBurstAnalysisStatisticReportMeanCheckbox,'Value');
%
burstAnalysisParameters{6,1}=get(handles.performBurstAnalysisPlotPercRandSpCheckbox,'Tag');
burstAnalysisParameters{6,2}=get(handles.performBurstAnalysisPlotPercRandSpCheckbox,'Value');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Cross Correlation Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cCorrParameters{1,1}=get(handles.performCrossCorrCheckbox,'Tag');
cCorrParameters{1,2}=get(handles.performCrossCorrCheckbox,'Value');
% % %
cCorrParameters{2,1}=get(handles.performCCorrOnStCheckbox,'Tag');
cCorrParameters{2,2}=get(handles.performCCorrOnStCheckbox,'Value');
cCorrParameters{2,3}=get(handles.performCCorrOnStCorrWinEdit,'Tag');
cCorrParameters{2,4}=str2num(get(handles.performCCorrOnStCorrWinEdit,'String'))*handles.samplingFrequency/handles.multFactor;
cCorrParameters{2,5}=get(handles.performCCorrOnStBinSizeEdit,'Tag');
cCorrParameters{2,6}=str2num(get(handles.performCCorrOnStBinSizeEdit,'String'))*handles.samplingFrequency/handles.multFactor;
cCorrParameters{2,7}=get(handles.performCCorrOnStNormMethPopupmenu,'Tag');
cCorrParameters{2,8}=get(handles.performCCorrOnStNormMethPopupmenu,'Value');
% %
% % %
cCorrParameters{3,1}=get(handles.performCCorrOnBeCheckbox,'Tag');
cCorrParameters{3,2}=get(handles.performCCorrOnBeCheckbox,'Value');
cCorrParameters{3,3}=get(handles.performCCorrOnBeCorrWinEdit,'Tag');
cCorrParameters{3,4}=str2num(get(handles.performCCorrOnBeCorrWinEdit,'String'))*handles.samplingFrequency/handles.multFactor;
cCorrParameters{3,5}=get(handles.performCCorrOnBeBinSizeEdit,'Tag');
cCorrParameters{3,6}=str2num(get(handles.performCCorrOnBeBinSizeEdit,'String'))*handles.samplingFrequency/handles.multFactor;
cCorrParameters{3,7}=get(handles.performCCorrOnBeNormMethPopupmenu,'Tag');
cCorrParameters{3,8}=get(handles.performCCorrOnBeNormMethPopupmenu,'Value');

% % % %%%%%%%
% % % cCorrParameters{4,1}=get(handles.performCCorrCompFuncConnCheckbox,'Tag');
% % % cCorrParameters{4,2}=get(handles.performCCorrCompFuncConnCheckbox,'Value');
% % % cCorrParameters{4,3}=get(handles.performCCorrCompFunConnThreshEdit,'Tag');
% % % cCorrParameters{4,4}=str2num(get(handles.performCCorrCompFunConnThreshEdit,'String'));
% % % cCorrParameters{4,5}=get(handles.performCCorrFuncConnHalfAreaPopupmenu,'Tag');
% % % cCorrParameters{4,6}=get(handles.performCCorrFuncConnHalfAreaPopupmenu,'Value');
% % % cCorrParameters{4,7}=get(handles.performCCorrFuncConnHalfAreaEdit,'Tag');
% % % cCorrParameters{4,8}=str2num(get(handles.performCCorrFuncConnHalfAreaEdit,'String'));
% % % cCorrParameters{4,9}=get(handles.performCCorrCompFunConnMeaPopupmenu,'Tag');
% % % cCorrParameters{4,10}=get(handles.performCCorrCompFunConnMeaPopupmenu,'Value');
% % % cCorrParameters{4,11}=get(handles.performCCorrCompFunConnClusterPopupmenu,'Tag');
% % % cCorrParameters{4,12}=get(handles.performCCorrCompFunConnClusterPopupmenu,'Value');

%%%%%% Plot 3D correlogram
cCorrParameters{5,1}=get(handles.performCCorrPlot3DCorrelogramCheckbox,'Tag');
cCorrParameters{5,2}=get(handles.performCCorrPlot3DCorrelogramCheckbox,'Value');

%%%%%% Plot Mean Correlogram
cCorrParameters{6,1}=get(handles.performCCorrPlotMeanCorrelogramCheckbox,'Tag');
cCorrParameters{6,2}=get(handles.performCCorrPlotMeanCorrelogramCheckbox,'Value');

%%%%%%
cCorrParameters{7,1}=get(handles.anCCSTCheckbox,'Tag');
cCorrParameters{7,2}=get(handles.anCCSTCheckbox,'Value');
cCorrParameters{7,3}=get(handles.binsAroundPeakSTEdit,'Tag');
cCorrParameters{7,4}=str2num(get(handles.binsAroundPeakSTEdit,'String')); %no conversion needed because an integer value is being acquired
cCorrParameters{7,5}=get(handles.binsAroundZeroSTEdit,'Tag');
cCorrParameters{7,6}=str2num(get(handles.binsAroundZeroSTEdit,'String'));
%%%%%%
cCorrParameters{8,1}=get(handles.anCCBECheckbox,'Tag');
cCorrParameters{8,2}=get(handles.anCCBECheckbox,'Value');
cCorrParameters{8,3}=get(handles.binsAroundPeakBEEdit,'Tag');
cCorrParameters{8,4}=str2num(get(handles.binsAroundPeakBEEdit,'String'));
cCorrParameters{8,5}=get(handles.binsAroundZeroBEEdit,'Tag');
cCorrParameters{8,6}=str2num(get(handles.binsAroundZeroBEEdit,'String'));
%

%%% save data in handles variables
handles.chosenParameters{1}=commonParameters;
handles.chosenParameters{2}=peakDetectionParameters;
handles.chosenParameters{3}=plotParameters;
handles.chosenParameters{4}=psthParameters;
handles.chosenParameters{5}=spikeAnalysisParameters;
handles.chosenParameters{6}=burstAnalysisParameters;
handles.chosenParameters{7}=cCorrParameters;
handles.answer ='OK';
guidata(hObject, handles);
uiresume;

% --- Executes on button press in cancelPushbutton.
function cancelPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.answer ='Cancel';
guidata(hObject, handles);
uiresume;
% --- Executes when user attempts to close multipleAnalysisWindow.
function multipleAnalysisWindow_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to multipleAnalysisWindow (see GCBO)
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


% --- Executes on button press in performPeakDetectionCheckbox.
function performPeakDetectionCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to performPeakDetectionCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of performPeakDetectionCheckbox
if (get(hObject,'Value')==1)
    %set objects properties
    set(handles.pddtRadiobutton,'Enable','on');
    set(handles.rtsdRadiobutton,'Enable','on');
    set(handles.pddtRadiobutton,'Value',1);
    set(handles.rtsdRadiobutton,'Value',0);
    set(get(handles.pddtPanel,'Children'),'Enable','on');
    set(get(handles.rtsdPanel,'Children'),'Enable','off');
    set(handles.peakDetectionTitleText,'FontWeight','bold');
    set(hObject,'Enable','on');
else
    set(handles.pddtRadiobutton,'Enable','off');
    set(handles.rtsdRadiobutton,'Enable','off');
    set(handles.pddtRadiobutton,'Value',0);
    set(handles.rtsdRadiobutton,'Value',0);
    set(get(handles.pddtPanel,'Children'),'Enable','off');
    set(get(handles.rtsdPanel,'Children'),'Enable','off');
    tempTitleString=get(handles.peakDetectionTitleText,'String');
    set(handles.peakDetectionTitleText,'FontWeight','normal');
    set(hObject,'Enable','on');
end

% --- Executes during object creation, after setting all properties.
function blankWindForArtEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blankWindForArtEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: peakLifetimePeriodEdit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function peakLifetimePeriodEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to peakLifetimePeriodEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: peakLifetimePeriodEdit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function refractoryPeriodEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to refractoryPeriodEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: peakLifetimePeriodEdit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function standardDeviationCoefficientRTSDEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to standardDeviationCoefficientRTSDEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: peakLifetimePeriodEdit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rtsdRadiobutton.
function rtsdRadiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to rtsdRadiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'Value')==1
    set(get(handles.rtsdPanel,'Children'),'Enable','on');
    set(handles.pddtRadiobutton,'Value',0);
    set(get(handles.pddtPanel,'Children'),'Enable','off');
else
    set(hObject,'Value',1);
end

% --- Executes on button press in pddtRadiobutton.
function pddtRadiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to pddtRadiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of pddtRadiobutton
if get(hObject,'Value')==1
    set(get(handles.pddtPanel,'Children'),'Enable','on');
    set(handles.rtsdRadiobutton,'Value',0);
    set(get(handles.rtsdPanel,'Children'),'Enable','off');
else
    set(hObject,'Value',1);
end

% --- Executes during object creation, after setting all properties.
function rasterPlotStartTimeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rasterPlotStartTimeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function rasterPlotEndTimeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rasterPlotEndTimeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rasterPlotCheckbox.
function rasterPlotCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to rasterPlotCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of rasterPlotCheckbox
if (get(hObject,'Value')==1)
    %set objects properties
    set(get(handles.rasterPlotParamPanel,'Children'),'Enable','on');
    set(hObject,'Enable','on');
    set(handles.plotTitleText,'FontWeight','bold');

else
    set(get(handles.rasterPlotParamPanel,'Children'),'Enable','off');
    set(handles.plotTitleText,'FontWeight','normal');
    set(hObject,'Enable','on');
end
% --------------------------------------------------------------------
function plotTitlePanel_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to plotTitlePanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% title panels
set(findobj('-regexp','Tag','.*TitlePanel'),'BorderType','line');
set(hObject,'BorderType','beveledout');
uistack(findobj('-regexp','Tag','.*(?<=Title)Panel'),'bottom');
uistack(findobj('Tag','plotTitlePanel'),'top');
% send back
uistack(findobj('-regexp','Tag','.*ValuesPanel'),'bottom');
% bring to front
uistack(findobj('Tag','plotValuesPanel'),'top');
% set visible property 'on' and 'off'
set(findobj('-regexp','Tag','.*ValuesPanel'),'Visible','off');
set(findobj('Tag','plotValuesPanel'),'Visible','on');

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over plotTitleText.
function plotTitleText_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to plotTitleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plotTitlePanel_ButtonDownFcn(get(hObject,'Parent'), eventdata, handles);

function plotMultipleIbi8x8IbiBinEdit_Callback(hObject, eventdata, handles)
% hObject    handle to plotMultipleIbi8x8IbiBinEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotMultipleIbi8x8IbiBinEdit as text
%        str2double(get(hObject,'String')) returns contents of plotMultipleIbi8x8IbiBinEdit as a double


% --- Executes during object creation, after setting all properties.
function plotMultipleIbi8x8IbiBinEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotMultipleIbi8x8IbiBinEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function plotMultipleIbi8x8IbiWindowEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotMultipleIbi8x8IbiWindowEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function plotMultipleIbi8x8YLimEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotMultipleIbi8x8YLimEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in performBurstAnalysisPlotMultipleIBI8x8Checkbox.
function performBurstAnalysisPlotMultipleIBI8x8Checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to performBurstAnalysisPlotMultipleIBI8x8Checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of performBurstAnalysisPlotMultipleIBI8x8Checkbox

if get(hObject,'Value')==1
    set(get(handles.performBurstAnalysisPlotMultipleIBI8x8ParamPanel,'Children'),'Enable','on');
else
    set(get(handles.performBurstAnalysisPlotMultipleIBI8x8ParamPanel,'Children'),'Enable','off');
end

% --- Executes during object creation, after setting all properties.
function performBurstAnalysisMinNumIntraSpikesEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to performBurstAnalysisMinNumIntraSpikesEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function performBurstAnalysisMaxIntraIsiEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to performBurstAnalysisMaxIntraIsiEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function performBurstAnalysisBurstRateThreshEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to performBurstAnalysisBurstRateThreshEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in performBurstAnalysisCheckbox.
function performBurstAnalysisCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to performBurstAnalysisCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of performBurstAnalysisCheckbox
if (get(hObject,'Value')==1)
    %set objects properties
    % Enable
    set(findobj('-regexp','Tag','performBurstAnalysis.*Checkbox'),'Enable','on');
    % Value
    set(findobj('-regexp','Tag','performBurstAnalysis.*Checkbox'),'Value',1);
    % get(findobj(''))
    % Children Enable
    set(cell2mat(get(findobj('-regexp','Tag','performBurstAnalysis.*ParamPanel'),'Children')),'Enable','on');
    % text
    set(handles.burtsAnalysisTitleText,'FontWeight','bold');
    set(hObject,'Enable','on');
else
    % set objects properties
    % Enable
    set(findobj('-regexp','Tag','performBurstAnalysis.*Checkbox'),'Enable','off');
    % Value
    set(findobj('-regexp','Tag','performBurstAnalysis.*Checkbox'),'Value',0);
    %     get(findobj(''))
    % Children Enable
    set(cell2mat(get(findobj('-regexp','Tag','performBurstAnalysis.*ParamPanel'),'Children')),'Enable','off');
    set(handles.burtsAnalysisTitleText,'FontWeight','normal');
    set(hObject,'Enable','on');
end

% --------------------------------------------------------------------
function burtsAnalysisTitlePanel_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to burtsAnalysisTitlePanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% title panels
set(findobj('-regexp','Tag','.*TitlePanel'),'BorderType','line');
set(hObject,'BorderType','beveledout');
uistack(findobj('-regexp','Tag','.*(?<=Title)Panel'),'bottom');
uistack(findobj('Tag','burtsAnalysisTitlePanel'),'top');
% send back
uistack(findobj('-regexp','Tag','.*ValuesPanel'),'bottom');
% bring to front
uistack(findobj('Tag','burstAnalysisValuesPanel'),'top');
% set visible property 'on' and 'off'
set(findobj('-regexp','Tag','.*ValuesPanel'),'Visible','off');
set(findobj('Tag','burstAnalysisValuesPanel'),'Visible','on');


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over burtsAnalysisTitleText.
function burtsAnalysisTitleText_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to burtsAnalysisTitleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
burtsAnalysisTitlePanel_ButtonDownFcn(get(hObject,'Parent'), eventdata, handles);

% --- Executes on button press in performBurstAnalysisBurstDetectionCheckbox.
function performBurstAnalysisBurstDetectionCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to performBurstAnalysisBurstDetectionCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of performBurstAnalysisBurstDetectionCheckbox
if get(hObject,'Value')==1
    set(get(handles.performBurstAnalysisBurstDetectionParamPanel,'Children'),'Enable','on');
else
    set(get(handles.performBurstAnalysisBurstDetectionParamPanel,'Children'),'Enable','off');
end

% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit36_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function psthBinSizeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to psthBinSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function psthTimeFrameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to psthTimeFrameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of psthTimeFrameEdit as text
%        str2double(get(hObject,'String')) returns contents of psthTimeFrameEdit as a double


% --- Executes during object creation, after setting all properties.
function psthTimeFrameEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to psthTimeFrameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in performPsthCheckbox.
function performPsthCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to performPsthCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of performBurstAnalysisCheckbox
if (get(hObject,'Value')==1)
    %set objects properties
    % Enable
    set(findobj('-regexp','Tag','performPsth.*Checkbox'),'Enable','on');
    % Value
    set(findobj('-regexp','Tag','performPsth.*Checkbox'),'Value',1);
    % get(findobj(''))
    % Children Enable
    set(cell2mat(get(findobj('-regexp','Tag','performPsth.*ParamPanel'),'Children')),'Enable','on');
    % text
    set(handles.psthTitleText,'FontWeight','bold');
    set(hObject,'Enable','on');
else
    % set objects properties
    % Enable
    set(findobj('-regexp','Tag','performPsth.*Checkbox'),'Enable','off');
    % Value
    set(findobj('-regexp','Tag','performPsth.*Checkbox'),'Value',0);
    %     get(findobj(''))
    % Children Enable
    set(cell2mat(get(findobj('-regexp','Tag','performPsth.*ParamPanel'),'Children')),'Enable','off');
    set(handles.psthTitleText,'FontWeight','normal');
    set(hObject,'Enable','on');
end

% --- Executes on button press in performPsthPlotMulPsth8x8CheckBox.
function performPsthPlotMulPsth8x8CheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to performPsthPlotMulPsth8x8CheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of performPsthPlotMulPsth8x8CheckBox
if get(hObject,'Value')==1
    set(get(handles.performPsthPlotMulPsth8x8ParamPanel,'Children'),'Enable','on');
else
    set(get(handles.performPsthPlotMulPsth8x8ParamPanel,'Children'),'Enable','off');
end



% --- Executes during object creation, after setting all properties.
function plotMulPsthNumStimSesEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotMulPsthNumStimSesEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function plotMulPsthXAxisLimitEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotMulPsthXAxisLimitEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit45_Callback(hObject, eventdata, handles)
% hObject    handle to edit45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit45 as text
%        str2double(get(hObject,'String')) returns contents of edit45 as a double


% --- Executes during object creation, after setting all properties.
function edit45_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plotMulPsth8x8StimSesEdit_Callback(hObject, eventdata, handles)
% hObject    handle to plotMulPsth8x8StimSesEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotMulPsth8x8StimSesEdit as text
%        str2double(get(hObject,'String')) returns contents of plotMulPsth8x8StimSesEdit as a double


% --- Executes during object creation, after setting all properties.
function plotMulPsth8x8StimSesEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotMulPsth8x8StimSesEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plotMulPsth8x8PsthTimeFrameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to plotMulPsth8x8PsthTimeFrameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotMulPsth8x8PsthTimeFrameEdit as text
%        str2double(get(hObject,'String')) returns contents of plotMulPsth8x8PsthTimeFrameEdit as a double


% --- Executes during object creation, after setting all properties.
function plotMulPsth8x8PsthTimeFrameEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotMulPsth8x8PsthTimeFrameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit48_Callback(hObject, eventdata, handles)
% hObject    handle to edit48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit48 as text
%        str2double(get(hObject,'String')) returns contents of edit48 as a double


% --- Executes during object creation, after setting all properties.
function edit48_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in performPsthCompAreaPsthCheckBox.
function performPsthCompAreaPsthCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to performPsthCompAreaPsthCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of performPsthCompAreaPsthCheckBox



function plotMulPsth8x8PsthYAxisLimEdit_Callback(hObject, eventdata, handles)
% hObject    handle to plotMulPsth8x8PsthYAxisLimEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plotMulPsth8x8PsthYAxisLimEdit as text
%        str2double(get(hObject,'String')) returns contents of plotMulPsth8x8PsthYAxisLimEdit as a double


% --- Executes during object creation, after setting all properties.
function plotMulPsth8x8PsthYAxisLimEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotMulPsth8x8PsthYAxisLimEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------
function psthTitlePanel_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to psthTitlePanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% title panels
set(findobj('-regexp','Tag','.*TitlePanel'),'BorderType','line');
set(hObject,'BorderType','beveledout');
uistack(findobj('-regexp','Tag','.*(?<=Title)Panel'),'bottom');
uistack(findobj('Tag','psthTitlePanel'),'top');
% send back
uistack(findobj('-regexp','Tag','.*ValuesPanel'),'bottom');
% bring to front
uistack(findobj('Tag','psthValuesPanel'),'top');
% set visible property 'on' and 'off'
set(findobj('-regexp','Tag','.*ValuesPanel'),'Visible','off');
set(findobj('Tag','psthValuesPanel'),'Visible','on');

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over psthTitleText.
function psthTitleText_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to psthTitleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
psthTitlePanel_ButtonDownFcn(get(hObject,'Parent'), eventdata, handles);

% --- Executes during object creation, after setting all properties.
function compMfrFrthreshEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to compMfrFrthreshEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function compAfrFrthreshEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to compMfrFrthreshEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit53_CreateFcn(hObject, eventdata, handles)
% hObject    handle to compMfrFrthreshEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit54_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function plotMulIsiIsiBinEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotMulIsiIsiBinEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function plotMulIsiIsiWinEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotMulIsiIsiWinEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function plotMulIsiIsiYLimEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotMulIsiIsiYLimEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in performPsthCompPsthLatencyCheckbox.
function performPsthCompPsthLatencyCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to performPsthCompPsthLatencyCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of performPsthCompPsthLatencyCheckbox

if get(hObject,'Value')==1
    set(get(handles.performPsthCompPsthLatencyParamPanel,'Children'),'Enable','on');
else
    set(get(handles.performPsthCompPsthLatencyParamPanel,'Children'),'Enable','off');
end


% --- Executes on button press in performPsthPlotMulPsthCheckbox.
function performPsthPlotMulPsthCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to performPsthPlotMulPsthCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of performPsthPlotMulPsthCheckbox

if get(hObject,'Value')==1
    set(get(handles.performPsthPlotMulPsthParamPanel,'Children'),'Enable','on');
else
    set(get(handles.performPsthPlotMulPsthParamPanel,'Children'),'Enable','off');
end



% --- Executes on button press in performPsthPlotMulPsth8x8Checkbox.
function performPsthPlotMulPsth8x8Checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to performPsthPlotMulPsth8x8Checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of performPsthPlotMulPsth8x8Checkbox

if get(hObject,'Value')==1
    set(get(handles.performPsthPlotMulPsth8x8ParamPanel,'Children'),'Enable','on');
else
    set(get(handles.performPsthPlotMulPsth8x8ParamPanel,'Children'),'Enable','off');
end



% --- Executes on button press in performSpikeAnalysisCheckbox.
function performSpikeAnalysisCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to performSpikeAnalysisCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of performSpikeAnalysisCheckbox
if (get(hObject,'Value')==1)
    %set objects properties
    % Enable
    set(findobj('-regexp','Tag','performSpikeAnalysis.*Checkbox'),'Enable','on');
    % Value
    set(findobj('-regexp','Tag','performSpikeAnalysis.*Checkbox'),'Value',1);
    % get(findobj(''))
    % Children Enable
    set(cell2mat(get(findobj('-regexp','Tag','performSpikeAnalysis.*ParamPanel'),'Children')),'Enable','on');
    % text
    set(handles.spikeAnalysisTitleText,'FontWeight','bold');
    set(hObject,'Enable','on');
else
    % set objects properties
    % Enable
    set(findobj('-regexp','Tag','performSpikeAnalysis.*Checkbox'),'Enable','off');
    % Value
    set(findobj('-regexp','Tag','performSpikeAnalysis.*Checkbox'),'Value',0);
    %     get(findobj(''))
    % Children Enable
    set(cell2mat(get(findobj('-regexp','Tag','performSpikeAnalysis.*ParamPanel'),'Children')),'Enable','off');
    set(handles.spikeAnalysisTitleText,'FontWeight','normal');
    set(hObject,'Enable','on');
end




% --- Executes on button press in performSpikeAnalysisCompAvFirRateCheckbox.
function performSpikeAnalysisCompAvFirRateCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to performSpikeAnalysisCompAvFirRateCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of performSpikeAnalysisCompAvFirRateCheckbox


if get(hObject,'Value')==1
    set(get(handles.performSpikeAnalysisCompAvFirRateParamPanel,'Children'),'Enable','on');
else
    set(get(handles.performSpikeAnalysisCompAvFirRateParamPanel,'Children'),'Enable','off');
end



% --------------------------------------------------------------------
function spikeAnalysisTitlePanel_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to spikeAnalysisTitlePanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% title panels
set(findobj('-regexp','Tag','.*TitlePanel'),'BorderType','line');
set(hObject,'BorderType','beveledout');
uistack(findobj('-regexp','Tag','.*(?<=Title)Panel'),'bottom');
uistack(hObject,'top');
% send back
uistack(findobj('-regexp','Tag','.*ValuesPanel'),'bottom');
% bring to front
uistack(findobj('Tag','spikeAnalysisValuesPanel'),'top');
% set visible property 'on' and 'off'
set(findobj('-regexp','Tag','.*ValuesPanel'),'Visible','off');
set(findobj('Tag','spikeAnalysisValuesPanel'),'Visible','on');

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over spikeAnalysisTitleText.
function spikeAnalysisTitleText_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to spikeAnalysisTitleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
spikeAnalysisTitlePanel_ButtonDownFcn(get(hObject,'Parent'), eventdata, handles);


% --- Executes on button press in performSpikeAnalysisCompMeanFiringRateCheckbox.
function performSpikeAnalysisCompMeanFiringRateCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to performSpikeAnalysisCompMeanFiringRateCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of performSpikeAnalysisCompMeanFiringRateCheckbox

if get(hObject,'Value')==1
    set(get(handles.performSpikeAnalysisFirRateThreshParamPanel,'Children'),'Enable','on');
else
    set(get(handles.performSpikeAnalysisFirRateThreshParamPanel,'Children'),'Enable','off');
end



% --- Executes on button press in performSpikeAnalysisPlotMulIsiCheckbox.
function performSpikeAnalysisPlotMulIsiCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to performSpikeAnalysisPlotMulIsiCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of performSpikeAnalysisPlotMulIsiCheckbox


if get(hObject,'Value')==1
    set(get(handles.performSpikeAnalysisPlotMulIsiParamPanel,'Children'),'Enable','on');
else
    set(get(handles.performSpikeAnalysisPlotMulIsiParamPanel,'Children'),'Enable','off');
end




function edit61_Callback(hObject, eventdata, handles)
% hObject    handle to edit61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit61 as text
%        str2double(get(hObject,'String')) returns contents of edit61 as a double


% --- Executes during object creation, after setting all properties.
function edit61_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit61 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit62_Callback(hObject, eventdata, handles)
% hObject    handle to edit62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit62 as text
%        str2double(get(hObject,'String')) returns contents of edit62 as a double


% --- Executes during object creation, after setting all properties.
function edit62_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit62 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit60_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit57_Callback(hObject, eventdata, handles)
% hObject    handle to edit57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit57 as text
%        str2double(get(hObject,'String')) returns contents of edit57 as a double


% --- Executes during object creation, after setting all properties.
function edit57_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit57 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit58_Callback(hObject, eventdata, handles)
% hObject    handle to edit58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit58 as text
%        str2double(get(hObject,'String')) returns contents of edit58 as a double


% --- Executes during object creation, after setting all properties.
function edit58_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit58 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit59_Callback(hObject, eventdata, handles)
% hObject    handle to edit59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit59 as text
%        str2double(get(hObject,'String')) returns contents of edit59 as a double


% --- Executes during object creation, after setting all properties.
function edit59_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit59 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function performCCorrOnStCorrWinEdit_Callback(hObject, eventdata, handles)
% hObject    handle to performCCorrOnStCorrWinEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of performCCorrOnStCorrWinEdit as text
%        str2double(get(hObject,'String')) returns contents of performCCorrOnStCorrWinEdit as a double

% --- Executes during object creation, after setting all properties.
function performCCorrOnStCorrWinEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to performCCorrOnStCorrWinEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function performCCorrOnStBinSizeEdit_Callback(hObject, eventdata, handles)
% hObject    handle to performCCorrOnStBinSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of performCCorrOnStBinSizeEdit as text
%        str2double(get(hObject,'String')) returns contents of performCCorrOnStBinSizeEdit as a double

% --- Executes during object creation, after setting all properties.
function performCCorrOnStBinSizeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to performCCorrOnStBinSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in performCCorrOnStNormMethPopupmenu.
function performCCorrOnStNormMethPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to performCCorrOnStNormMethPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns performCCorrOnStNormMethPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from performCCorrOnStNormMethPopupmenu

% --- Executes during object creation, after setting all properties.
function performCCorrOnStNormMethPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to performCCorrOnStNormMethPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function performCCorrOnStHalfAreaEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to performCCorrOnStHalfAreaEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit70_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit70 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit71_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit71 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function performCCorrOnBeCorrWinEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to performCCorrOnBeCorrWinEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit77_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit77 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function performCCorrOnBeHalfAreaEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to performCCorrOnBeHalfAreaEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function performCCorrCompFunConnThreshEdit_Callback(hObject, eventdata, handles)
% hObject    handle to performCCorrCompFunConnThreshEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of performCCorrCompFunConnThreshEdit as text
%        str2double(get(hObject,'String')) returns contents of performCCorrCompFunConnThreshEdit as a double

% --- Executes during object creation, after setting all properties.
function performCCorrCompFunConnThreshEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to performCCorrCompFunConnThreshEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit82_Callback(hObject, eventdata, handles)
% hObject    handle to edit82 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit82 as text
%        str2double(get(hObject,'String')) returns contents of edit82 as a double

% --- Executes during object creation, after setting all properties.
function edit82_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit82 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in performCCorrFuncConnHalfAreaPopupmenu.
function performCCorrFuncConnHalfAreaPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to performCCorrFuncConnHalfAreaPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns performCCorrFuncConnHalfAreaPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from performCCorrFuncConnHalfAreaPopupmenu

% --- Executes during object creation, after setting all properties.
function performCCorrFuncConnHalfAreaPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to performCCorrFuncConnHalfAreaPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in compFuncConnCheckbox.
function compFuncConnCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to compFuncConnCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of compFuncConnCheckbox

% --- Executes during object creation, after setting all properties.
function performCCorrC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to performCCorrC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function performCCorrCompFunConnClusterPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to performCCorrCompFunConnClusterPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in performCrossCorrCheckbox.
function performCrossCorrCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to performCrossCorrCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of performCrossCorrCheckbox

if (get(hObject,'Value')==1)
    %set objects properties
    % Enable
    set(findobj('-regexp','Tag','performCCorr.*Checkbox'),'Enable','on');
    % Value
    set(findobj('-regexp','Tag','performCCorr.*Checkbox'),'Value',1);
    % Enable
    set(findobj('-regexp','Tag','anCC.*Checkbox'),'Enable','on');
    % Value
    set(findobj('-regexp','Tag','anCC.*Checkbox'),'Value',1);
    % Children Enable
    set(cell2mat(get(findobj('-regexp','Tag','performCCorr.*ParamPanel'),'Children')),'Enable','on');
 
    %
    % text
    set(handles.crossCorrelationTitleText,'FontWeight','bold');
    set(hObject,'Enable','on');
else
    % set objects properties
    % Enable
    set(findobj('-regexp','Tag','performCCorr.*Checkbox'),'Enable','off');
    % Value
    set(findobj('-regexp','Tag','performCCorr.*Checkbox'),'Value',0);
    % Enable
    set(findobj('-regexp','Tag','anCC.*Checkbox'),'Enable','off');
    % Value
    set(findobj('-regexp','Tag','anCC.*Checkbox'),'Value',0);
    %     get(findobj(''))
    % Children Enable
    set(cell2mat(get(findobj('-regexp','Tag','performCCorr.*ParamPanel'),'Children')),'Enable','off');
    set(cell2mat(get(findobj('-regexp','Tag','anCC.*ParamPanel'),'Children')),'Enable','off');

    set(handles.crossCorrelationTitleText,'FontWeight','normal');
    set(hObject,'Enable','on');
end

% --------------------------------------------------------------------
function crossCorrelationTitlePanel_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to crossCorrelationTitlePanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(findobj('-regexp','Tag','.*TitlePanel'),'BorderType','line');
set(hObject,'BorderType','beveledout');
uistack(findobj('-regexp','Tag','.*(?<=Title)Panel'),'bottom');
uistack(hObject,'top');
% send back
uistack(findobj('-regexp','Tag','.*ValuesPanel'),'bottom');
% bring to front
uistack(findobj('Tag','crossCorrelationValuesPanel'),'top');
% set visible property 'on' and 'off'
set(findobj('-regexp','Tag','.*ValuesPanel'),'Visible','off');
set(findobj('Tag','crossCorrelationValuesPanel'),'Visible','on');

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over crossCorrelationTitleText.
function crossCorrelationTitleText_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to crossCorrelationTitleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
crossCorrelationTitlePanel_ButtonDownFcn(get(hObject,'Parent'), eventdata, handles);

% --- Executes on button press in performCCorrOnStCheckbox.
function performCCorrOnStCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to performCCorrOnStCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of performCCorrOnStCheckbox
if get(hObject,'Value')==1
    set(get(handles.performCCorrOnStParamPanel,'Children'),'Enable','on');
else
    set(get(handles.performCCorrOnStParamPanel,'Children'),'Enable','off');
end

% --- Executes on button press in performCCorrOnBeCheckbox.
function performCCorrOnBeCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to performCCorrOnBeCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of performCCorrOnBeCheckbox
if get(hObject,'Value')==1
    set(get(handles.performCCorrOnBeParamPanel,'Children'),'Enable','on');
else
    set(get(handles.performCCorrOnBeParamPanel,'Children'),'Enable','off');
end

% --- Executes on button press in performCCorrCompFuncConnCheckbox.
function performCCorrCompFuncConnCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to performCCorrCompFuncConnCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of performCCorrCompFuncConnCheckbox
if get(hObject,'Value')==1
    set(get(handles.performCCorrCompFuncConnParamPanel,'Children'),'Enable','on');
else
    set(get(handles.performCCorrCompFuncConnParamPanel,'Children'),'Enable','off');
end

% --- Executes during object creation, after setting all properties.
function performCCorrFuncConnHalfAreaEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to performCCorrFuncConnHalfAreaEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object deletion, before destroying properties.
function performCCorrFuncConnHalfAreaPopupmenu_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to performCCorrFuncConnHalfAreaPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function rtsdMinArtEdit_Callback(hObject, eventdata, handles)
% hObject    handle to rtsdMinArtEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rtsdMinArtEdit as text
%        str2double(get(hObject,'String')) returns contents of rtsdMinArtEdit as a double

% --- Executes during object creation, after setting all properties.
function rtsdMinArtEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rtsdMinArtEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function compAfrBinSizeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to compAfrBinSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function performCCorrOnBeNormMethPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to performCCorrOnBeNormMethPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function performCCorrCompFunConnMeaPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to performCCorrCompFunConnMeaPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in anCCBEcheckbox.
function anCCBEcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to anCCBEcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of anCCBEcheckbox



function binsAroundPeakSTEdit_Callback(hObject, eventdata, handles)
% hObject    handle to binsAroundPeakSTEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of binsAroundPeakSTEdit as text
%        str2double(get(hObject,'String')) returns contents of binsAroundPeakSTEdit as a double


% --- Executes during object creation, after setting all properties.
function binsAroundPeakSTEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to binsAroundPeakSTEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function binsAroundZeroSTEdit_Callback(hObject, eventdata, handles)
% hObject    handle to binsAroundZeroSTEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of binsAroundZeroSTEdit as text
%        str2double(get(hObject,'String')) returns contents of binsAroundZeroSTEdit as a double


% --- Executes during object creation, after setting all properties.
function binsAroundZeroSTEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to binsAroundZeroSTEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu11.
function popupmenu11_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu11 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu11


% --- Executes during object creation, after setting all properties.
function popupmenu11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function binsAroundPeakBEEdit_Callback(hObject, eventdata, handles)
% hObject    handle to binsAroundPeakBEEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of binsAroundPeakBEEdit as text
%        str2double(get(hObject,'String')) returns contents of binsAroundPeakBEEdit as a double


% --- Executes during object creation, after setting all properties.
function binsAroundPeakBEEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to binsAroundPeakBEEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function binsAroundZeroBEEdit_Callback(hObject, eventdata, handles)
% hObject    handle to binsAroundZeroBEEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of binsAroundZeroBEEdit as text
%        str2double(get(hObject,'String')) returns contents of binsAroundZeroBEEdit as a double


% --- Executes during object creation, after setting all properties.
function binsAroundZeroBEEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to binsAroundZeroBEEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in anCCSTCheckbox.
function anCCSTCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to anCCSTCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of anCCSTCheckbox
if get(hObject,'Value')==1
    set(get(handles.anCCSTParamPanel,'Children'),'Enable','on');
else
    set(get(handles.anCCSTParamPanel,'Children'),'Enable','off');
end

% --- Executes on button press in anCCBECheckbox.
function anCCBECheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to anCCBECheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of anCCBECheckbox
% Hint: get(hObject,'Value') returns toggle state of anCCSTCheckbox
if get(hObject,'Value')==1
    set(get(handles.anCCBEParamPanel,'Children'),'Enable','on');
else
    set(get(handles.anCCBEParamPanel,'Children'),'Enable','off');
end


% --- Executes on button press in performBurstAnalysisPlotPercRandSpCheckbox.
function performBurstAnalysisPlotPercRandSpCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to performBurstAnalysisPlotPercRandSpCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of performBurstAnalysisPlotPercRandSpCheckbox





function artifactThreshold_spkTrn_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to artifactThreshold_spkTrn_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of artifactThreshold_spkTrn_Edit as text
%        str2double(get(hObject,'String')) returns contents of artifactThreshold_spkTrn_Edit as a double


% --- Executes during object creation, after setting all properties.
function artifactThreshold_spkTrn_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to artifactThreshold_spkTrn_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minArtefactDistEdit_Callback(hObject, eventdata, handles)
% hObject    handle to minArtefactDistEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minArtefactDistEdit as text
%        str2double(get(hObject,'String')) returns contents of minArtefactDistEdit as a double


% --- Executes during object creation, after setting all properties.
function minArtefactDistEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minArtefactDistEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over cancelPushbutton.
function cancelPushbutton_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to cancelPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function peakDetectionTitleText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to peakDetectionTitleText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% --- Executes during object deletion, before destroying properties.
function compMfrFrthreshEdit_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to compMfrFrthreshEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function peakDetectionTitlePanel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to peakDetectionTitlePanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
