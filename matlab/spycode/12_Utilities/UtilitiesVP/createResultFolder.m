% createResultFolder.m
% by Valentina Pasquale, 2008-02-25
% ARGUMENTS:
% parentDir: a string containing the absolute path of the PARENT directory:
%   the name of the folder should begin with the number of the experiment, 
%   followed by an underscore (e.g. C:\valentina\235_spontaneous, 
%   D:\work\20081503_inPhaseTetanicOnIMT) - to be modified as soon as the
%   general information of the exp will be saved in a common file
% string: a string contaning the type of the performed analysis: e.g. ISI, SpikeAnalysis, BurstAnalysis 
% OUTPUT:
%   folderPath: returns the absolute path of the created folder;
%   overwriteFlag: a flag returned to the user that says if previous results have
%       been overwritten or not
% It prevents unwanted replacement of previous results, by asking to the
% user what he/she wants to do
function [folderPath, overwriteFlag] = createResultFolder(parentDir, string)
overwriteFlag = 0;
folderPath = [];
existFolder = searchFolder(parentDir, string);
if(~isempty(existFolder))
    answer = questdlg('Overwrite existing results?','!!Warning!!','Yes','No','No');
    switch answer
        case 'Yes'  % overwrites (if it is possible) the last folder found (the most recent)
            overwriteFlag = 1;
%             [success,message] = rmdir(existFolder{end},'s');
%             if ~success
%                 errordlg(['Removing directory:', message], '!!Error!!', 'modal');
%                 return
%             end
            [path,folderName] = fileparts(existFolder{end});
            warning('off','MATLAB:MKDIR:DirectoryExists')
        case 'No'   % creates another folder adding a progressive number to the name
            [path,name] = fileparts(existFolder{end});
            openParenIdx = strfind(name,'(');
            closeParenIdx = strfind(name,')');
            if ~isempty(openParenIdx) && ~isempty(closeParenIdx)
                folderNum = str2double(name(openParenIdx+1:closeParenIdx-1))+1;
                folderName = strcat(name(1:openParenIdx-1),'(',num2str(folderNum),')');
            else
                folderName = strcat(name,'(1)');
            end
    end
else
    expNum = find_expnum(parentDir, '_');
    folderName = strcat(expNum,'_',string);
end
[success,message] = mkdir(parentDir,folderName);
if ~success
    errordlg(['Making new directory: ', message], '!!Error!!', 'modal');
    return
end
folderPath = [parentDir,filesep,folderName];