%%% filter_comput.m %%%
function [flag] = salpa_comput(expFolder,outFolder,param)
% %%%
% verify if a MAT_ folder is present
folders = dir(expFolder);
folders = {folders.name};
matFolder = regexpi(folders,'.*Mat_files.*','match','once');
% indices of Mat_files names folders
idx = find(~strcmp(matFolder(:),''));
matFolder = matFolder(idx);
matFolderName = char(matFolder);
matFoldNum = size(matFolderName,1);
%
% %%%
% verify if a ANA_ folder is present
anaFolder = regexpi(folders,'.*Ana_files.*','match','once');
% indices of Ana_files names folders
idx = find(~strcmp(anaFolder(:),''));
anaFolder = anaFolder(idx);
anaFolderName = char(anaFolder);
anaFoldNum = size(anaFolderName,1);
% %%%
% scelta dei parametri
salpa_specs.N   = param.N; % 3ms -> 30 samples
salpa_specs.win = param.win; % 50ms -> 500 samples
salpa_specs.d   = param.d;  % 5 (as DAW)
salpa_specs.hw  = param.hw;   % 2ms -> 20 samples
%
% artefactDetParam = struct('minArtDist',20,'sf',param.sf,'minArtAmpl',1);
art_thresh_analog = param.art_thresh_analog;
%
if matFoldNum == 0 || anaFoldNum == 0
    disp('Impossible to perform Artefact Suppression (SALPA): no Mat_files folder or Ana_files folder is present');
    flag = 0;
    return
elseif matFoldNum > 1 || anaFoldNum > 1
    disp('Impossible to perform Artefact Suppression (SALPA): more than one Mat_files or Ana_files folder is present');
    flag = 0;
    return
else
    matFolder = deblank(strcat(expFolder,filesep,matFolderName)); %Mat_files folder folder
    anaFolder = deblank(strcat(expFolder,filesep,anaFolderName)); %Ana_files folder
    % caricamento del canale analogico
    salpa_specs.ana_dir     = anaFolder;
    % cartella risultati
    salpa_specs.salpa_dir   = outFolder;
    % count number of different trials
    trialFolders = dirr(matFolder);
    numTrials = length(trialFolders);
    for j = 1:numTrials
        trialFolder = fullfile(matFolder,trialFolders(j).name);
        %     numberOfSamples = getSamplesNumber(trialFolder);
        [trialFolderPath, trialFolderName] = fileparts(trialFolder);
        
        trialAnaFolder = fullfile(anaFolder,trialFolders(j).name);
        try
            trialOutFolder = fullfile(outFolder,trialFolderName);
            if exist(trialOutFolder,'dir')
                rmdir(trialOutFolder,'s');
            end
            mkdir(trialOutFolder);
        catch
            errordlg(['Error creating ',trialOutFolder],'!!Error!!')
            flag = 0;
            return
        end
        cd(anaFolder)
        cd(trialFolderName)
        [artefacts, ana_channel] = find_artefacts_analogRawData(fullfile(trialAnaFolder,[trialFolders(j).name,'_A2.mat']),art_thresh_analog);
        salpa_specs.artefact = single(artefacts);
        salpa_specs.ana_channel = single(ana_channel);
        numberOfElectrodes = getElectrodesNumber(trialFolder);
        files = dirr(trialFolder);
        for k = 1:numberOfElectrodes
            filename = fullfile(trialFolder,files(k).name);
            %         elecNumber = str2double(filename(end-5:end-4));
            load(filename);
            % salpa filtering
            if(~isempty(salpa_specs.artefact))
                salpa_specs.sig_v    = autComputTh(data,param.sf,1);  % stima deviazione standard del rumore
                [data salpa_specs.blanking] = PROC_salpa3( single(data),...
                    salpa_specs.artefact,...
                    salpa_specs.N,...
                    salpa_specs.win,...
                    salpa_specs.d, ...
                    salpa_specs.hw, ...
                    salpa_specs.sig_v );
                data = double(int16(data));
            end
%             % butterworth IIR filter
%             Wn_norm = param.cutOffFreq/(0.5*param.sf);
%             [b,a]   = butter(2,Wn_norm,deblank(param.filterType));
%             data    = double(int16(filter(b,a,data)));
%             clear b a WN_norm;
            saveFilename = fullfile(trialOutFolder,files(k).name);
            try
                save(saveFilename,'data','salpa_specs')
            catch
                errordlg(['Error saving ',saveFilename],'!!Error!!')
                flag = 0;
                return
            end
        end
    end
end
flag = 1;