function convertAllChOneMedFile(inFilename, DESIRED_TRACES, startFolder,performFiltering, cutOffFrequencies)

%convertAllChOneMedFile	Loads data from a medac data file.
%   The script takes as argument the name of the .dat file to be converted
%   (or the name of the correspondent headre file .med), the number of
%   traces to convert (left for compatibility - version 3.1 of the MED64
%   device should have always the same number of traces, i.e. 1), and the
%   folder in which the files to be converted are. "convertAllChOneMedFile"
%   read the .dat file saved during the recording, saves one .dat file for
%   active channel in a Dat subfolder (contained in an upper level Dat
%   folder created in the same directory as startFolder argument) and
%   finally saves one .mat file for active channel in a Mat subfolder
%   (contained in an upper level Dat folder created in the same directory
%   as startFolder argument)
%   Arguments:
%	inFilename= name of either the .med file or .dat file (without extension) to be converted
%   DESIRED_TRACES number of traces one wants to convert (it should be
%   always one): 'all' or 'avg' or 'average' all the traces are loaded
%   and averaged.

%   modified by Luca Leonardo Bologna May 2007

cd (startFolder);
% check input parameters
if( ~exist( 'DESIRED_TRACES', 'var' ) |  isempty( DESIRED_TRACES ) )
    DESIRED_TRACES = 'all';  % trace to load
end
%--- Input parameter must be a char string ---
if( ~ischar(inFilename)), error( 'Input parameter must be a char string' ), end

%--- Test for valid filename extension (if any) and strip it ---
%==========================================================================
%
undscIdcs=strfind(inFilename, '_');
if ~isempty(undscIdcs)
    expNum=inFilename(1:undscIdcs(1)-1);
else
    expNum=inFilename;
end
% check the presence of the needed files
if( ~exist([inFilename '.med']) & ~exist([inFilename '.dat']))
        error( ['Either ' inFilename '.dat or ' inFilename '.med does not exists. Please check the file and try again'] );
end

%--- Create the filenames for the header and data files associated to the input filename ---
inFilenameHead = [inFilename,'.med'];
inFilenameData = [inFilename,'.dat'];
%--- Test if the input file exists ---
if( ~existFile( inFilenameHead ) ), error( ['Unable to find file named: ', inFilenameHead] ), end
if( ~existFile( inFilenameData ) ), error( ['Unable to find file named: ', inFilenameData] ), end

%===== Read medac header file information =====
%============================
%--- Recording Parameters --
%============================

DAQ_CHANNELS_LABEL = 'DAQ Channels/BD';
GAIN_LABEL = 'Gain';
AMPLITUDE_LABEL = 'Amplitude(mV/V)';
SAMPLE_RATE_LABEL = 'Sample Rate(kHz)/CH';
FRAGMENTS_LABEL = 'Fragment(s)';
FRAG_SIZE_LABEL = 'One Fragment Size/CH';
CONVERT_LABEL = 'Convert';
AD_CHANNELS_LABEL='A/D Channels';
ONE_SHOT_SIZE_LABEL = 'One Shot Size/CH';

label_ch=[  11 21 31 41 51 61 71 81 ...
    12 22 32 42 52 62 72 82 ...
    13 23 33 43 53 63 73 83 ...
    14 24 34 44 54 64 74 84 ...
    15 25 35 45 55 65 75 85 ...
    16 26 36 46 56 66 76 86 ...
    17 27 37 47 57 67 77 87 ...
    18 28 38 48 58 68 78 88]';
% open the header file
fh = fopen( inFilenameHead,'r' );  % open header file
%--- Extract number of channels per board, and number of boards ---
chPerCard = readLabeledValue( fh, DAQ_CHANNELS_LABEL );
nDaqCards = length( chPerCard );
%
if( max(chPerCard) ~= min(chPerCard) )
    fclose( fh );
    error( 'DAQ cards have different number of channels. Feature not supported.' )
end
%
chPerCard = chPerCard(1);
nChannels = nDaqCards * chPerCard;

%--- Extract data file parameters ---
% oneShotSize = readLabeledValue( fh, ONE_SHOT_SIZE_LABEL );  % block size in # samples per channel

[gain, found] = readLabeledValue( fh, GAIN_LABEL );  % gain
errorMessage(GAIN_LABEL,found);
[amplitude, found] = readLabeledValue( fh, AMPLITUDE_LABEL );  % amplitude
errorMessage(AMPLITUDE_LABEL,found);
[samplingFreq, found] = readLabeledValue( fh, SAMPLE_RATE_LABEL );  % sampling rate, in kHz
errorMessage(SAMPLE_RATE_LABEL,found);
[oneShotSize, found]=readLabeledValue( fh, ONE_SHOT_SIZE_LABEL );
if ~found
    oneShotSize=5000;
end
[nFragments, found] = readLabeledValue( fh, FRAGMENTS_LABEL );  % number of traces (fragments)
errorMessage(FRAGMENTS_LABEL,found);
[fragmentSize, found] = readLabeledValue( fh, FRAG_SIZE_LABEL );  % size per channel of a fragment
errorMessage(FRAG_SIZE_LABEL,found);
[conversion, found] = readLabeledString( fh, CONVERT_LABEL );  % size per channel of a fragment
[activeChannels, found] = readLabeledString(fh, AD_CHANNELS_LABEL);  % active channels
errorMessage(AD_CHANNELS_LABEL,found);
activeChannels=str2num(activeChannels);
activeChannels(find(activeChannels==0))=[];

%--- Close header file ---
fclose( fh );
%===== Read medac data file contents ====
fd = fopen( inFilenameData );  % open header file
%--- Compute and constrain memory size of loaded data ---
nBlocks = floor( fragmentSize / oneShotSize ); %number of blocks of oneShotSize samples per ch
%==========================================================================
% Multiple trace read loop (one trace is just boring special case of this)
if( strcmpi( DESIRED_TRACES, 'all' ) | strcmpi( DESIRED_TRACES, 'avg' ) | strcmpi( DESIRED_TRACES, 'average' ) )  % in this case all traces are averaged
    DESIRED_TRACES = 1:nFragments;
else
    if( min( DESIRED_TRACES ) < 1 | max( DESIRED_TRACES ) > nFragments )
        fclose( fd );
        error( ['Desired trace: ', num2str( DESIRED_TRACES ), ...
            ', does not exist in the input data file. Choose from the range: 1 to ', num2str( nFragments),'.'] )
    end
end
nTracesRead = length( DESIRED_TRACES );

%==========================================================================
% make appropriate folders
% make .dat folder
folderdat = [expNum,'_Dat_files'];   %directory for DAT files
foldermat = [expNum,'_Mat_files'];   %directory for MAT files
%complete paths for folders
completeFolderDat=fullfile(startFolder, folderdat);
completeFolderMat=fullfile(startFolder, foldermat);
%complete paths for subfolders
completeSubFolderDat=fullfile(startFolder, folderdat,inFilename);
completeSubFolderMat=fullfile(startFolder, foldermat,inFilename);

% make folders
if ~exist(completeFolderDat)
    mkdir(completeFolderDat);
end
%
if ~exist(completeFolderMat)
    mkdir(completeFolderMat);
end
%
if ~exist(completeSubFolderDat)
    mkdir(completeSubFolderDat);
else
    rmdir(completeSubFolderDat,'s');
    mkdir(completeSubFolderDat);
end
%
if ~exist(completeSubFolderMat)
    mkdir(completeSubFolderMat);
else
    rmdir(completeSubFolderMat,'s');
    mkdir(completeSubFolderMat);
end
%
%==========================================================================
oneTraceSize = fragmentSize * 2 * nChannels; %size of one trace in number of bytes (each sample ==> 2 bytes)
scaleFactor = amplitude * gain * 10 / 2048 / 50;
%
cd (completeSubFolderDat);
%
for traceNum = DESIRED_TRACES
    %--- Seek to the beginning of the desired fragment (trace) ---
    fseek( fd, oneTraceSize * (traceNum - 1), 'bof' );
    % read blocks of data and save them in binary format in .dat files
    for block = 1:nBlocks
        waitbarImproved(block/nBlocks, 'Converting to .dat files ... (1st out of 2 operations) ', 'DelayPeriod', 0, ...
            'BarColor', [0 1 0]);
        if ~isequal(conversion,'TRUE')
            switch nDaqCards
                case 1
                    dataBlock = [fread( fd, [chPerCard, oneShotSize], 'int16' )'];
                case 2
                    dataBlock = [fread( fd, [chPerCard, oneShotSize], 'int16' )', ...
                        fread( fd, [chPerCard, oneShotSize], 'int16' )'];
                case 4
                    dataBlock = [fread( fd, [chPerCard, oneShotSize], 'int16' )', ...
                        fread( fd, [chPerCard, oneShotSize], 'int16' )', ...
                        fread( fd, [chPerCard, oneShotSize], 'int16' )', ...
                        fread( fd, [chPerCard, oneShotSize], 'int16' )'];
                otherwise
                    fclose( fd );
                    error( [ num2str( nDaqCards ), ' number of DAQ cards not supported.'])
            end
        else
            dataBlock = [fread( fd, [chPerCard*nDaqCards,oneShotSize], 'int16' )'];
        end
        %
        writeToDat(activeChannels,inFilename,label_ch,dataBlock,nTracesRead,scaleFactor);
    end
    %in case the file has been downsampled we can read all the samples for
    %all the channel given the distribution of the data
    if conversion
        %read the last chunk of data
        dataBlock = [fread( fd, [chPerCard*nDaqCards,oneShotSize], 'int16' )'];
        writeToDat(activeChannels,inFilename,label_ch,dataBlock,nTracesRead,scaleFactor);
    end

    fclose( fd );
    waitbarImproved();
end
createMatFromDatFiles(completeSubFolderMat,completeSubFolderDat, performFiltering{1}, cutOffFrequencies{1});

%==========================================================================
%==========================================================================
function createMatFromDatFiles (completeSubFolderMat,completeSubFolderDat, filterType, cutoffFrequency);
filterBandType={'no_filter';'high';'low '};
filesContent=dir;
filesNum=length(filesContent);
for i=3:filesNum
    waitbarImproved(i/filesNum, 'Converting to .mat files ... (2nd out of 2 operations)', 'DelayPeriod', 0, ...
        'BarColor', [0 1 0]);
    cd(completeSubFolderDat);
    filename=filesContent(i).name;
    fid=fopen(filename,'r');
    [data]=fread(fid,'int16');
    if(filterType > 1) %apply butterworth filte based on the parameters
        Wn_norm = cutoffFrequency/(0.5*samplingFrequency);
        [b,a]   = butter(2,Wn_norm,deblank(filterBandType{filterType}));
        data    = int16(filter(b,a,data));
        clear b a WN_norm;
    end
    fclose(fid);
    cd(completeSubFolderMat);
    dotDatIndcs= strfind(filename,'.dat');
    filename(dotDatIndcs(end):end)='.mat';
    save(filename,'data');
    clear data;
end
waitbarImproved();
%==========================================================================
%==========================================================================
%==========================================================================
function [value, found] = readLabeledValue( f, label )

found=1;
frewind( f )  % start search at the begining of the file
oneLine = fgetl( f );

while( ~strncmp( label, oneLine, length( label ) ) & ~feof( f ) )
    oneLine = fgetl( f );
end
if ~strncmp( label, oneLine, length( label ))
    value=0;
    value = -inf;
    found=0;
else
    [labelTokenized, valueTokenized] = strtok( oneLine, '=' );
    valueString = valueTokenized(2:length( valueTokenized ));
    value = str2num( valueString );
end
%==========================================================================
%==========================================================================
function [valueString, found] = readLabeledString( f, label )

found=1;
frewind( f )  % start search at the begining of the file
oneLine = fgetl( f );
while( ~strncmp( label, oneLine, length( label ) ) & ~feof( f ) )
    oneLine = fgetl( f );
end
if ~strncmp( label, oneLine, length( label ))
    valueString='';
    found=0;
else
    [labelTokenized, valueTokenized] = strtok( oneLine, '=' );
    valueString = valueTokenized(2:length( valueTokenized ));
end
%==========================================================================
%==========================================================================
function [outResult] = existFile( filename )
outResult = exist( filename, 'file' ) == 2;  %  Test if file exists
%==========================================================================
%==========================================================================
function errorMessage(variable,found)
if ~found
    error([variable ' label not found. Execution stopped']);
end

%==========================================================================
%==========================================================================
function writeToDat(activeChannels,inFilename,label_ch,dataBlock,nTracesRead,scaleFactor)
for k=1:length(activeChannels)
    filename_dat= [inFilename '_' num2str(label_ch(activeChannels(k))) '.dat'];
    fid=fopen(filename_dat,'a');
    dataTemp=dataBlock(:,k);
    dataTemp=dataTemp/nTracesRead;
    dataTemp = dataTemp * scaleFactor*1000;  %in units of uV
    dataTemp=dataTemp-mean(dataTemp);
    fwrite(fid,dataTemp,'int16');
    fclose(fid);
    clear dataTemp
end