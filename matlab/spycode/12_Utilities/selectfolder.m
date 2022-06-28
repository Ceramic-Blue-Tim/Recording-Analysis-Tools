function [userfolder]= selectfolder (string)
%
% by Michela Chiappalone (7 Febbraio 2006)

userfolder = uigetdir(pwd,string);
% if strcmp(num2str(userfolder),'0')
%     errordlg('Selection Failed - End of Session', 'Error');
%     return
% end