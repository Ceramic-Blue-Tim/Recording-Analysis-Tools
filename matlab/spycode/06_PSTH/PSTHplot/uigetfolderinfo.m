function [name_all_dir_cell,list_stimel] = uigetfolderinfo(start_folder)

% OUTPUT VARIABLES
%   NAME_ALL_DIR_CELL = list containing the name of all files inside the start_folder
%   LIST_STIMEL = list of all stimulus sessions inside the start_folder

cd (start_folder)
name_dir=dir;
name_all_dir_cell=struct2cell(name_dir);
name_all_dir_cell=name_all_dir_cell(1,3:length(name_all_dir_cell(1,:)))'; % Only names of the directories - cell array

list_stimel = [];
for i=1:length(name_all_dir_cell)
    namefile = name_all_dir_cell{i};
    idx = findstr('stim',namefile);
    stimel = str2double(namefile(idx+4)); % It is better to start from the end of the string thank from the beginning
    if (isempty(find(list_stimel == stimel)))
        list_stimel = [list_stimel stimel];
    end
end