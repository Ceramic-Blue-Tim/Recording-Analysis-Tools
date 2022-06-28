samplesInBin=20;%number of samples contained in the bin used to shuffle the recording
inputFolder=uigetfolder('Select input folder (PeakTrain Folder)');
cd (inputFolder)
name_dir=dir;                            % structure containing the content of the directory
num_dir=length (name_dir);               % number of elements contained in the directory (included . and ..)
outFolder=uigetfolder('Select output folder');%output folder
for i = 3:num_dir                    % inizio a ciclare sulle directory
    cd (inputFolder);
    current_dir = name_dir(i).name;      % ith directory containing spike trains
    cd (current_dir);                    % moving to current dir
    current_dir=pwd;
    idxFilesep=find(current_dir==filesep); %find the last directory separator
    idxFilesepToUse=max(idxFilesep(end),1); %last file sep occurence position
    currentOutputFolder=strcat('_PeakDetectionMAT_AllChShuffled_',num2str(samplesInBin),'samples',current_dir(idxFilesepToUse:end));
    content=dir;
    num_files= length(content); % number of files contained in current directory
    outCompleteFolder=(fullfile(outFolder,currentOutputFolder)); %create name for final folder
    mkdir(outCompleteFolder); %create final folder
    for k=3:num_files
        filename = content(k).name; %current filename
        load (filename);    % peak_train and artifact are loaded
        %         if k==3 %in case the first file is loaded
        originalVectorBinIdx=1:samplesInBin:length(peak_train); %starting indices for bin in recording
        allBinIdx=1:length(originalVectorBinIdx); %indices for each bin
        shuffledIdxs=randperm(length(allBinIdx)); %shuffled indices
        shuffledOriginalVector=originalVectorBinIdx(shuffledIdxs); %shuffled version of vector with starting indices
        %         end
        %         originalVectorBinIdxNew=originalVectorBinIdx; %dummy variable
        binOfPeakTrain=floor(find(peak_train)./samplesInBin); %bin in which the spikes occur
        modOfPeakTrain=mod((find(peak_train)),samplesInBin); %distance of the spike from bin start
        startIdx=binOfPeakTrain.*samplesInBin+1; %start indices of bins where spikes occur
        startIdx(find(modOfPeakTrain==0))=startIdx(find(modOfPeakTrain==0))-samplesInBin; %
        modOfPeakTrain(find(modOfPeakTrain==0))=modOfPeakTrain(find(modOfPeakTrain==0))+samplesInBin;
        modmodOfPeakTrainEffStart=modOfPeakTrain-1;
        %         [c,ia,ib]=intersect(startIdx,shuffledOriginalVector); %Worked
        %         only for old peak detection
        %         originalVectorBinIdxNew(ib)=originalVectorBinIdxNew(ib)+modmodOfPeakTrainEffStart';
        %         finalPositions=originalVectorBinIdxNew(ib);
        finalPositions=[];
        for j=1: length(startIdx)
            ib=find(shuffledOriginalVector==startIdx(j));
            if isempty(finalPositions)
                finalPositions(1)=originalVectorBinIdx(ib)+modmodOfPeakTrainEffStart(j);
            else
                finalPositions(end+1)=originalVectorBinIdx(ib)+modmodOfPeakTrainEffStart(j);
            end
        end
        newData=peak_train;
        newData(find(peak_train))=0;
        newData(finalPositions)=peak_train(find(peak_train));
        currentDir=pwd;
        cd (outCompleteFolder);
        peak_train=newData;
        save (filename,'peak_train');
        cd (currentDir);
        clear finalPositions originalVectorBinIdxNew binOfPeakTrain newData peak_train modmodOfPeakTrainEffStart modOfPeakTrain startIdx
    end
end