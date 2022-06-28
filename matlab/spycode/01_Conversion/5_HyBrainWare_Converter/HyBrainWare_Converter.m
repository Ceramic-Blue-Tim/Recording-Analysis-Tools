% Convert Neuro-robotic data    %%% Alberto Averna MODIFICATO
% by MChiappalone, July 12, 2011

% Original data, as recorded in the neuro-robotic set-up, are stored in the following format
%    1 = ELECTRODE COLUMN [number 1..60]
%    2 = TIME COLUMN      [sample]
%    3 = SPIKE AMPLITUDE  [Volt]
%    4 = THRESHOLD for SD [Volt]

%    Sampling frequency = 10000;
%    gain = 1100; for BC amplifier

% -------- SELECT ORIGINAL FILES

% Select the folder that contains the original data files
clear all

clc
dataFolder = uigetdir(pwd,'Select the Root Folder');
if strcmp(num2str(dataFolder),'0')          % halting case
    errordlg('Selection failed: end of session','Error')
    return
end
cd (dataFolder)
allDataFolders = dir(dataFolder);
cd ..
ExpFolder = pwd;

% ---------- DEFINE VARIABLES
% MCS MEA format
% mcmea_electrodes = [(12:17)'; (21:28)'; (31:38)'; (41:48)'; (51:58)'; (61:68)'; (71:78)';(82:87)'];

% Jacopo's MEA format
mcmea_electrodesj= [    21; 31; 41; 51; 61; 71;     ...
    12; 22; 32; 42; 52; 62; 72; 82; ...
    13; 23; 33; 43; 53; 63; 73; 83; ...
    14; 24; 34; 44; 54; 64; 74; 84; ...
    15; 25; 35; 45; 55; 65; 75; 85; ...
    16; 26; 36; 46; 56; 66; 76; 86; ...
    17; 27; 37; 47; 57; 67; 77; 87; ...
    28; 38; 48; 58; 68; 78; ];

artifact = [];
spikes=[];
fsample = GlobalsParams.DEFAULT_FS;
gain=1100;       % amplifier gain
mfactor=1000000; % factor to convert from V to uV

%[exp_num]=find_expnum(dataFolder, '_OriginalData');
[exp_num]=find_expnum(dataFolder, '\');
% --------- CREATE PEAK DETECTION FOLDER
peakdetmatfolder = strcat(exp_num, '_PeakDetectionMAT');
warning off
mkdir (peakdetmatfolder)
cd(peakdetmatfolder)
peakdetmatfolder = pwd;
count=0;
counts=0;
% ---------- CYCLE OVER THE DATA AND STORE PD FILES IN THE CORRECT FOLDER
for j=3:size(allDataFolders,1)
    counts=0;
    stm=0;
    stim_el=[];
    cd (dataFolder)
    folder = allDataFolders(j).name;
    allDataFiles = dir(folder);
    cd (folder)
    ind=regexp(folder,'_');
    fold=folder(ind+1:end);
    phs=folder(1:ind-1);
    if strcmp(fold,'Spontaneous')~=1
        count=count+1;
    end
    waitmessage=['converting stream ' num2str(j-2) ' of '   num2str((size(allDataFolders,1))-2) ': ' folder];
    if ispc()
        waitmessage = strrep(waitmessage, '\', '\\');
    end
    
    waitmessage = strrep(waitmessage, '_', '\_');
    if ~exist('hWait','var')
        hWait = waitbar((j-2)/((size(allDataFolders,1))-2), waitmessage);
    else
        waitbar((j-2)/((size(allDataFolders,1))-2), hWait, waitmessage);
    end
    
    for f = 3:size(allDataFiles,1)
        
        filename = allDataFiles(f).name; % read name of the current .csv file
      
        %% If Spontaneus phase
        if strcmp(fold, 'Spontaneous')==1
            
            if strfind(filename, 'SpikeData') | strfind(filename, 'SpikesData') % 'SpikesData' in alcuni casi
                counts=counts+1;
                % ------- READ ORIGINAL DATA
                fid = fopen(filename);                  % open the current file
                result = fscanf(fid,'%g %g %g %g',[4 inf]); % read data as ASCII and put them into the array 'result'
                result = result';                       % data has four columns now
                result = sortrows(result,2);            % order on the base of the sampling time
                result(:,3) = result(:,3)/gain*mfactor; % amplitude is in uV
                winEnd = result(end,2);                 % last sample of the acquisition
                fclose(fid);                            % close the file
                
                [pathstr,name,ext] = fileparts(filename);
                a=strfind(name,'_');
                name_fin_sp=name(1:a(end)-1);
             
                %pkdirname_spont = strcat('PeakDetectionMAT', name_fin_sp); %nome cartelle
               
                pkdirname_connmap= strcat(exp_num,'_', name);
                pkdirname_connmap=regexprep(pkdirname_connmap,pkdirname_connmap(length(exp_num)+2:length(exp_num)+3),phs);
                cd ..
                % ---------- CYCLE OVER THE ELECTRODES
                
                for i=1:60
                    peak_train = zeros(winEnd, 1);
                    peakpos = find(result(:,1)==i);
                    finalpeakpos = result(peakpos,2);
                    finalpeakpos(finalpeakpos<0)=1;
                    peak_train (finalpeakpos, 1)= result(peakpos,3);
                    peak_train = sparse(peak_train);
                    
                    % SAVING PHASE
                    if strfind(pkdirname_connmap,'Spontaneous_SpikeData')>0
                        pkdirname_nbasal = ['ptrain_' strrep(pkdirname_connmap, 'Spontaneous_SpikeData', 'nbasal') '_000' num2str(counts)];
                    else
                        pkdirname_nbasal = ['ptrain_' strrep(pkdirname_connmap, 'spontaneous_SpikeData', 'nbasal') '_000' num2str(counts)];
                    end
                    
                    filename  = strcat(pkdirname_nbasal, '_', num2str(mcmea_electrodesj(i)));
                    cd(peakdetmatfolder)
                    pkdir= dir;
                    numpkdir= length(dir);
                    if isempty(strmatch(pkdirname_nbasal, strvcat(pkdir(1:numpkdir).name),'exact'))
                       
                         mkdir (pkdirname_nbasal)% Make a new directory only if it doesn't exist
                         
                    end
                    cd (pkdirname_nbasal)
                    save (filename, 'peak_train', 'artifact','spikes'); %saves "peak_train" and "artifact" variables in the .mat file "name"
                    clear peak_train
                end
            end
            cd (dataFolder)
            cd (folder)
            pkdirname={};
            %% 
           
            %% If Connection map phase
        elseif strcmp(fold,'ConnectionMap')==1
            if strfind(filename, 'SpikeData') | strfind(filename, 'SpikesData') 
                if length(filename)>29
               
                
                % ------- READ ORIGINAL DATA
                fid = fopen(filename);                  % open the current file
                result = fscanf(fid,'%g %g %g %g',[4 inf]); % read data as ASCII and put them into the array 'result'
                result = result';                       % data has four columns now
                result = sortrows(result,2);            % order on the base of the sampling time
                result(:,3) = result(:,3)/gain*mfactor; % amplitude is in uV
                winEnd = result(end,2);                 % last sample of the acquisition
                fclose(fid);                            % close the file
                
                [pathstr,name,ext] = fileparts(filename);
                a=strfind(name,'_');
                name_fin_sp=name(1:a(end)-1);
                
                pkdirname_connmap= strcat('ptrain_',exp_num,'_',phs,'_', name);
               
                if strfind(pkdirname_connmap,'connection_map_SpikeData')>0
                    pkdirname = strrep(pkdirname_connmap, 'connection_map_SpikeData', ['stim' num2str(count)]);
                else
                    pkdirname = strrep(pkdirname_connmap, 'connectionMap_SpikeData', ['stim' num2str(count)]);
                end
                stimel = name(end-1:end);
                stimname=strrep(name, 'SpikeData','StimuliData');
                stimfile = strcat(stimname, '.csv');
                % stimfile = strcat('Connection_map_StimuliData_', stimel, '.csv');
                stimfile = fullfile(dataFolder,folder, stimfile);
                
                if (str2num(stimel)>11)
                    if exist(stimfile, 'file')
                        fid = fopen(stimfile);
                        stimarray = fscanf(fid,'%g %g',[2 inf]);
                        stimarray = stimarray';
                        fclose(fid);
                        artifact=stimarray(:,2);
                    end
                end
                cd ..
                % ---------- CYCLE OVER THE ELECTRODES
                
                for i=1:60
                    peak_train = zeros(winEnd, 1);
                    peakpos = find(result(:,1)==i);
                    finalpeakpos = result(peakpos,2);
                    finalpeakpos(finalpeakpos<0)=1;
                    peak_train (finalpeakpos, 1)= result(peakpos,3);
                    peak_train = sparse(peak_train);
                    
                    filename  = strcat(pkdirname, '_', num2str(mcmea_electrodesj(i))); % be careful!!!
                    cd(peakdetmatfolder)
                    pkdir= dir;
                    numpkdir= length(dir);
                    if isempty(strmatch(pkdirname, strvcat(pkdir(1:numpkdir).name),'exact'))
                        mkdir (pkdirname) % Make a new directory only if it doesn't exist
                    end
                    cd (pkdirname)
                    save (filename, 'peak_train', 'artifact','spikes'); %saves "peak_train" and "artifact" variables in the .mat file "name"
                    clear peak_train
                end
                end
            end
            cd (dataFolder)
            cd (folder)
            pkdirname={};
           
            %% 
            %% if othe phases
        else 
            for k=3:size(allDataFiles,1)
                fname=allDataFiles(k).name;
                if strfind(fname, 'StimuliData') | strfind(fname, 'stimuliData')
                    stm=1;
                end
                
                if strfind(filename, '.mea')
                    [stim_el]=determineStimulatingElectrodes(filename);
                    
                    %[stim_el]=textread(filename,'%s', 'delimiter',';-','headerlines',1);
                    stimel1=stim_el{1};
                    if length(stim_el)>1
                        stimel2=stim_el{2};
                    end
                end
            end
            if stm==1
                
                if strfind(filename, 'SpikeData') | strfind(filename, 'SpikesData')
                    
                    % ------- READ ORIGINAL DATA
                    fid = fopen(filename);                  % open the current file
                    result = fscanf(fid,'%g %g %g %g',[4 inf]); % read data as ASCII and put them into the array 'result'
                    result = result';                       % data has four columns now
                    result = sortrows(result,2);            % order on the base of the sampling time
                    result(:,3) = result(:,3)/gain*mfactor; % amplitude is in uV
                    winEnd = result(end,2);                 % last sample of the acquisition
                    fclose(fid);                            % close the file
                    
                    [pathstr,name,ext] = fileparts(filename);
                    a=strfind(name,'_');
                    name_fin_sp=name(1:a(end)-1);
                    
                    %pkdirname_spont = strcat('PeakDetectionMAT', name_fin_sp); %nome cartelle
                    pkdirname_connmap1= strcat('ptrain_',exp_num,'_',phs ,'_', 'stim', num2str(count),'_',num2str(mcmea_electrodesj(stimel1)));
                    if exist('stimel2','var')
                        pkdirname_connmap2= strcat('ptrain_',exp_num,'_',phs,'_', 'stim', num2str(count),'_',num2str(mcmea_electrodesj(stimel2)));
                        % pkdirname_connmap=regexprep(pkdirname_connmap,pkdirname_connmap(8:9),phs);
                    end
                    cd ..
                    % ---------- CYCLE OVER THE ELECTRODES
                    
                    for i=1:60
                        peak_train = zeros(winEnd, 1);
                        peakpos = find(result(:,1)==i);
                        finalpeakpos = result(peakpos,2);
                        finalpeakpos(finalpeakpos<0)=1;
                        peak_train (finalpeakpos, 1)= result(peakpos,3);
                        peak_train = sparse(peak_train);
                        
                        % SAVING PHASE
                        if exist('stimel2','var')
                            filename1  = strcat(pkdirname_connmap1, '_', num2str(mcmea_electrodesj(i)));
                            filename2  = strcat(pkdirname_connmap2, '_', num2str(mcmea_electrodesj(i)));
                            cd(peakdetmatfolder)
                            pkdir= dir;
                            numpkdir= length(dir);
                            if isempty(strmatch(pkdirname_connmap1, strvcat(pkdir(1:numpkdir).name),'exact')) & isempty(strmatch(pkdirname_connmap2, strvcat(pkdir(1:numpkdir).name),'exact'))
                                mkdir (pkdirname_connmap1)
                                mkdir (pkdirname_connmap2)% Make a new directory only if it doesn't exist
                            end
                            cd (pkdirname_connmap1)
                            save (filename1, 'peak_train', 'artifact','spikes'); %saves "peak_train" and "artifact" variables in the .mat file "name"
                            
                            cd(peakdetmatfolder)
                            cd (pkdirname_connmap2)
                            save (filename2, 'peak_train', 'artifact','spikes'); %saves "peak_train" and "artifact" variables in the .mat file "name"
                            clear peak_train
                        else
                            filename1  = strcat(pkdirname_connmap1, '_', num2str(mcmea_electrodesj(i)));
                            
                            cd(peakdetmatfolder)
                            pkdir= dir;
                            numpkdir= length(dir);
                            if isempty(strmatch(pkdirname_connmap1, strvcat(pkdir(1:numpkdir).name),'exact'))
                                mkdir (pkdirname_connmap1)
                                % Make a new directory only if it doesn't exist
                            end
                            cd (pkdirname_connmap1)
                            save (filename1, 'peak_train', 'artifact','spikes'); %saves "peak_train" and "artifact" variables in the .mat file "name"
                            clear peak_train
                            
                        end
                    end
                end
            end
            %% 
        end
        
        cd (dataFolder)
        cd (folder)
        pkdirname={};
        
        
    end
    
end
delete (hWait)
EndOfProcessing (dataFolder, 'Successfully accomplished');

