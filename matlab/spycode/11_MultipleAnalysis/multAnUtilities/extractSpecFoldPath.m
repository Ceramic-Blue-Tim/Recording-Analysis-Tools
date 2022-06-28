function [ foldNum, foldPath ] = extractSpecFoldPath( expFolder,exprStrToFind )
% EXTRACTSPECFOLDPATH given a starting folder (expFolder) and a regular
% expression (exprStrToFind) the function returns the number of folders
% contained in the given one and whose names match the given expression, if
% only a folder matching exprStrToFind has been found it also returns its
% complete path, otherwise it returns an empty string
% created by Luca Leonardo Bologna 26 February 2007

foldNum=0;
cont=dir(expFolder);
contNames={cont.name};
isDirIdx=[cont.isdir];
dirNames=contNames(isDirIdx);
% Look for exprStrToFind folder
foldPath=regexpi(dirNames,exprStrToFind,'match','once');
% indices of exprStrToFind names folders
idx=find(~strcmp(foldPath(:),''));
foldPath=foldPath(idx);
foldPath=char(foldPath);
foldNum=size(foldPath,1);
% % % % % if foldNum==1
foldPath=deblank(strcat(expFolder,filesep,foldPath)); %;
% % % % % else
% % % % %     foldPath='';
% % % % % end
