% PLOTMEANCORRELOGRAM.m
% by Michela Chiappalone (9 Maggio 2005, 10 Giugno 2005)
% modified by Luca Leonardo Bologna (11 June 2007)
%   - in order to handle the 64 channels of MED64 Panasonic system

function []=plotmeancorrelogram (wsample, binsample, fs, r_bigfolder, res_folder)
% INPUT --> wsample [sample]
%           binsample [sample]
%           fs [sample/sec]
%           r_bigfolder = folder containing the computed cross-correlograms
%           res_folder= folder for results - mean correlograms

% -----------> VARIABLE DEFINITION
first=3;
elNum=64;
%
winmsec= wsample*1000/fs;    % window [msec]
binmsec= binsample*1000/fs;  % bin [msec]
% % % % % plus= rem(winmsec, binmsec); % Remainder of division
% % % % % x= [-(winmsec+plus):binmsec:(winmsec+plus)]'; % There is always a bin centered in zero
% % % % % mcmea_electrodes = [(12:17)'; (21:28)'; (31:38)'; (41:48)'; (51:58)'; (61:68)'; (71:78)';(82:87)'];

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


% Graphical variables
xmin=(-winmsec);
xmax= winmsec;
ymax=0.1;
ymin=0;

% -----------> INPUT FOLDERS
cd(r_bigfolder)
corrfolders=dir;
numcorrfolders=length(dir);

% -----------> COMPUTATION PHASE
for i=first:numcorrfolders   % Cycle over the 'Cross correlation' folders
    currentcorrfolder=corrfolders(i).name;
    cd(currentcorrfolder)
    nome= strcat ('Mean_', currentcorrfolder); % Name of the resulting file
    currentcorrfolder= pwd;

    corrfiles=dir;
    numcorrfiles=length(dir);
    scrsz = get(0,'ScreenSize');
    h=figure('Position',[1+100 scrsz(1)+100 scrsz(3)-200 scrsz(4)-200]);

    for j=first:numcorrfiles % Cycle over the 'Cross correlation' files
        r_table=[];
        r_tablePOT=[];
        filename=corrfiles(j).name;
        tmp         = split(filename, '_');
        tmp2        = split(tmp(end), '.');
        el          = char(tmp2(1));
        electrode=str2num(el);     % Electrode name in DOUBLE
        load(filename)             % Variable r_table is loaded

        if isempty (r_table)
            cc=r_tablePOT(mcmea_electrodes,1); % For potentiated channels only
        else
            if length(r_table)==87
                r_table(end+1)=[];
            end
            r_table{electrode,1}=zeros(length(r),1); % autocorrelation is excluded
            cc=r_table(mcmea_electrodes,1); % For all the channels
        end

        emptyrows=0;
        for k=1:elNum
            if (sum(cc{k})==0)
                % cc{k}=zeros(length(x),1);
                emptyrows=emptyrows+1;
                cc{k}=[]; % I have to delete those elements which are empty
            end
        end
        warning off MATLAB:divideByZero
        r_mean = mean(reshape (cell2mat(cc), length(r), (elNum-emptyrows))')';
        %%%%%%
        plot_array_modVale(xSamplesMsec(1:end-1), r_mean, electrode, xmin, xmax, ymin, ymax)
        %%%%%%
        clear cc r_table filename
        cd(currentcorrfolder)
    end % of FOR on j
    %%%%%%%%%%
    subplot(8,8,64)
    set(gca,'FontSize',7)
    set(gca,'XTickLabel',{})
    set(gca,'YTickLabel',{})
    xlabel('t')
    ylabel('CC')
    %%%%%%%%%%
    % --------------> SAVING PHASE
    cd (res_folder)
    saveas(h, nome,'jpg');
    saveas(h, nome,'fig');
    %saveas(h, nome,'fig');
    close all

    cd(r_bigfolder)
end % of FOR on i