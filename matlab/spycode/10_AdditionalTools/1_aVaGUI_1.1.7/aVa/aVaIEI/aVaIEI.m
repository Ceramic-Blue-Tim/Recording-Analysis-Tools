% Inter-Event Interval distribution (IEI)
% January 2007 - Valentina Pasquale

% ------------ FOLDER SEEKING ---------------
% clear the workspace
% clc
clear all
% select the folder that contains Peak Detection files
start_folder = pwd;
pkd_folder = uigetdir(pwd,'Select the folder that contains Peak Detection files');
if strcmp(num2str(pkd_folder),'0')          % halting case
    errordlg('Selection failed: end of session','Error')
    return
end
cd(pkd_folder)
cd ..
% select the end folder (where to save your results)
end_folder = uigetdir(pwd,'Select the experiment folder');
if strcmp(num2str(end_folder),'0')          % halting case
    errordlg('Selection failed: end of session','Error')
    return
end
% ------------ VARIABLES INIZIALITATION --------------
% Select params
[iei_bin, iei_win, ymax, sampling_freq, cancFlag] = aVaIEI_uigetinfo();
if cancFlag == 1 %halting case
    errordlg('Selection failed: end of session','Error')
    return
end
% Extracts number of samples
samplesNum = aVa_getSamplesNumber(pkd_folder,'mat');
% Finds the number of the experiment
num_exp = find_expnum(pkd_folder, '_PeakDetection');
% Number of electrodes
numberOfElectrodes = 64;
% Matrix of the activity of all the electrodes
overallActivity = sparse(samplesNum, numberOfElectrodes);
% creates the output folder
[saveFolder] = createresultfolder(end_folder, num_exp, ['aVaIEIAnalysis_', num2str(iei_bin*1000/sampling_freq), '-', num2str(iei_win*1000/sampling_freq), 'ms']);
% ----------- PROCESSING --------------
cd(pkd_folder)
folders = dir;
num_folders = length(folders);
IEIresults = cell(num_folders-2,1);     % creates a cell array for the results: in every cell there's a struct that collects the IEI parameters
for i = 3:num_folders                   % FOR cycle on the trial directories
    disp(['Trial ', num2str(i-2), '...'])
    cur_dir = folders(i).name;      % contiene nome della cartella relativa alla fase corrente
    cd(cur_dir);                    % mi sposto in quella cartella di lavoro 
    files = dir;
    num_files = length(files);
    disp('loading data...')
    for k = 3:num_files     % FOR cycle on the single directory files
        filename = files(k).name;              % current file
        load(filename);
        overallActivity(:,k-2) = peak_train(1:samplesNum);
        clear peak_train artifact       
    end
    disp('Calculating IEI distribution...')
    spikes = double(overallActivity > 0);                          % 0 & 1
    clear overallActivity
    sumActivity = sum(spikes,2);
    clear spikes
    structIEI = aVaIEI_mainProcessing(iei_bin, iei_win, sampling_freq, sumActivity);
    IEIresults{i-2,1} = structIEI;
    % ----------- CREATING AND SAVING FIGURES -------------
    figName = ['aVaIEIfig_', cur_dir];
    aVaIEI_createSaveFigure(saveFolder, figName, structIEI, ymax);
    cd(pkd_folder)
end
cd(saveFolder)
fileName = ['aVaIEI_', cur_dir(1:end-2)];
save(fileName,'IEIresults')
% ------------- END -----------------
cd(start_folder)
%close all
warndlg('Successfully accomplished!','End Session')
clear