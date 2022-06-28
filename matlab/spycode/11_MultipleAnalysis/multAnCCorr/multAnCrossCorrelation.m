function [ outputMessage ] = multAnCrossCorrelation(expFolder,commonParameters, peakDetectionParameters)
%MULTANCROSSCORRELATION Summary of this function goes here
%   Detailed explanation goes here
%common parameters
sampFreq=commonParameters{1,2};
artThresh=commonParameters{1,4};
blankWinForArt=commonParameters{1,6};
mFactor=1000;

outputMessage=['Folder ' expFolder ': '];
% verify if a MAT_ folder is present
folders=dir(expFolder);
folders={folders.name};
matFolders=regexpi(folders,'.*Mat_files.*','match','once');
% indices of Mat_files names folders
idx=find(~strcmp(matFolders(:),''));
matFolders=matFolders(idx);
matFolders=char(matFolders);
foldNum=size(matFolders,1);
% 
if foldNum==0
    outputMessage=[outputMessage 'impossible to perform Peak Detection: no MAT_files folder is present'];
    return
elseif foldNum>1
    outputMessage=[outputMessage 'impossible to perform Peak Detection: more than one MAT_files folder is present'];
    return
else
        start_folder=deblank(strcat(expFolder,filesep,start_folder)); %
end