function fileType = extractFilesTypesMcd(fileName)
%extractFylesType extract the type of the files, i.e. whether the file
%contains 120 or 60 channel tracks recording

%check the type of the file
h_mcd=datastrm(fileName);
chForCard=64;
totalChannels=getfield(h_mcd,'TotalChannels');
streamNames = getfield(h_mcd,'StreamNames');%names of the streams recorded in the file
electrode_stream = strmatch('Electrode Raw Data',streamNames);
if totalChannels==chForCard || isempty(electrode_stream)
    fileType=chForCard;
else
    %
    recordedChannels=getfield(h_mcd,'ChannelNames2');
    if length(electrode_stream)==1 % I am converting the standard MEA120 system        
        tempA=~isempty(cell2mat(regexp(recordedChannels{electrode_stream},'A')));
        tempB=~isempty(cell2mat(regexp(recordedChannels{electrode_stream},'B')));
        nActiveCards=tempA + tempB;
        fileType  =nActiveCards*chForCard;

    else % I am converting the USB MEA 120 system - Note that I can convert only 2 streams!!!
        tempA=~isempty(cell2mat(regexp(recordedChannels{electrode_stream(1,1)},'A')));
        tempB=~isempty(cell2mat(regexp(recordedChannels{electrode_stream(2,1)},'B')));
        nActiveCards=tempA + tempB;
        fileType  =nActiveCards*chForCard;       
    end
end