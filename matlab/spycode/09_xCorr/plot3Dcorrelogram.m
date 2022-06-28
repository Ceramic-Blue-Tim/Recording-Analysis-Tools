% PLOT-CORRELOGRAM 3D figures
% by Michela Chiappalone (6 Maggio 2005, 9 Maggio 2005, 10 Giugno 2005)
% modified by Luca Leonardo Bologna (13 December 2006)
% modified by Luca Leonardo Bologna (11 June 2007)
%   - in order to handle the 64 channels of MED64 Panasonic system

function []=plot3Dcorrelogram (wsample, binsample, fs, r_bigfolder, res_folder)

% INPUT --> wsample [sample]
%           binsample [sample]
%           fs [sample/sec]
%           r_bigfolder = folder containing the computed cross-correlograms
%           res_folder=   folder for results - 3D plot

% -----------> VARIABLE DEFINITION
first=3;
elNum=64;
if ~rem(binsample,2)
    binsample=binsample+1;
end
flooreHalfStep=floor(binsample/2);
ceiledNumBin=ceil(wsample/binsample);
absEdge=ceiledNumBin*binsample;
xSamples=-flooreHalfStep-absEdge:binsample:flooreHalfStep+1+absEdge;
r=zeros(length(xSamples)-1,1); %Correlogram vector
mcmea_electrodes = GlobalsParams.DEFAULT_ELECTRODES_LAYOUT;
xSamplesMsec=xSamples*1000/fs;

% -----------> INPUT FOLDERS
cd(r_bigfolder)
corrfolders=dir;
numcorrfolders=length(dir);

% -----------> COMPUTATION PHASE
for i=first:numcorrfolders   % Cycle over the 'Cross correlation' folders
    currentcorrfolder=corrfolders(i).name;
    cd(currentcorrfolder)
    resdir=strcat ('3D', currentcorrfolder); % Name of the resulting directory
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
        %
        if isempty (r_table)
            cc=r_tablePOT(mcmea_electrodes,1); % For potentiated channels only
        else
            if length(r_table)==87 %added for compatibility with previous versions of SM
                r_table(end+1)=[];
            end
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
            cd (res_folder)
            enddir=dir;
            numenddir=length(enddir);
            if isempty(strmatch(resdir, strvcat(enddir(1:numenddir).name),'exact')) % Check if the corrdir already exists
                mkdir (resdir) % Make a new directory only if corrdir doesn't exist
            end
            cd (resdir) % Go into the just created directory

            % nome= strcat('3D', finalname, '_', el)
            nome= strcat(finalname, '_', el)
            saveas(y, nome, 'jpg');
            saveas(y, nome,'fig');
            %close all
        end

        cd(currentcorrfolder)
    end % of FOR on j

    cd(r_bigfolder)
end % of FOR on i
EndOfProcessing (res_folder, 'Successfully accomplished')

