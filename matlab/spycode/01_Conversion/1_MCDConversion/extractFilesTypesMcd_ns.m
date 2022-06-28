function fileType = extractFilesTypesMcd_ns(fileName)
% EXTRACTFILESTYPESMCD_NS extracts the .mcd type file, i.e. the system with
% which the .mcd file was recorded

%check the type of the file
[nsresult, hfile] = ns_OpenFile(fileName);
[nsresult, FileInfo] = ns_GetFileInfo(hfile);
% fileType = strtok(FileInfo.FileType);
[nsresult, EntityInfo] = ns_GetEntityInfo(hfile, 1:FileInfo.EntityCount);

% extract labels of current file
crrFlCrrLbls = {EntityInfo.EntityLabel};

% extract string identifier
% allNumIdent = cellfun(@(x) x(1:4), crrFlCrrLbls, 'UniformOutput', 0);

% indices of all stream containing an electrode name
% idxAllElId = ~(cellfun(@isempty, regexp(allNumIdent, '(\<elec\>)|(\<spks\>)|(\<filt\>)|(\<chtl\>)')));

% all stream electrode identifier
% allElId = cellfun(@(x) x(25:27), crrFlCrrLbls(idxAllElId),'UniformOutput', 0);

% 27th of the label position being either letter A or B in 120 system
allElId = cellfun(@(x) x(27), crrFlCrrLbls(:), 'UniformOutput', 0);


% meaA indices
allMeaAIdx = find(~(cellfun(@isempty, regexp(allElId, '(A\>)'))));

% meaB indices
allMeaBIdx = find(~(cellfun(@isempty, regexp(allElId, '(B\>)'))));

if ~isempty(allMeaAIdx) && ~isempty(allMeaBIdx)
    fileType = 128;
else
    fileType = 64;
end


% % % % % % % % % % % % % % % % % % % % % % % % to be del after testing new spycode version - start
% fd = fopen('EntityLabel.txt', 'a+');
% [a b c d] = fileparts(fileName);
% fprintf(fd, [b '\n']);
% for i = 1 : FileInfo.EntityCount
%     fprintf(fd, [EntityInfo(i).EntityLabel '\n']);
% end
% fclose(fd);
% % % % % % % % % % % % % % % % % % % % % % % to be del after testing new spycode version - end

ns_CloseFile(hfile);