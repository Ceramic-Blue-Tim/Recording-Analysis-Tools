function [ fileType ] = extractNumberChannels( fileList, extension )
% EXTRACTNUMBERCHANNELS extract the number of channels the mea has

fileNum = length(fileList);
fileType = cell(length(fileList), 1);
%
if strcmp(extension,'mcd')
    for i = 1 : fileNum
        fileType(i) = {extractFilesTypesMcd_ns(deblank(char(fileList(i))))};
    end
elseif strcmp(extension,'med')
    fileType(1:fileNum) = 64;
    fileType = num2cell(fileType);
end