% Script to peak-detect Average Firing Rate
% created by Valentina Pasquale - September 2006

% clear the workspace
clc
clear all

% ------------ FOLDER SEEKING ---------------
% select the folder that contains Average Firing Rate files
start_folder = pwd;
afr_folder = uigetdir(pwd,'Select the folder that contains Average Firing Rate (AFR) files');
if strcmp(num2str(afr_folder),'0')          % halting case
    errordlg('Selection failed: end of session','Error')
    return
end
cd(afr_folder)
cd ..
% select the end folder
end_folder = uigetdir(pwd,'Select the Spike Analysis folder');
if strcmp(num2str(end_folder),'0')          % halting case
    errordlg('Selection failed: end of session','Error')
    return
end

% ------------ PARAMETERS -------------------
binAfr = 25;            % in ms

% ------------ VARIABLES INIZIALITATION --------------
num_exp = find_expnum(end_folder, '_SpikeAnalysis');

% ------------ PROCESSING --------------
% creates the output folder
[AfrPeakDetection] = createresultfolder(end_folder, num_exp, 'AverageFiringRate_PD');
cd(afr_folder)
files = dir;
num_files = length(files);
for k = 3:num_files     % FOR cycle on the single directory files
    filename = files(k).name;              % current file
    ind = strfind(filename,'_');
    if(strcmp(filename(ind(end)+1:end),['bin',num2str(binAfr),'msec.mat']))
        load(filename);
        numElec = size(afr_table,1);
        numObs = size(afr_table,2);
        afr_pd = zeros(numElec,numObs);
        if (~isempty(afr_table))
            s = std(afr_table,0,2);
            for ii = 1:numElec
                temp(ii,:) = afr_table(ii,:) > s(ii);             % matrice di 0 e 1
                dtemp(ii,:) = [0 diff(temp(ii,:),1,2)];           % vale 1 quando sale sopra soglia; -1 quando scende sotto
                edgesUp = find(dtemp(ii,:)==1);                   % fronti di salita
                edgesDown = find(dtemp(ii,:)==-1);                % fronti di discesa
                if(edgesUp(1) > edgesDown(1))           % se ho un fronte di discesa prima di avere un fronte di salita, allora lo elimino
                    edgesDown = edgesDown(2:end);
                end
                if(edgesUp(end) > edgesDown(end))       % se ho un fronte di salita in fondo senza un relativo fronte di discesa lo elimino
                    edgesUp = edgesUp(1:end-1);
                end
                for jj=1:max(size(edgesUp))
                    [peak, timestamp] = max(afr_table(ii,edgesUp(jj):edgesDown(jj)));
                    afr_pd(ii,edgesUp(jj)+timestamp-1) = peak;
                end
            end
            [AfrPD1BinSize] = createresultfolder(AfrPeakDetection, num_exp, ['AFRbin',num2str(binAfr),'msec_PeakDetection']);
            [AfrPD1Trial] = createresultfolder(AfrPD1BinSize, num_exp, filename(ind(3)+1:end-4));
            cd(AfrPD1Trial)
            for ii = 1:size(afr_table,1)
                peak_train = afr_pd(ii,:);
                save([filename(5:end-4),'_',num2str(ii),'.mat'],'peak_train')
            end
        end
    end
    clear afr_table temp dtemp afr s afr_pd
    cd(afr_folder)
end
warndlg('Successfully accomplished!','End Session')
cd(start_folder)
clear


