function [ outputMessage ] = MAIN_multAnPlot(expFolder,commonParameters, plotParameters)
%MULTANPLOT Summary of this function goes here
%   Detailed explanation goes here
% created by Luca Leonardo Bologna 24 February 2007
%common parameters
sampFreq=commonParameters{1,2};
starttime=plotParameters{1,4};
endtime=plotParameters{1,6};
startend  = strcat(num2str(starttime/sampFreq), '-', num2str(endtime/sampFreq), 'sec');

outputMessage=['Folder ' expFolder ': '];
% verify if a PeakDetection folder is present
folders=dir(expFolder);
folders={folders.name};
start_folder=regexpi(folders,'.*PeakDetectionMAT.*','match','once');
% indices of PeakDetectionMAT names folders
idx=find(~strcmp(start_folder(:),''));
start_folder=start_folder(idx);
start_folder=char(start_folder);
foldNum=size(start_folder,1);
if foldNum==0
    outputMessage=[outputMessage 'impossible to perform "Raster Plot": no "PeakDetection" folder is present'];
    return
elseif foldNum>1
    outputMessage=[outputMessage 'impossible to perform "Raster Plot": more than one "PeakDetection" folder is present'];
    return
else
    start_folder=deblank(strcat(expFolder,filesep,start_folder)); %PeakDetection folder
    [exp_num]=find_expnum(start_folder, '_PeakDetection');
    endname=strcat('RasterPlotMAT_', startend);
    % --------- FOLDER MANAGEMENT
    cd (start_folder);
    cd ..
    upfolder=pwd;
    [end_folder]=createresultfolder(upfolder, exp_num, endname);
    [dispwarn]=plotraster(start_folder, end_folder, sampFreq, starttime, endtime, startend, 1);
%     [dispwarn] = plotIMTraster(start_folder, end_folder, sampFreq, starttime, endtime, startend);
    if (dispwarn==1)
        outputMessage=[outputMessage 'impossible to perform "Raster plot" because end time longer than data length!'];
    else
        outputMessage=[outputMessage '"Raster plot" successfully accomplished!'];
    end
end