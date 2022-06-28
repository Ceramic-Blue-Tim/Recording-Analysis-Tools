% replaceArtefact_getParam.m
% Get algorithm parameters from user input
function [replaceArtParam, flag] = replaceArtefact_getParam()
% initialize variables (in case they are not assigned)
replaceArtParam = struct('minArtAmpl',[],'sf',[]);
flag = 0;
% user inputs
PopupPrompt  = {'Artefact threshold (Analog Raw Data) [mV]',...
    'Sampling rate [Hz]'};
PopupTitle   = 'Replace Artefact Detection';
PopupLines   = 1;
PopupDefault = {'200', GlobalsParams.DEFAULT_FS_CHAR};
%----------------------------------- PARAMETER CONVERSION
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault,'on');
if isempty(Ianswer) % halt condition
    return
else
    replaceArtParam.minArtAmpl = str2double(Ianswer{1,1});
    replaceArtParam.sf = str2double(Ianswer{2,1});
    flag = 1;
end