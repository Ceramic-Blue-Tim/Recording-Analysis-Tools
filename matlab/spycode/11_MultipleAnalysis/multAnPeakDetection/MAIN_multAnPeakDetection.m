function [ outputMessage ] = MAIN_multAnPeakDetection(expFolder,commonParameters, peakDetectionParameters)
%MULTANPEAKDETECTION Summary of this function goes here
%   Detailed explanation goes here
% created by Luca Leonardo Bologna 24 February 2007
%common parameters
sampFreq=commonParameters{1,2};
artThresh=commonParameters{1,4};
blankWinForArt=commonParameters{1,6};
mFactor=1000;

outputMessage=['Folder ' expFolder ': '];
% verify if a MAT_ folder is present
folders=dir(expFolder);
folders={folders.name};
start_folder=regexpi(folders,'.*Mat_files.*','match','once');
% indices of Mat_files names folders
idx=find(~strcmp(start_folder(:),''));
start_folder=start_folder(idx);
start_folder=char(start_folder);
foldNum=size(start_folder,1);
% 
if foldNum==0
    outputMessage=[outputMessage 'impossible to perform Peak Detection: no MAT_files folder is present'];
    return
elseif foldNum>1
    outputMessage=[outputMessage 'impossible to perform Peak Detection: more than one MAT_files folder is present'];
    return
else
    start_folder=deblank(strcat(expFolder,filesep,start_folder)); %experiment folder
    if isdir(start_folder)
        cd (start_folder)
        % if PDDT
        if peakDetectionParameters{2,2}
            %%%%%%%%%%% PDDT
            pdWin=peakDetectionParameters{2,4};
            artDist=peakDetectionParameters{2,6};
            nStd=peakDetectionParameters{2,8};
            [exp_num]=find_expnum(lower(start_folder), '_mat_files');
            threshfile = strcat (exp_num,'_', 'thresh_vectorfile.mat');
            subfoldername1= start_folder;
            cd ..
            end_folder=pwd;   % Folder of the experiment
            subfoldername2 = strcat(exp_num, '_PeakDetectionMAT_', num2str(pdWin*1000/sampFreq),'msec');
            warning off MATLAB:MKDIR:DirectoryExists
            mkdir (subfoldername2) % Directory for peak detection MAT files is created
            cd (subfoldername2)
            subfoldername2= pwd;   % Save the path for subfoldername2

            %% --------------> COMPUTATION PHASE 1: Threshold evaluation
            cd(end_folder)
            end_folderdir=dir;
            end_foldernum=length(dir);
            if isempty(strmatch(threshfile, strvcat(end_folderdir(1:end_foldernum).name),'exact'))
                outputMessage=[outputMessage 'impossible to perform Peak Detection: more threshold file is present'];
                return
            else
                load(threshfile); % thresh_vector is now loaded
                if length(thresh_vector)==87 %done for compatibility with previous version
                    thresh_vector(end+1)=0;
                end
                %% --------------> COMPUTATION PHASE 2: From MAT to PKD
                peak_detectionOK (pdWin, sampFreq, artThresh, artDist, thresh_vector, subfoldername1, subfoldername2);
                outputMessage=[outputMessage 'Peak Detection successfully accomplished'];
            end
        else
            %%%%%%%%%%%%%%%%RTSD
            plp= peakDetectionParameters{3,4};
            rp =peakDetectionParameters{3,6};
            art_dist=peakDetectionParameters{3,8};
            nstd=peakDetectionParameters{3,10};
            %% -----------> FINAL FOLDER MANAGEMENT
            [exp_num]=find_expnum(lower(start_folder), '_mat_files');
            threshfile = strcat (exp_num,'_', 'thresh_vectorfile.mat');
            subfoldername1= start_folder;
            cd ..
            end_folder=pwd;   % Folder of the experiment
            subfoldername2 = strcat(exp_num, '_PeakDetectionMAT_PLP', num2str(plp*1000/sampFreq),'ms_RP', num2str(rp*1000/sampFreq),'ms');
            warning off MATLAB:MKDIR:DirectoryExists
            mkdir (subfoldername2) % Directory for peak detection MAT files is created
            cd (subfoldername2)
            subfoldername2= pwd;   % Save the path for subfoldername2
            %% --------------> COMPUTATION PHASE 1: Threshold evaluation
            cd(end_folder)
            end_folderdir=dir;
            end_foldernum=length(dir);
            if isempty(strmatch(threshfile, strvcat(end_folderdir(1:end_foldernum).name),'exact'))
                outputMessage=[outputMessage 'impossible to perform Peak Detection: more threshold file is present'];
                return
            else
                load(threshfile); % thresh_vector is now loaded
                if length(thresh_vector)==87 %done for compatibility with previous version
                    thresh_vector(end+1)=0;
                end
                %% --------------> COMPUTATION PHASE 2: From MAT to PKD
                peak_detection_rtsdOK (plp, rp, sampFreq, artThresh, art_dist, thresh_vector, subfoldername1, subfoldername2);
                outputMessage=[outputMessage 'Peak Detection successfully accomplished'];
            end
        end
    end
end
