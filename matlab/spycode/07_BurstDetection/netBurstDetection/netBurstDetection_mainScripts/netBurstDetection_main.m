% Get user inputs
% INPUT folder
BDResFolder = uigetdir(pwd,'Select the folder that contains the BurstDetectionFiles results:');
if strcmp(num2str(BDResFolder),'0')          % halting case
    warndlg('Select a folder!','!!Warning!!')
    return
end
[path, filename] = fileparts(BDResFolder);
% IBEI thresholds file
IBEIThFolder = uigetdir(path,'Select the folder that contains the IBEI thresholds:');
if strcmp(num2str(IBEIThFolder),'0')          % halting case
    warndlg('Select a folder!','!!Warning!!')
    return
end
% OUTPUT folder
string = 'NetworkBurstDetectionFiles';
[NBDResFolder, overwriteFlag] = createResultFolder(path, string);
if(isempty(NBDResFolder))
    errordlg('Error creating output folder!','!!Error!!')
    return
end
% INPUT parameters
[parameters, flag] = netBurstDetection_uigetParam();
if(flag)
%     tic
    % Launch algorithm to detect NB
    [NBursts, NBurstsPattern] = netBurstDetection_trialCycle(BDResFolder, IBEIThFolder, parameters);
%     toc
    % saves results
    netBurstDetection_save(BDResFolder, NBDResFolder, parameters, NBursts, NBurstsPattern);
    msgbox('Network Burst Detection','End Of Session','warn')
else
    errordlg('Selection failed: end of session','Error')
end