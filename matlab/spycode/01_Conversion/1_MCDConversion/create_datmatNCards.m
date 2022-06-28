function [execMessage,success] = create_datmatNCards(idCh,output,startFolder,...
    fileName,expNames,outFolders,performFiltering,cutOffFrequencies,rawDataConversionFlag,...
    datConversionFlag,matConversionFlag,anaConversionFlag,setOffsetToZeroFlag,filtConversionFlag,nMeas,fs)
%create_datmatNCards.m
%The function converts a single MCD file recorded from the MCS120 (or even
%from the MCS60 channels system) channels system to DAT and/or MAT format.
%The code is generalized in order to manage even data from more than 2
%meas.
%
%INPUT:
%    input variables are passed from mcd_converter.m
%    idCh = array containing indexes of channels to be converted; each
%        row contains the data to be converted for the correspondent
%        MEA
%    datConversionFlag - enables conversion to DAT format
%    matConversionFlag - enables conversion to MAT format
%    anaConversionFlag - enables conversion of the Analog streams (if
%    present)
%    filtConversionFlag - enables conversion of a filtered stream (if
%    present)
%    output (string) - determines either if output data has to be in quantization level or in uVolt
%    startFolder - folder containing the MCD file that must be
%            converted
%    outFolders -  cell array whose rows contain the paths to the folders
%            in which MAT (and DAT) folders (containing in turn
%            the folders of each phase with .mat and .dat folders)
%            will be created
%    expNames  -  cell array whose rows contain the experiment names to be
%                 used for the conversion
%    fileName - name of the file to be converted without extension (containing the full path to the file)
%    nMeas  - number of meas' data the mcd file to be converted
%            contains. This parameter serves for multiple
%            amplifiers setup
%    setOffsetToZeroFlag - flag for setting the offset to zero
%    fs -  sampling frequency of the experiment
%
%    created by Luca Leonardo Bologna (14 June 2007) on the basis of
%    "create_datmat.m" by Mauro Gandolfo (3 Marzo 2006)
%      - the differences lie in the possibility to manage the 120
%      channels of the 120 MCS system
%   modified by V. Pasquale (May 2009) in order to convert also a filtered
%   stream (Filtered Data 1)

%--------------------------------------------------------------------------
%              reading mcd header (for parameters)
%datastrm is the function provided within MCRack to obtain the header of
%the ".mcd" file
try
    warning off 'MCS:unknownUnitSign';
    % loads header file
    h_mcd=datastrm([fileName '.mcd']);
    warning on 'MCS:unknownUnitSign';
catch
    fprintf('Error in opening [%s].\nError was [%s].\n\n',[fileName '.mcd'],lasterr);
    success=0;
    return
end
% ----------------------------------------------------------------------
% retrieving all infos
% ----------------------------------------------------------------------
% fullFilename = getfield(h_mcd,'filename');
% swVersion = getfield(h_mcd,'softwareversion');
% meaType = getfield(h_mcd,'meatype');    % MEA layout ('8x8','2x8x8','no grid',etc.)
uVperAD = getfield(h_mcd,'MicrovoltsPerAD2'); % conversion factor
% usPerTick = getfield(h_mcd,'MicrosecondsPerTick');
zeroADValue = getfield(h_mcd,'ZeroADValue2');
totalChannels  = getfield(h_mcd,'TotalChannels'); % total number of channels of the setup (either 64 or 128)
nChannels = getfield(h_mcd,'NChannels2'); % number or channels recorded
% ChannelNames2 = getfield(h_mcd,'ChannelNames2'); %strings of channel definitions,sorted in hardware aquisition order
HwChannelNames2 = getfield(h_mcd,'HardwareChannelNames2');
HardwareChannelID2 = getfield(h_mcd,'HardwareChannelID2'); %hardware channel ID (=number of channel in hardware aquisition sequence)
% streamCnt = getfield(h_mcd,'StreamCount');
streamNames = getfield(h_mcd,'StreamNames');%names of the streams recorded in the file
endTime    = getfield(h_mcd,'sweepStopTime');%recording end time
endTime = endTime(1);
% recordingStartDate = getfield(h_mcd,'recordingdate');
% recordingStopDate = getfield(h_mcd,'recordingStopDate');
% %%%%%%%%%%%%%
electrode_stream = strmatch('Electrode Raw Data',streamNames); %index of the electrode stream name in streamNames (if any)
analog_stream  = strmatch('Analog Raw Data',streamNames); %index of the analog stream name in streamNames (if any)
filtered_stream = strmatch('Filtered Data',streamNames); %index of the filtered data stream name in streamNames (if any)
if ~isempty(filtered_stream) && length(filtered_stream)>1
    warndlg('Could not be completed because more than one Filtered Data stream was found.','!!Warning!!')
    execMessage = 'Could not be completed because more than one Filtered Data stream was found.';
    success = 0;
    return
end
%--------------------------------------------------------------------------
%            variables
elPerMea=60; %number of active electrodes per mea
channelsPerMea=64;
% %%%
if isempty(electrode_stream) && rawDataConversionFlag == 1
    rawDataConversionFlag=0;
    warning('Caution!! No ''Electrode Raw Data'' stream in this file!')
end
if isempty(analog_stream) && anaConversionFlag == 1
    anaConversionFlag=0;
    warning('Caution!! No ''Analog Raw Data'' stream in this file!')
end
if isempty(filtered_stream) && filtConversionFlag == 1
    filtConversionFlag=0;
    warning('Caution!! No ''Filtered Data'' stream in this file!')
end
% %%%%%%%%%%%%%
if rawDataConversionFlag
    % modificato da Valentina, 2009-03-27
    % elecChannelNames2=ChannelNames2{electrode_stream}; %names of recorded
    % channels
    elecChannelNames2=HwChannelNames2{electrode_stream}; %names of recorded channels
    labelLinearRecorded=regexprep(elecChannelNames2,'[A-B]',''); %names of recorded channels (without A and B in case of multiple mea setup)
    usedIdxZeros=zeros(length(labelLinearRecorded),1); %array used for indexing channels to convert
    elecHardwareChannelID2=HardwareChannelID2{electrode_stream};
    %%%
    % set the correct indexing
    if (totalChannels==128 && length(find(elecHardwareChannelID2>=channelsPerMea+1))~=0 && nMeas==1)
        elecHardwareChannelID2=elecHardwareChannelID2-channelsPerMea;
    end
    %%%
end
% %%%%
if filtConversionFlag
    filteredStreamName = streamNames{filtered_stream};
    filtChannelNames2=HwChannelNames2{filtered_stream}; %names of recorded channels
    labelLinearFiltered=regexprep(filtChannelNames2,'[A-B]',''); %names of recorded channels (without A and B in case of multiple mea setup)
    usedIdxZerosFilt=zeros(length(labelLinearFiltered),1); %array used for indexing channels to convert
    filtHardwareChannelID2=HardwareChannelID2{filtered_stream};
end
%--------------------------------------------------------------------------
%         checking input arguments
if ~exist([fileName '.mcd'],'file')
    error([fileName '.mcd not existent'])
end
% "idCh must" have the same number of rows as "outFolders"
sizeId_ch=size(idCh,1);
sizeEnd_folders=size(outFolders{1},1);
sizeexpNames=size(expNames{1},1);
if ~((sizeId_ch(1)==sizeEnd_folders(1)) && (sizeId_ch(1)==nMeas) && (sizeId_ch(1)==sizeexpNames(1)))
    execMessage = 'The number of "end Names" you passed as arguments is different from the layouts you chose (one layout must be chosen for each MEAs)';
    success=0;
    return
end
%--------------------------------------------------------------------------
%initialization variables
cd(startFolder);
% label_ch gives correspondence between channel label and channel hardware order
label_ch=  [     0 12 13 14 15 16 17 0  ...
                21 22 23 24 25 26 27 28 ...
                31 32 33 34 35 36 37 38 ...
                41 42 43 44 45 46 47 48 ...
                51 52 53 54 55 56 57 58 ...
                61 62 63 64 65 66 67 68 ...
                71 72 73 74 75 76 77 78 ...
                 0 82 83 84 85 86 87 0 ];
%definition of the step used for scanning the mcd file (ATTENTION!!:too big step
%can result in out of memory)
step=5000;
remainder=rem(endTime,step);
%
filterBandType={'no_filter';'high';'low'};
% creates directory with appropriate names (if needed) for all the MEAs
% set cell array to create folders to be used during conversion
folderDat=cell(1,nMeas); 
folderMat=cell(1,nMeas);
folderAna=cell(1,nMeas);
folderFilt=cell(1,nMeas);
subFolderDat=cell(1,nMeas);
subFolderMat=cell(1,nMeas);
subFolderAna=cell(1,nMeas);
subFolderFilt=cell(1,nMeas);
% for each meas contained in the .mcd file
for i=1:nMeas
    %set the channels chosen by the user to be converted
    labelChosen=label_ch(find(idCh(i,:)));
    %---------------- start setting labels to be used during conversion
    % electrode raw data
    if rawDataConversionFlag
        % label referring to the channels recorded
        idxChannelsLinearRecorded=find(1+((i-1)*channelsPerMea)<=elecHardwareChannelID2 & elecHardwareChannelID2<1+((i-1)*channelsPerMea)+elPerMea);
        %
        labelLinearRecordedActual=usedIdxZeros;
        %     labelLinearRecordedActual(idxChannelsLinearRecorded)=str2double(char(labelLinearRecorded(idxChannelsLinearRecorded)));
        labelLinearRecordedActual(idxChannelsLinearRecorded)=str2double(labelLinearRecorded(idxChannelsLinearRecorded));
        % find the the indices of "labelLinear" relative to the channels the
        % user wants to convert (chosen on the basis of the 8x8 grid layout)
        [c, ia, ib] = intersect(labelLinearRecordedActual,labelChosen);
        usedIdxTemp=usedIdxZeros;
        usedIdxTemp(ia)=1;
        id_ActChComplete(i,:)=usedIdxTemp;
        label_ActChComplete{i,:}=labelLinearRecorded(sort(ia));
    end
    % %%%%%%%%%%%%%
    % filtered data
    if filtConversionFlag
        idxChannelsLinearFiltered=find(1+((i-1)*channelsPerMea)<=filtHardwareChannelID2 & filtHardwareChannelID2<1+((i-1)*channelsPerMea)+elPerMea);
        %
        labelLinearFilteredActual=usedIdxZerosFilt;
        %     labelLinearRecordedActual(idxChannelsLinearRecorded)=str2double(char(labelLinearRecorded(idxChannelsLinearRecorded)));
        labelLinearFilteredActual(idxChannelsLinearFiltered)=str2double(labelLinearFiltered(idxChannelsLinearFiltered));
        % find the the indices of "labelLinear" relative to the channels the
        % user wants to convert (chosen on the basis of the 8x8 grid layout)
        [c, ia, ib] = intersect(labelLinearFilteredActual,labelChosen);
        usedIdxTempFilt=usedIdxZerosFilt;
        usedIdxTempFilt(ia)=1;
        id_ActChCompleteFilt(i,:)=usedIdxTempFilt;
        label_ActChCompleteFilt{i,:}=labelLinearFiltered(sort(ia));
    end
    %---------------- end setting labels to be used during conversion
    % read experiment name and creates names for subfolder;
    currExpName=deblank(char(expNames{1}(i,:)));
    %find experiment number
    expNum=find_expnum(currExpName,'_');
    %setting folders
    folderDat(i)={[fullfile(deblank(char(outFolders{1}(i,:))),[expNum '_Dat_files'])]};
    folderMat(i)={[fullfile(deblank(char(outFolders{1}(i,:))),[expNum '_Mat_files'])]};
    folderAna(i)={[fullfile(deblank(char(outFolders{1}(i,:))),[expNum '_Ana_files'])]};
    folderFilt(i)={[fullfile(deblank(char(outFolders{1}(i,:))),[expNum '_Filt_files'])]};
    %setting subfolders
    subFolderDat(i)={[fullfile(deblank(char(outFolders{1}(i,:))),[expNum '_Dat_files'],deblank(char(expNames{1}(i,:))))]};
    subFolderMat(i)={[fullfile(deblank(char(outFolders{1}(i,:))),[expNum '_Mat_files'],deblank(char(expNames{1}(i,:))))]};
    subFolderAna(i)={[fullfile(deblank(char(outFolders{1}(i,:))),[expNum '_Ana_files'],deblank(char(expNames{1}(i,:))))]};
    subFolderFilt(i)={[fullfile(deblank(char(outFolders{1}(i,:))),[expNum '_Filt_files'],deblank(char(expNames{1}(i,:))))]};
    %create the final folder for .dat files
    if rawDataConversionFlag
        if exist(deblank(char(subFolderDat(i))))
            rmdir(deblank(char(subFolderDat(i))),'s');
        end
        mkdir(deblank(char(subFolderDat(i))));
        % if the mat conversion has been requested by the user
        if matConversionFlag
            %create the final folder for .mat files
            if exist(char(subFolderMat(i)))
                rmdir(char(subFolderMat(i)),'s');
            end
            mkdir(char(subFolderMat(i)));
        end
        %write useful information on conversion in a .txt file
        fd=fopen(fullfile(deblank(char(outFolders{1}(i,:))),'conversion Parameters.txt'),'w+');
        %create filterMessage
        filterTypeTemp=deblank(filterBandType{performFiltering{1}(i)});
        if strcmp(filterTypeTemp,'no_filter')
            filterMessage= 'no filter';
        else
            filterMessage= ['Butterworth ' filterTypeTemp 'pass. Cutoff frequency: ' num2str(cutOffFrequencies{1}(i))];
        end
        fwrite(fd,['setOffsetToZeroFlag ' num2str(setOffsetToZeroFlag) sprintf('\n') ...
            'Filtering ' filterMessage sprintf('\n')]);
        fclose(fd);
        clear fd %necessary to avoid a reopening of the same file
    end
    % if the analog conversion has been requested
    if anaConversionFlag
        if exist(char(subFolderAna(i)))
            rmdir(char(subFolderAna(i)),'s');
        end
        mkdir(char(subFolderAna(i)));
    end
    % if the filtered data conversion has been requested
    if filtConversionFlag
        if exist(char(subFolderFilt(i)))
            rmdir(char(subFolderFilt(i)),'s');
        end
        mkdir(char(subFolderFilt(i)));
    end
end
%--------------------------------------------------------------------------
%           starting DAT conversion
%--------------------------------------------------------------------------
%code for scanning mcd step by step. nextdata belongs to MCRack supplied
%function, too. it generates a struct with a field 'data' containing raw
%data
for j=0:step:(endTime-remainder-step)  %CYCLE ON CHUNKS RETRIEVED FROM MCD
    if(rawDataConversionFlag)
        A=nextdata(h_mcd,'startend',[j j+step],'streamname','Electrode Raw Data','originorder','on');
    end
    if(anaConversionFlag)
        Aanalog=nextdata(h_mcd,'startend',[j j+step],'streamname','Analog Raw Data','originorder','on');
    end
    if(filtConversionFlag)
        Afilt=nextdata(h_mcd,'startend',[j j+step],'streamname',filteredStreamName,'originorder','on');
    end
    for i=1:nMeas
        if(rawDataConversionFlag)
            write_electrode_data(A,uVperAD(electrode_stream),output,deblank(char(subFolderDat(i))),deblank(char(expNames{1}(i,:))),id_ActChComplete(i,:),str2num(cell2mat(label_ActChComplete{i,:})),setOffsetToZeroFlag);
        end
        if(filtConversionFlag)
            write_filtered_data(Afilt,uVperAD(filtered_stream),output,deblank(char(subFolderFilt(i))),deblank(char(expNames{1}(i,:))),id_ActChCompleteFilt(i,:),str2num(cell2mat(label_ActChCompleteFilt{i,:})),setOffsetToZeroFlag);
        end
        if(anaConversionFlag)
            write_analog_data(Aanalog,uVperAD(analog_stream),zeroADValue(analog_stream),output,deblank(char(subFolderAna(i))),deblank(char(expNames{1}(i,:))));
        end
    end
    waitbarImproved(j/(endTime-remainder-step), 'converting to .dat files ...');
end
%REPEAT SAME JOB FOR LAST MCD CHUNK
if(rawDataConversionFlag)
    A=nextdata(h_mcd,'startend',[endTime-remainder endTime],'streamname','Electrode Raw Data','originorder','on');
end
if(anaConversionFlag)
    Aanalog=nextdata(h_mcd,'startend',[endTime-remainder endTime],'streamname','Analog Raw Data','originorder','on');
end
if(filtConversionFlag)
    Afilt=nextdata(h_mcd,'startend',[endTime-remainder endTime],'streamname',filteredStreamName,'originorder','on');
end
for i=1:nMeas
    if(rawDataConversionFlag)
        write_electrode_data(A,uVperAD(electrode_stream),output,deblank(char(subFolderDat(i))),deblank(char(expNames{1}(i,:))),id_ActChComplete(i,:),str2num(cell2mat(label_ActChComplete{i,:})),setOffsetToZeroFlag);
    end
    if(anaConversionFlag)
        write_analog_data(Aanalog,uVperAD(analog_stream),zeroADValue(analog_stream),output,deblank(char(subFolderAna(i))),deblank(char(expNames{1}(i,:))));
    end
    if(filtConversionFlag)
        write_filtered_data(Afilt,uVperAD(filtered_stream),output,deblank(char(subFolderFilt(i))),deblank(char(expNames{1}(i,:))),id_ActChCompleteFilt(i,:),str2num(cell2mat(label_ActChCompleteFilt{i,:})),setOffsetToZeroFlag);
    end
end
%--------------------------------------------------------------------------
%           ending DAT conversion
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%            starting MAT conversion
%--------------------------------------------------------------------------
for i=1:nMeas
    if matConversionFlag==1
        handleWaitBarImproved= waitbarImproved(0, ['mea ' num2str(i) ' out of ' num2str(nMeas) ' stored in current .mcd file' sprintf('\n') 'converting to .mat files ...']);
        if(rawDataConversionFlag)
            do_mat_conversion(deblank(char(subFolderDat(i))),deblank(char(subFolderMat(i))),performFiltering{1}(i), cutOffFrequencies{1}(i),fs);
            if datConversionFlag==0       %if DAT conversion was not requested
                rmdir(deblank(char(subFolderDat(i))),'s');   %delete DAT folder with all its content
                if length(dir(deblank(char(folderDat(i)))))<3
                    rmdir(deblank(char(folderDat(i))));
                end
            end        
        end
        if(anaConversionFlag==1)
            do_ana_conversion(deblank(char(subFolderAna(i))),true,nChannels(analog_stream));
        end
        if(filtConversionFlag==1)
            do_filt_conversion(deblank(char(subFolderFilt(i))))
        end
    end
end
close (handleWaitBarImproved);
clear all
%--------------------------------------------------------------------------
%            ending MAT conversion
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%            Auxiliary functions
%--------------------------------------------------------------------------

%==========================================================================
%==========================================================================
function write_electrode_data(A,uVperAD,output,datfolder,filename,idCh,label_ch,setOffsetToZeroFlag)
% This method takes as argument the struct from the nextdata() method (by
% MCS) and adds the raw data to the file. This code is copied directly from the original file.
A=A.data(logical(idCh),:);       % delete rows of non selected electrode for conversion
for k=1:length(label_ch)      % CYCLE ON EACH CHANNEL SELECTED
    cd(datfolder);
    data=A(k,:);
    if strcmp(output,'uV')     % case for uVolt conversion
        data=data*uVperAD;
    end
    if setOffsetToZeroFlag
        data=data-mean(data);
    end
    filename_dat=[filename '_' num2str(label_ch(k)) '.dat'];
    fid=fopen(filename_dat,'ab');
    fwrite(fid,data,'int16');
    fclose(fid);
    clear data
end
%==========================================================================
%==========================================================================
function write_filtered_data(Afilt,uVperAD,output,datfolder,filename,idCh,label_ch,setOffsetToZeroFlag)
% This method takes as argument the struct from the nextdata() method (by
% MCS) and adds the raw data to the file. This code is copied directly from the original file.
% NB: we assume that the channels selected for the electrode raw data
% conversion are the same selected for the filtered data conversion
A=Afilt.data(logical(idCh),:);       % delete rows of non selected electrode for conversion
for k=1:length(label_ch)      % CYCLE ON EACH CHANNEL SELECTED
    cd(datfolder);
    data=A(k,:);
    if strcmp(output,'uV')     % case for uVolt conversion
        data=data*uVperAD;
    end
    if setOffsetToZeroFlag
        data=data-mean(data);
    end
    filename_dat=[filename '_' num2str(label_ch(k)) '.dat'];
    fid=fopen(filename_dat,'ab');
    fwrite(fid,data,'int16');
    fclose(fid);
    clear data
end
%==========================================================================
%==========================================================================
function write_analog_data(A,uVperAD,zeroADValue,output,folderana,filename)
% this function performs the file writing of the analog streams.
%
% All data is stored as a long row, but the number of analog channels is
% stored, in order to re-reshape the data when storing a matrix in the .mat
% store function.
data=reshape(A.data,[],1);
cd(folderana);
if strcmp(output,'uV') % case for uVolt conversion
    data_mV=(data-zeroADValue)*uVperAD/1000; % mV
end
filename_dat=[filename '_A.dat'];
fid=fopen(filename_dat,'ab');
% fwrite(fid,data,'int16');
fwrite(fid,data_mV,'int16');
fclose(fid);
clear data
%==========================================================================
%==========================================================================
function do_mat_conversion(folder_source,folder_target, filterType, cutoffFrequency,samplingFrequency)
% this method opens the .dat files, and resaves them in the MatLab file
% format which is more efficient.
filterBandType={'no_filter';'high';'low'};
cd(folder_source);
files_content=dir;
num_files=length(files_content);
for i=3:num_files
    cd(folder_source);
    filename=files_content(i).name;
    fid=fopen(filename,'r');
    [data]=fread(fid,'int16');
    if (filterType > 1) %apply butterworth filter based on the parameters
        Wn_norm = cutoffFrequency/(0.5*samplingFrequency);
        [b,a]   = butter(2,Wn_norm,deblank(filterBandType{filterType}));
        data    = int16(filter(b,a,data));
        clear b a WN_norm;
    end
    fclose(fid);
    cd(folder_target);
    filename=strrep(filename,'.dat','.mat');
    save(filename,'data');
    waitbarImproved(i/num_files);
end
%==========================================================================
%==========================================================================
function do_filt_conversion(folder_source)
% this method opens the .dat files, and resaves them in the MatLab file
% format which is more efficient.
cd(folder_source);
files_content=dir;
num_files=length(files_content);
for i=3:num_files
    cd(folder_source);
    filename=files_content(i).name;
    fid=fopen(filename,'r');
    [data]=fread(fid,'int16');
%     data = int16(data);
    fclose(fid);
    delete(filename);
    filename=strrep(filename,'.dat','.mat');
    save(filename,'data');
    waitbarImproved(i/num_files);
end
%==========================================================================
%==========================================================================
function do_ana_conversion(folder,del_dat,n_analog_stream)
% this method reopens the .dat file and saves the result into a .mat file
% in the MatLab file format, i.e. more efficient, and more convenient to
% open.
% As the three channels are stored at once, the result must be reshaped.
% Note that this may pose problems if not all three analog channels are
% stored. This should perhaps be checked for in storing the .dat files.
if nargin < 3; n_analog_stream = 3; end;
cd(folder);
files_content=dir;
num_files=length(files_content);
for i=3:num_files
    cd(folder);
    filename=files_content(i).name;
    if(~isequal(filename(end-3:end),'.dat')); continue; end
    fid=fopen(filename,'r');
    data_col=fread(fid,'int16');
    if( mod(size(data_col,1),n_analog_stream)==0 )
        data = reshape(data_col,n_analog_stream,[]);
%         % here can be functionality transforming the analog data into
%         % digital (0,1) data. However signal is not in TTL range but 3/5
%         % volt.
%         data = toTTL(data);
        save(strrep(filename,'.dat','.mat'),'data');
        if(del_dat)
            fclose(fid);
            delete(filename);
        else
            fclose(fid);
        end
        waitbarImproved(i/num_files);
    else
        fclose(fid);
        fprintf('Could not convert analog data in [%s] to matrix.\n\tRemainder=[%d] with [%d] streams.\n',filename,mod(size(data,1),n_analog_stream),n_analog_stream);
    end
end
%==========================================================================
%==========================================================================
% function d = toTTL(d_mV)
% % this method transforms the analog mV signal from the BNC plugs into a
% % digital 0,1 signal. The problem lies in finding the proper threshold.
% % Apparently the signal though connected to only one plug, is visible on
% % all three channels (it is strongest on the actual channel).
% % Non of the channels drops below 3000mV which is not a zero according to
% % TTL definition (in Wikipedia). The 4000mV threshold is more or less
% % arbitrarily drawn from the data.
% %
% % d = d_mV>4000;
% %
% d = d_mV;