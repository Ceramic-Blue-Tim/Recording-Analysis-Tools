function [ outputMessage ] = multAnCCorrPlot3DCorr( start_folder,fs )
%MULTANCCORRPLOT3DCORR Summary of this function goes here
%   Detailed explanation goes here
% modified by Luca Leonardo Bologna (10 June 2007) in order to handel th 64
% channels of MED64 Panasonic system)
elNum=64;
outputMessage='';
window = [];
binsize = [];
destfolder = [];
cd(start_folder)
cd ..
end_folder=pwd;
% --------------> INPUT VARIABLES
if isempty(strfind(start_folder, 'BurstEvent'))
    strfilename='_CCorr_'; % for spike train cross-correlogram
else
    strfilename= '_BurstEvent_CCorr'; % for burst event cross-correlogram
end
[exp_num]=find_expnum(start_folder, strfilename);
winindex1=strfind(start_folder, '-');
winindex2=strfind(start_folder, 'msec');
win=str2double(start_folder(winindex1(end)+1:winindex2(end)-1));
binindex=strfind(start_folder, '_');
bin=str2double(start_folder(binindex(end)+1:winindex1(end)-1));
window = win/1000*fs;
binsize = bin/1000*fs;
% bin     [msec]
% binsize [number of samples]
% win     [msec]
% window  [number of samples]
% --------------> RESULT FOLDER MANAGEMENT
if isempty(strfind(start_folder, 'BurstEvent'))
    % for spike train cross-correlogram
    [destfolder]= uigetfoldername(exp_num, bin, win, end_folder, ' - 3DPlot');
else
    % for burst event cross-correlogram
    [destfolder]= uigetfoldernameBE(exp_num, bin, win, end_folder, ' - 3DPlot');
end
cd(start_folder)
warning('off','all');
% INPUT --> window [sample]
%           binsize [sample]
%           fs [sample/sec]
%           start_folder = folder containing the computed cross-correlograms
%           destfolder=   folder for results - 3D plot

% -----------> VARIABLE DEFINITION
first=3;
if ~rem(binsize,2)
    binsize=binsize+1;
end
flooreHalfStep=floor(binsize/2);
ceiledNumBin=ceil(window/binsize);
absEdge=ceiledNumBin*binsize;
xSamples=-flooreHalfStep-absEdge:binsize:flooreHalfStep+1+absEdge;
r=zeros(length(xSamples)-1,1); %Correlogram vector
mcmea_electrodes = GlobalsParams.DEFAULT_ELECTRODES_LAYOUT;
xSamplesMsec=xSamples*1000/fs;

% -----------> INPUT FOLDERS
cd(start_folder)
corrfolders=dir;
numcorrfolders=length(dir);

% -----------> COMPUTATION PHASE
for i=first:numcorrfolders   % Cycle over the 'Cross correlation' folders
    currentcorrfolder=corrfolders(i).name;
    cd(currentcorrfolder)
    resdir=strcat ('3DPlot_', currentcorrfolder); % Name of the resulting directory
    finalname=strrep(currentcorrfolder,'Correlogram_', '');
    currentcorrfolder=pwd;

    corrfiles=dir;
    numcorrfiles=length(dir);

    for j=first:numcorrfiles % Cycle over the 'Cross correlation' files
        r_tablePOT=[];
        filename=corrfiles(j).name;
        tmp         = split(filename, '_');
        tmp2        = split(tmp(end), '.');
        el          = char(tmp2(1));
        load(filename)       % Variable r_table is loaded
        if length(r_table)==87
            r_table(end+1)=[];
        end
        %
        if isempty (r_table)
            cc=r_tablePOT(mcmea_electrodes,1); % For potentiated channels only
        else
            cc=r_table(mcmea_electrodes,1); % For all the channels
        end
        for k=1:elNum
            temp=cc{k};
            temp(isnan(temp))=0;
            cc{k}=temp;
            if isempty(cc{k})
                cc{k}=zeros(length(r),1);
            end
            if mcmea_electrodes(k,1)==str2num(el) % If I'm considering the autocorrelation
%             if k==str2num(el)
                maxautocc=max(cc{k});
            end
        end
        ccm = reshape (cell2mat(cc)/maxautocc, length(r), elNum)';
        %
        clear cc r_table r_tablePOT filename

        % -------------> 3D PLOT
        if (sum(sum(ccm))>0)
            y=surfl(xSamplesMsec(1:end-1), (1:elNum), ccm);
            shading interp
            titolo=strcat('CCorrelogram  ', ' EL', el);
            title(titolo);
            axis tight
            xlabel('Time (msec)')
            ylabel('Electrode index')
            zlabel('C(tau)')
            axis([xSamplesMsec(1) xSamplesMsec(end-1) 1 elNum 0 1])

            % --------------> SAVING PHASE
            clear ccm
            cd (destfolder)
            enddir=dir;
            numenddir=length(enddir);
            if isempty(strmatch(resdir, strvcat(enddir(1:numenddir).name),'exact')) % Check if the corrdir already exists
                mkdir (resdir) % Make a new directory only if corrdir doesn't exist
            end
            cd (resdir) % Go into the just created directory

            nome= strcat('CC_3D_', finalname, '_', el);
            saveas(y, nome, 'jpg');
            %saveas(y, nome,'fig');
            %close all
        end

        cd(currentcorrfolder)
    end % of FOR on j

    cd(start_folder)
end % of FOR on i
end