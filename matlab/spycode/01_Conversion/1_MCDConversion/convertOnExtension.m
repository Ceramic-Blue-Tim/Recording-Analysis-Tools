function convertOnExtension(ext, idCh, output, startFolder, fileName, expNames, ...
    outFolders, performFiltering, cutOffFrequencies, rawDataConversionFlag, datConversionFlag,...
    matConversionFlag, anaConversionFlag, setOffsetToZeroFlag, filtConversiongFlag, nMeas)

%CONVERTONEXTENSION Summary of this function goes here
% based on the extension given as an argument, the function calls the
% appropriate function in order to perform the conversion of the ".mcd"
% or ".med" file

% created by Luca Leonardo Bologna 07 June 2007
% modified by Luca Leonardo Bologna 15 March 2011

if strcmp(ext,'mcd')
    %read sampling frequency
    %check the type of the file
    h_mcd=datastrm([fileName '.mcd']);
    fs  = getfield(h_mcd,'MillisamplesPerSecond2')/1000; %sampling frequency
    fs = fs(1);
    create_datmatNCards_Ns(idCh, output, startFolder, fileName, expNames, outFolders, ...
        performFiltering, cutOffFrequencies, rawDataConversionFlag, datConversionFlag, ...
        matConversionFlag, anaConversionFlag, setOffsetToZeroFlag, ...
        filtConversiongFlag, nMeas, fs);
    %     create_datmat(chs,0,1,0,'uV',startEndFolder,startEndFolder,names);
elseif strcmp(ext,'med')
    [path, fileNameWithoutExtension, extension]=fileparts(fileName);
    convertAllChOneMedFile(fileNameWithoutExtension, 'all', startFolder, performFiltering, cutOffFrequencies);
end