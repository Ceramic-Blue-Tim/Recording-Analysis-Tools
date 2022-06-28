function [ expNumList ] = generateExpNums(namesList,fileTypes)
%GENERATEEXPNUM extracts the number of the experiments referring to each of
%the file passed as argument in fileList on the basis of fileTypes.
%FileList contains the entire paths of the files
%number of file
filesNum=size(namesList,2);
%for each file
for i=1:filesNum
    %convert to char and extract the experiment number
    currExpNum=find_expnum(deblank(char(namesList(i))),'_');
    %in case there are 128 channels
    if fileTypes{i}~=128
        %assigns a single output folder
        expNumList(i)={currExpNum};
        %otherwise
    else
        %assigns two output folders
        expNumList(i)={[strcat(currExpNum,'A'); strcat(currExpNum,'B')]};
    end
end