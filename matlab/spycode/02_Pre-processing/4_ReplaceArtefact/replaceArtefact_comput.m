function replaceArtefact_comput(actualFolder,replaceArtParam)

folders = dir(actualFolder);
folders = {folders.name};
PDfolder = regexpi(folders,'.*PeakDetectionMAT.*','match','once');
ANAfolder = regexpi(folders,'.*Ana_files.*','match','once');
PDfolder = char(PDfolder(~strcmp(PDfolder(:),'')));
ANAfolder = char(ANAfolder(~strcmp(ANAfolder(:),'')));
PDfoldNum = size(PDfolder,1);
ANAfoldNum = size(ANAfolder,1);

currEl=[];
PW=[];
cd(ANAfolder)
dirContent=dir(pwd);
if (PDfoldNum == 0 || ANAfoldNum == 0) || (PDfoldNum > 1 || ANAfoldNum > 1)
    return
else
    PDfolder2 = strcat(PDfolder,'2');
    mkdir(actualFolder,PDfolder2)
    PDfolder2 = fullfile(actualFolder,PDfolder2);
    PDfolder = fullfile(actualFolder,PDfolder);
    ANAfolder = fullfile(actualFolder,ANAfolder);
    all_phases = dir(PDfolder);
    all_phases = {all_phases.name};
    stimPhasesFolders = regexpi(all_phases,'.*stim.*','match','once');
    stimPhasesFolders = char(stimPhasesFolders(~strcmp(stimPhasesFolders(:),'')));
    
    for p = 1:size(stimPhasesFolders,1)
        mkdir(PDfolder2,stimPhasesFolders(p,:));
        this_phase = strtrim(stimPhasesFolders(p,8:end));
        fprintf('\n%s: ',this_phase);
        prevWorkDir = pwd;
        cd(this_phase)
        AnAfiles=dir;
        
        for currEl=3:length(AnAfiles) %%Choose of the Ana ch
            load(AnAfiles(currEl).name);
            data=detrend(data,'constant');
            PW(currEl-2)=sum(data.^2);
        end
        cd ..
        ANAstim=[ANAfolder '\' this_phase];
        ind_ANA=find(PW==max(PW));
        anafile=AnAfiles(ind_ANA+2).name;
        
        %anafile = [this_phase '_A' num2str(nANA) '.mat'];%-----
        cd([PDfolder,filesep,stimPhasesFolders(p,:)])
        peak_files = dir;      
        stim_artifact = find_artefacts_analogRawData(fullfile(ANAstim,anafile),replaceArtParam.minArtAmpl);
        for pf = 3:length(peak_files);
            fprintf('.');
            clear artifact peak_train;
            prevWorkDir = pwd;
            cd([PDfolder,filesep,stimPhasesFolders(p,:)])
            load(peak_files(pf).name);
            artifact = stim_artifact(:);
            cd(fullfile(PDfolder2,stimPhasesFolders(p,:)))
            save(peak_files(pf).name,'artifact','peak_train')
            cd(prevWorkDir)
        end
        cd(ANAfolder)
    end
end
end
