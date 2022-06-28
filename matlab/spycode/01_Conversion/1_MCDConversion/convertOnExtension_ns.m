function convertOnExtension_ns(ext, idCh, output, startFolder, fileName, expNames, ...
    outFolders, performFiltering, cutOffFrequencies, rawDataConversionFlag, datConversionFlag,...
    matConversionFlag, anaConversionFlag, setOffsetToZeroFlag, filtConversiongFlag, nMeas,filesToConvertNum,i,spksflag)

%CONVERTONEXTENSION Summary of this function goes here
% based on the extension given as an argument, the function calls the
% appropriate function in order to perform the conversion of the ".mcd"
% or ".med" file

% created by Luca Leonardo Bologna 07 June 2007
% modified by Luca Leonardo Bologna 15 March 2011

% if the file to be converted is a .mcd file
nummcd=i;
if strcmp(ext,'mcd')
    %read sampling frequency
    %check the type of the file
    %     h_mcd=datastrm([fileName '.mcd']);
    %     fs = 10000;
    %     fs  = getfield(h_mcd,'MillisamplesPerSecond2')/1000; %sampling frequency
    %     fs = fs(1);
    create_datmatNCards_ns(idCh, output, startFolder, fileName, expNames, outFolders, ...
        performFiltering, cutOffFrequencies, rawDataConversionFlag, datConversionFlag, ...
        matConversionFlag, anaConversionFlag, setOffsetToZeroFlag, ...
        filtConversiongFlag, nMeas,filesToConvertNum,nummcd,spksflag);
% if the file to be converted is a .med file
elseif strcmp(ext,'med')
    [path, flNmNoExt] = fileparts(fileName);
    convertAllChOneMedFile(flNmNoExt, 'all', startFolder, performFiltering, cutOffFrequencies);
else
    
% error message is file extension is not recognised
error('error in function convertOnExtension_ns: rurrent file extension is not recognised');
end