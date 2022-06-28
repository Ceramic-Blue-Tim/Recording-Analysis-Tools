function [  ] = splitDifferentPhasePtrainMod(startingFolder, mainRegExp, regExprToFullfill, numSplit,strToBRep,strToRep)
%   splitDifferetPhasePtrain splits the peakTrain of a given experiment on
%   the basis of the number of chunks the user wants to generate
%   The user will be prompted a window by means of which he can choose the
%   starting folder. The script retrieve all the folders fullfilling the
%   mainRegExp given as parameter and split each phase contained in the
%   peak folder into the number of "sub" peaktrain passed through

% mainRegExp: main regular expression used to retrieve the folders
% containing the peak train
% numSplit: number of interval into which to split the files

% e.g. call: splitDifferetPhasePtrain(pwd, 'PeakDetectionMAT_PLP',2,'','');

% Luca Leonardo Bologna, July 2008
% Michela Chiappalone, Jume 2010
%
% v 1.0 20080717
%

[files, bytes, names]=dirr(startingFolder,mainRegExp,'name'); %find the files/folders fullfilling the regular expression in mainRegExp
foldIdxs=cellfun(@isdir,names); %extract only the folders (just in case also some file was retrieved)
if isempty(foldIdxs)
    warndlg(sprintf('No folders fullfilling the given parameters.\nCheck again.\nProgram is exiting'));
    return
end

names=names(foldIdxs); % keep only the names of the folders
names=unique(names);   % delete duplicate names
%
cllRg2fll = {};
regExprToFullfillNospace = regexprep(regExprToFullfill, ' ','');
idxRg2fll = findstr([regExprToFullfillNospace ','],',');
idxRg2fll = [1 idxRg2fll];
for ii = 2:length(idxRg2fll)
    cllRg2fll = [cllRg2fll regExprToFullfillNospace(idxRg2fll(ii-1)+1:idxRg2fll(ii)-1)];
end

for i=1:length(names) %for every folder fullfilling the requirements
    subFoldNames = {};
    display(['doing exp '  char(names{i})]);
    currPeakDetFolder=deblank(char(names{i})); %convert to character the current folder
    idxFileSep=strfind(currPeakDetFolder,filesep); %indices of the separation characters
    currFoldName=currPeakDetFolder(idxFileSep(end)+1:end); %name of the PeakDetection Folder
    containingFold=currPeakDetFolder(1:idxFileSep(end)-1); %name of the folder containing the PeakDetection Folder
    destFoldName=strrep(currFoldName,'PeakDetectionMAT_', 'PeakDetectionMAT_Splitted_');
    %     [files, bytes,
    %     subFoldNames]=dirr(currPeakDetFolder,'.*','name','isdir','0');
    for jj = 1:length(cllRg2fll)
        [files, bytes, currfilenames]=dirr(currPeakDetFolder,deblank(char(cllRg2fll(jj))),'name','isdir','0');
        if isempty(currfilenames)
            display(['No folder fullfilling phase name '  deblank(char(cllRg2fll(jj)))]);

        else
            subFoldNames = [subFoldNames currfilenames];
        end
    end
    subfoldIdxs=cellfun(@isdir,subFoldNames); %extract only the folders (just in case also some file was retrieved)
    subFoldNames=subFoldNames(subfoldIdxs); %name of the subfolders containing the peak_train
    for j=1:length(subFoldNames)
        currSubFoldName=deblank(char(subFoldNames{j}));
        [files, bytes, filenames]=dirr(currSubFoldName,'.*','name');
        idxFileSepSub=strfind(currSubFoldName,filesep); %indices of the separation characters
        currSubFoldNameNoPath=currSubFoldName(idxFileSepSub(end)+1:end); %name of the PeakDetection Folder
        finalFoldNoSuff=repmat({currSubFoldNameNoPath},numSplit,1);
        finFoldRep=char(regexprep(finalFoldNoSuff,strToBRep,strToRep));
        % finalFoldNoSuff=repmat(deblank(char(subFoldNames{j})),numSplit,1);
        sufxsFold=num2str((1:numSplit)'); %suffixes to be added to the names of the subfolders
        sufCell=mat2cell(sufxsFold,ones(size(sufxsFold)),size(sufxsFold,2)); %convert to cell the suffixes
        sufCell=regexprep(sufCell,{' '},{'0'}); %replace  white spaces with zeros
        sufCellStr=char(sufCell);
        finalFold=[finFoldRep sufCellStr];
        %
        for z=1:length(filenames)
            currFile=deblank(char(filenames{z}));
            load(currFile);
            allPT=peak_train;
            artAllSparse=sparse(zeros(length(allPT),1));
            artAllSparse(artifact)=1;
            suffName=currFile(end-6:end); %extract the name of the electrode in order to use the suffix in building the final name
            ptLen=length(allPT);
            if z==1
                chunkInt=ptLen/numSplit;
                if rem(ptLen,numSplit)
                    display('it is impossible to split the data exactly according to the parameters you passed; check your parameters out');
                    return
                end
            end
            tempPt=sparse(reshape(allPT,chunkInt,[]));
            tempArt=sparse(reshape(artAllSparse,chunkInt,[]));
            for w=1:numSplit
                filename=[finalFold(w,:) suffName];
                compFinalFold=fullfile(containingFold,destFoldName,finalFold(w,:));
                compFinalFold = regexprep(compFinalFold, regexprep(startingFolder,filesep,[filesep filesep filesep]),[regexprep(startingFolder,filesep,[filesep filesep filesep]) '_Splitted' '_in_' num2str(numSplit)]);
                if ~isdir(compFinalFold)
                    mkdir(compFinalFold);
                end
                peak_train=tempPt(:,w);
                artifact=find(tempArt(:,w));
                save(fullfile(compFinalFold,filename),'peak_train','artifact');
                clear peak_train allPT artifact artAllSparse
            end
        end
    end
end