function [  ] = catDifferentPhasePtrain( mainRegExp, regExprToFullfill, regToFulfillInName )
%CATDIFFERENTPHASEPTRAIN concatenate the peakTrain of a given experiment on
%the basis of the regular expression given by the user
%   The user will be prompted a window by means of which he can choose the
%   starting folder. Given a cell array of regular expression the script
%   will concatenate the peak trains of the trials fullfilling every single regular
%   expression.

% mainRegExp: main regular expression used to retrieve the files containing
% the peak trains to be concatenated
% regExprToFullfill: cell array containing the regular expressions used to
% collect the peak trains belonging to the same trials
% e.g. call: catDifferetPhasePtrain( 'PeakDetectionMAT_PLP', {'03_nb_01','01_nb_01'},{'div45','div48','div46','div49'});

% Luca Leonardo Bologna, June 2008
%
% v 1.0 04/06/08
%

%startingFolder=uigetfolder('Choose the starting folder'); %get the folder from which to start by the user
startingFolder=uigetdir(pwd,'Select the Root Folder');
[files, bytes, names]=dirr(startingFolder,mainRegExp,'name'); %find the files/folders fullfilling the regular expression in mainRegExp
tempIdxFinal=zeros(1,length(names)); %build a temporary array of ones successively used to extract the correct folders
tempIdxFinalOnes=ones(1,length(names)); %build a temporary array of ones successively used to extract the correct folders
for z=1:length(regToFulfillInName) %for every regular expression the folders must fullfill
    %     tempIdx=zeros(1,length(names)); %build a temporary zeros array having the same length of names
    matchings=regexp(names, deblank(char(regToFulfillInName{z}))); %extract the folders' name fullfilling the current regular expression
    tempIdx=~cellfun(@isempty, matchings); %keep only the non-empty names
    tempIdxFinal=tempIdxFinal|tempIdx; %perform the logical operation OR in order to add the already kept names with the ones kept during the current instance of the for loop we are in
end
names=names(tempIdxFinal&tempIdxFinalOnes); %keep the correct names
names=unique(names); %delete duplicate names
% idxsStart=idxsStart(~cellfun(@isempty, names)); %starting indices for initially retrived names

dirIdxs=cellfun(@isdir, names ); %check whether the names refer to directories or not
names=names(dirIdxs); %select only the correct names
names=unique(names); %eliminate duplicates
for i=1:length(names) %for every folder fullfilling the requirements
    currentPeakDetFolder=deblank(char(names{i})); %convert to character the current folder
    for j=1:length(regExprToFullfill) %for every regular expression used to append the data
        currRegexp=regExprToFullfill{j}; % extract the current regular expression
        [files, bytes, subfoldeNames]=dirr(currentPeakDetFolder,currRegexp,'name'); %seek the folder fullfilling the requirements
        dirIdxs=cellfun(@isdir, subfoldeNames ); %seeks the indices of temp in order to see if the corresponding name is a directory
        subfoldeNames=subfoldeNames(dirIdxs); %extract only the names corresponding to directories
        subfoldeNames=sort(subfoldeNames); %sort the extracted names of the folders
        if isempty(subfoldeNames) %in case no subfolders fulfill the current regular expression
            continue
        end
        subfolderNamesFinal=regexprep(subfoldeNames{1}, 'PeakDetectionMAT', 'PeakDetectionMAT_Full_'); %replace the name of the PeakDetectionMAT_ folders with the PeakDetectionMAT
        if isdir(subfolderNamesFinal)
            display(['PeakDetectionMAT_Full_ folder already existent']);
            continue
        end
        fileList={};
        for z=1:length(subfoldeNames) %for every subfolders fulfilling the current regular expression given as condition to be fulfilled
            [files, bytes, fileList{z}]=dirr(subfoldeNames{z},'\.mat', 'name'); %extract only the .mat files from the current list of folders' content
            if z==1
                numCh=size(fileList{1},2); %number of .mat files contained in the current directory
            else if numCh~=size(fileList{z},2) %if the number of channels does not correspond to the previously found
                    display('folders contains different number of files; check it out'); %display an error message
                    return
                end
            end
        end %
        for w=1:size(fileList{1},2) % for every file
            peak_trainTemp=sparse(0,0); % create a temporary sparse array for storing the peak
            artifactTemp=[]; % create a temporary sparse array for storing the artifact
            spikesTemp=[];
            for y=1:length(fileList) % for every file corresponding to the same electrode and contained in different ptrain subfolders
                currFilename=deblank(char(fileList{y}{w})); % extract the name of the current file
                if y==1
                    tmp         = split(filename, '_');
                    tmp2        = split(tmp(end), '.');
                    elNumStart  = char(tmp2(1));
                end
                tmp         = split(filename, '_');
                tmp2        = split(tmp(end), '.');
                elNum       = char(tmp2(1));
                if elNum~=elNumStart % if the electrode number does not match display an error message and exit from the function
                    display(['trying to append peak_train from different electrodes in file ' currFilename ' check it out']);
                    return
                end
                load(fileList{y}{w}); % load the current file
                 
                peak_trainTemp=[peak_trainTemp;peak_train]; % append the current peak train
                artifactTemp=[artifactTemp; artifact(:)+length(peak_train)*(y-1)]; % append the current artifact array
                if exist('spikes')
                spikesTemp=[spikesTemp; spikes];
                end
            end
            if ~isdir(subfolderNamesFinal)  % if the final folder does not exist
                mkdir(subfolderNamesFinal); % create the final folder
            end
            [dirpos, filename]=fileparts(fileList{1}{w}); % extract the different parts of the file name
            peak_train=peak_trainTemp; %save the collected peak train in the final sparse array
            artifact=artifactTemp; %save the collected artifact in the final array
            spikes=spikesTemp;
            save(fullfile(subfolderNamesFinal,filename),'artifact','peak_train','spikes'); %save the file
        end
    end
end