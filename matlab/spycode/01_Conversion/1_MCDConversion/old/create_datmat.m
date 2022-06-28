function [] = create_datmat(id_ch,dat_conv,mat_conv,ana_conv,output,start_folder,end_folder,varargin)

%CREATE_DATMAT.m
%Function for converting MCD files to DAT and/or MAT format
%INPUT:
%
%       input variables are passed from mcd_converter.m and can be either 5
%       or 6 depending on single file or multiple files conversion respectively.
%       id_ch = array containing indexes of channels to be converted
%       dat_conv = enables conversion to DAT format
%       mat_conv = enables conversion to MAT format
%       ana_conv = enables conversion of the Analog streams (if present)
%       output   = char - determines either if output data has to be in quantization level or in uVolt
%       start_folder = folder containing MCD files
%       end_folder = folder in which subfolders with .mat/.dat files will be created
%       varargin{1}  = if exist it retrieves the name for a single MCD file
%
%       by Mauro Gandolfo (3 Marzo 2006)
%       modified by Luca Leonardo Bologna (06 February 2007)
%       modified by Pieter Laurens Baljon (March 2007)
%           - improved function separation by implementing separate methods
%             for sub functions.
%           - included possibility to convert the analog signals into a
%             separate folder.

%--------------------------------------------------------------------------
%               initialization variables

cd(start_folder);
content=dir;                %store dir content before creating any new folder (useful for cwaitbar)
not_mcd_preceding=0;        %initialization variable for cwaitbar
num_mcd=0;                  %number of MCD inside folder
mcd_done=0;                 %number of MCD converted
%label_ch gives correspondence between channel label and channel hardware order 
label_ch=[0  12 13 14 15 16 17 0  21 22 23 24 25 26 27 28 ...
          31 32 33 34 35 36 37 38 41 42 43 44 45 46 47 48 ...
          51 52 53 54 55 56 57 58 61 62 63 64 65 66 67 68 ...
          71 72 73 74 75 76 77 78 0  82 83 84 85 86 87 0 ]';
      
label_ch=label_ch(find(id_ch),:);   %delete channel for which conversion has not been requested
if nargin==8                %case for single file
    namemcd=varargin{1};
    a=regexp(namemcd,'_');
    num_exp=namemcd(1:a(1)-1);                    %store the number of experiment
    clear a
    num_mcd=1;
    multi_files=0;          %multi_files set to false
else                        %case for multiple files
    for j=3:length(content)
        if length(content(j).name)>3 && strcmp(content(j).name(end-3:end),'.mcd')
            if num_mcd==0                          %in case of first mcd file
                a       = regexp(content(j).name,'_');              
                num_exp = content(j).name(1:a(1)-1); %store the number of experiment
                clear a
            end
            num_mcd = num_mcd + 1;      %counting number of mcd files (used for cwaitbar)
        end
    end
    multi_files = 1;          %multi_files set to true
end
folderdat = [num_exp,'_Dat_files'];   %directory for DAT files
foldermat = [num_exp,'_Mat_files'];   %directory for MAT files
folderana = [num_exp,'_Ana_files'];   
%--------------------------------------------------------------------------
%                        controlling directories
%follow code to control the presence of directories and corresponding
%files inside and to store the results(1=exist directory, 0=not exist)
%
%Note that the analog directory is only created if analog channels are
%present. A solution where the directory is created upon the requirement
%of that directory may be bug-sensitive. Especially because the same
%directory is used later for dat2mat conversion. No bugs found so far.
exist_dat = checkFolder(end_folder,folderdat);
exist_mat = checkFolder(end_folder,foldermat);
exist_ana = 0;

%--------------------------------------------------------------------------
%                        starting conversion
%--------------------------------------------------------------------------
folderdat=[end_folder filesep folderdat];
foldermat=[end_folder filesep foldermat];
folderana=[end_folder filesep folderana];

if mat_conv==0
    w = cwaitbar([0 0 0],{'Entire progress - Please wait...','File progress','Channels per file chunk'}); %CWAITBAR
else
    w = cwaitbar([0 0 0],{sprintf('Entire progress - 1 of %d - Please wait...',1+mat_conv+ana_conv),'File progress','Channels per file chunk'});
end
for j=3:length(content)     %CYCLE ON MCD FILES
    cd(start_folder);
    if ~multi_files
        filename=namemcd;
    else
        filename=content(j).name;
    end
    if length(filename)<4                       %jump if itsn't an mcd file
        not_mcd_preceding = not_mcd_preceding + 1;
        continue
    elseif  ~strcmp(filename(end-3:end),'.mcd')
        not_mcd_preceding = not_mcd_preceding + 1;
        continue
    end
    filename=filename(1:end-4);    %cut .mcd extension                
    cd(folderdat);                            
    subfolder=filename;
    if ~exist(subfolder, 'dir'), mkdir(subfolder); end
    
    cd(start_folder);
      
    %datastrm is the function provided within MCRack to obtain the header of
    %the mcd file
    try
        warning off 'MCS:unknownUnitSign';
        h_mcd=datastrm([filename '.mcd']);
        warning on 'MCS:unknownUnitSign';
    catch
        fprintf('Error in opening [%s].\nError was [%s].\n\n',[filename '.mcd'],lasterr);
        continue;
    end
    %retrieving conversion factor, time of recording and streams in file
    uVperAD         = getfield(h_mcd,'MicrovoltsPerAD2');
    streamNames     = getfield(h_mcd,'StreamNames');
    end_time        = getfield(h_mcd,'sweepStopTime');
    n_channels      = getfield(h_mcd,'NChannels2');
    
    electrode_stream = strmatch('Electrode Raw Data',streamNames);
    analog_stream    = strmatch('Analog Raw Data',streamNames);
    
    %definition of the step used for scanning the mcd file (ATTENTION!!:too big step 
    %can result in out of memory)
    step=5000;
    remainder=rem(end_time,step);
    
    % create analog space if needed. Note that folderana is changed at line
    % 82. The method looks for a subfolder named folderana, but as
    % folderana is now a full path, the value of end_folder only has to be a
    % valid directory, and not necessarily the parent directory.
    if( ana_conv && ~isempty(analog_stream) )
        exist_ana = checkFolder(end_folder,folderana);
    end
    
    %code for scanning mcd step by step. nextdata belongs to MCRack supplied
    %function, too. it generates a struct with a field 'data' containing raw
    %data in 64 rows.
    for i=0:step:(end_time-remainder-step)   %CYCLE ON CHUNKS RETRIEVED FROM MCD
        A=nextdata(h_mcd,'startend',[i i+step],'streamname','Electrode Raw Data');
        write_electrode_data(A,uVperAD(electrode_stream),output,fullfile(folderdat,subfolder),filename,id_ch,label_ch);
        if( ana_conv && ~isempty(analog_stream) )
            if ~exist_ana
                fprintf('Analog target directory does not exist?\n');
            else
                A=nextdata(h_mcd,'startend',[i i+step],'streamname','Analog Raw Data','originorder','on');
                write_analog_data(A,folderana,filename);
            end
        end
        cwaitbar([2 (i+step)/end_time])
        cwaitbar([1 ((i+step)/end_time+mcd_done)/num_mcd])
        if ~multi_files, cwaitbar([1 (i+step)/end_time]),end
    end
    
    %REPEAT SAME JOB FOR LAST MCD CHUNK
    A=nextdata(h_mcd,'startend',[end_time-remainder end_time],'streamname','Electrode Raw Data');
    write_electrode_data(A,uVperAD(electrode_stream),output,fullfile(folderdat,subfolder),filename,id_ch,label_ch);
    if( ana_conv && ~isempty(analog_stream) )
        if ~exist_ana
            fprintf('Analog target directory does not exist?\n');
        else
            A=nextdata(h_mcd,'startend',[end_time-remainder end_time],'streamname','Analog Raw Data','originorder','on');
            write_analog_data(A,folderana,filename);
        end
    end

    cwaitbar([2 1])
    if ~multi_files
        cwaitbar([1 1])
        break
    end
    mcd_done=j-2-not_mcd_preceding;
    cwaitbar([1 mcd_done/num_mcd])
    if mcd_done~=num_mcd , cwaitbar([2 0]) , cwaitbar([3 0]) , end
end
close(w)


%--------------------------------------------------------------------------
%                       starting MAT conversion
%--------------------------------------------------------------------------

if mat_conv==1
    w = cwaitbar([0 0],{sprintf('Entire progress - %d of %d - Please wait...',1+mat_conv,1+mat_conv+ana_conv),'MAT file conversion progress'}); %CWAITBAR
    do_mat_conversion(folderdat,foldermat);
    close(w);
    if(ana_conv==1)
        if ~exist_ana
            fprintf('Analog folder does not exist, Possibly no .mcd files with analog stream were encountered.\n');
        else
            w = cwaitbar([0],{sprintf('Analog stream conversion progress - %d of %d - Please wait...',1+mat_conv+ana_conv,1+mat_conv+ana_conv)}); %CWAITBAR
            do_ana_conversion(folderana,true,n_channels(analog_stream));
            close(w);
        end
    end
    if dat_conv==0              %if DAT conversion was not requested
      cd(end_folder);
      rmdir(folderdat,'s');     %delete DAT folder with all its content
    end  
end
clear all

%--------------------------------------------------------------------------
%
%--------------------------------------------------------------------------
%                       Auxiliary functions
%--------------------------------------------------------------------------

function [exist_type] = checkFolder(base_folder, type_folder)%, multi_files, varargin)
% This method checks for the existence of all necessary folders. (it is
% called three times, once for each folder). it returns true/false as 1/0.
cd(base_folder);
exist_type = 0;
if exist(type_folder,'dir')
    exist_type = 1;
    cd(type_folder);
% I don't understand why this code is used. the booleans are not used
% outside this code.
%     if ~multi_files
%         namemcd = varargin{1};
%         control = namemcd(1:end-4);
%         if exist(control,'dir')
%             exist_type = 1;
%         end
%         clear control namemcd;
%     else
%         num_mcd = varargin{1};
%         current = dir;
%         if (length(current)-2)==num_mcd
%             exist_type = 1;
%         end
%         clear current num_mcd;
%     end
else
    mkdir(type_folder);
    if exist(type_folder,'dir')
        exist_type = 1;
        cd(type_folder);
    end
end

function write_electrode_data(A,uVperAD,output,datfolder,filename,id_ch,label_ch)
% This method takes as argument the struct from the nextdata() method (by
% MCS) and adds the raw data to the file. It also performs calibration and
% calls cwaitbar(). This code is copied directly from the original file.
A=A.data(find(id_ch),:);           % delete rows of not selected electrode for conversion
cwaitbar([3 0])
for k=1:length(label_ch)           % CYCLE ON EACH CHANNEL SELECTED
    cd(datfolder);
    data=A(k,:);
    if strcmp(output,'uV')         % case for uVolt conversion
        data=data*uVperAD;
    end
    data=data-mean(data);
    filename_dat=[filename '_' num2str(label_ch(k)) '.dat'];
    fid=fopen(filename_dat,'ab');
    fwrite(fid,data,'int16');
    fclose(fid);
    clear data
    cwaitbar([3 k/length(label_ch)])
end

function write_analog_data(A,folderana,filename)
% this function performs the file writing of the analog streams. No
% conversion to mV's is done, as this is outside the int16 range (don't
% think that didn't take hours to be discovered). Any conversion should in
% fact be performed in concert with transformation into a digital (0,1)
% signal.
%
% All data is stored as a long row, but the number of analog channels is
% stored, in order to re-reshape the data when storing a matrix in the .mat
% store function.
data=reshape(A.data,[],1);
cd(folderana);
% if strcmp(output,'uV')  % case for uVolt conversion
%     data=data.*uVperAD; % not performed as mV is out of int16 range
% end
filename_dat=[filename '_A.dat'];
fid=fopen(filename_dat,'ab');
fwrite(fid,data,'int16');
fclose(fid);
clear data

function do_mat_conversion(folder_source,folder_target)
% this method opens the .dat files, and resaves them in the MatLab file
% format which is more efficient.
cd(folder_source);
content=dir;
num_folder=length(content);
for j=3:num_folder
    cd(folder_source);
    foldername=content(j).name;
    cd(foldername);
    files_content=dir;
    num_files=length(files_content);
    for i=3:num_files
        cd(folder_source);
        cd(foldername);
        filename=files_content(i).name;
        fid=fopen(filename,'r');
        [data]=fread(fid,'int16');
        fclose(fid);
        cd(folder_target);
        if ~exist(foldername,'dir'), mkdir(foldername); end
        cd(foldername);
        filename=strrep(filename,'.dat','.mat');
        save(filename,'data');
        cwaitbar([2 (i-2)/(num_files-2)])
        cwaitbar([1 ((i-2)/(num_files-2)+(j-3))/(num_folder-2)])
        if num_folder==3, cwaitbar([1 (i-2)/(num_files-2)]), end
    end
end

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
        % here can be functionality transforming the analog data into
        % digital (0,1) data. However signal is not in TTL range but 3/5
        % volt.
        data = toTTL(data);
        save(strrep(filename,'.dat','.mat'),'data');
        if(del_dat)
            fclose(fid);
            delete(filename);
        else
            fclose(fid);
        end
    else
        fclose(fid);
        fprintf('Could not convert analog data in [%s] to matrix.\n\tRemainder=[%d] with [%d] streams.\n',filename,mod(size(data,1),n_analog_stream),n_analog_stream);
    end
    cwaitbar([1 (i-2)/(num_files-2)]);
end

function d = toTTL(d_mV)
% this method transforms the analog mV signal from the BNC plugs into a
% digital 0,1 signal. The problem lies in finding the proper threshold.
% Apparently the signal though connected to only one plug, is visible on
% all three channels (it is strongest on the actual channel).
% Non of the channels drops below 3000mV which is not a zero according to
% TTL definition (in Wikipedia). The 4000mV threshold is more or less
% arbitrarily drawn from the data.
%
% d = d_mV>4000;
%
d = d_mV;