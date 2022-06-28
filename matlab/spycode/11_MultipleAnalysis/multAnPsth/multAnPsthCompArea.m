function [ outputMessage ] = multAnPsthCompArea( start_folder, end_folder)
%MULTANPSTHCOMPAREA Summary of this function goes here
% created by Luca Leonardo Bologna 01 March 2007
% modified by Luca Leonardo Bologna (11 June 2007)
%   - in order to handle the 64 channels of MED64 Panasonic system

outputMessage='';
elNum=64;
[exp_num]=find_expnum(start_folder, '_PSTH');
[sub_end1]=createresultfolder(end_folder, exp_num, 'PSTHarea_MAT');
[sub_end2]=createresultfolder(end_folder, exp_num, 'PSTHarea_TXT');

cd (start_folder) % Now I'm in the folder containing the PSTH files
mcmea_electrodes = GlobalsParams.DEFAULT_ELECTRODES_LAYOUT;
minarea=1; % minimum allowed PSTH area - not changeble at the moment
first=3;

name_dir=dir;               % Present directories - name_dir is a struct
num_dir=length (name_dir);

for i = first:num_dir               % FOR cycle over all the directories
    current_dir = name_dir(i).name; % i-th directory - i-th experimental phase
    foldername=current_dir;
    cd (current_dir);               % enter the i-th directory
    current_dir=pwd;
    
    % ------------> AREA computation
    content=dir;                % present PSTH files
    num_files= length(content); % number of present PSTH files
    psth_area= zeros (elNum,2);         % A vector containing the values of the PSTH area is allocated (elNum x 2)

    for k=3:num_files              % FOR cycle over all the PSTH files
        filename = content(k).name;
        load (filename);       % The vector "psthcnt", saved in the PSTH file, is loaded
        tmp         = split(filename, '_');
        tmp2        = split(tmp(end), '.');
        electrode   = char(tmp2(1));
        ch_index= find(mcmea_electrodes==str2num(electrode));
        if (sum(psthcnt)>= minarea)
            psth_area(ch_index, 2)=sum(psthcnt); % Compute the PSTH integral
        else
            psth_area(ch_index, 2)= 0;
        end
    end
    psth_area(:,1)=mcmea_electrodes;    % First column = electrode names    
    %areaindex=find(area(:,2)>0);  % If we want to save only nonzeros
    %area=area(areaindex,:);
    % Save PSTH area files
    cd (sub_end1) % Save the MAT file
    nome= strcat('aPSTH_', foldername(end-13:end));
    save (nome, 'psth_area')
    cd (sub_end2) % Save the TXT file
    nometxt= strcat('aPSTH_', foldername(end-13:end), '.txt');
    save (nometxt, 'psth_area', '-ASCII')
    cd (start_folder)
end