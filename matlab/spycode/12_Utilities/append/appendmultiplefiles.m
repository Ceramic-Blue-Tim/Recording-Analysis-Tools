% APPENDMULTIPLEFILES.m
% by Michela Chiappalone 12/01/2004
% Changed on 2/12/2004

% This function want to create a single data stream from different
% recording. To do that, it is necessary to load several files and the
% final output will be the complete recording file.

clear

filenames=uilistfiles;
start=pwd;
end_folder = uigetdir(pwd,'Select the folder for storing the result files');

full_peak_train=[];
big_filenames=cell(87,4);
mcmea_electrodes = GlobalsParams.DEFAULT_ELECTRODES_LAYOUT;

for i=1:length(filenames)
    filename=filenames{i}; % name of the considered file
    %fine= length(filename);
    electrode=filename((end-5):(end-4)); % the el number is always before the '.mat' extension
    trial=filename((end-7):(end-7)); % recording session number
    big_filenames{str2num(electrode), str2num(trial)}=filename;
end

clear filenames filename

big_filenames=big_filenames(mcmea_electrodes,:);
cd(end_folder)
end_folder=pwd;

for i=1:60
    peak_train=[];
    for j=1:4        
        if ~isempty(big_filenames{i,j})
            big_name=big_filenames{i,j};
            %fine= length(big_name);
            electrode=big_name((end-5):(end-4)); % the el number is always before the '.mat' extension
            init=strfind(big_name, filesep); % indicated the begining of the considered filename
            name= big_name((init(length(init))+1): (length(big_name)-8));
            fullname=strcat(name, electrode);
                                    
            load (big_filenames{i,j}) % now the variable peak_train is loaded
            full_peak_train=[full_peak_train; peak_train];
            clear peak_train
        end
    end    
    % peak_train=full_peak_train;
    if ~isempty(full_peak_train)
        peak_train= round(full_peak_train/10);
        save(fullname, 'peak_train');
        clear peak_train
    end    

    full_peak_train=[];
end

% -------------------------- END OF PROCESSING -----------------------------------
cd(start)
clear
display ('End Of Session')
