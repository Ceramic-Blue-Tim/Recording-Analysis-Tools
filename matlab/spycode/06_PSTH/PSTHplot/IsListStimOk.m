function [listOK] = IsListStimOk(list_stimel,list_stimel_user)
%
% This function compares if LIST_STIMEL contains all the elements of
% LIST_STIM_USER
%
% INPUT VARIABLES
%     LIST_STIMEL = list of all stimulus sessions
%     LIST_STIMEL = list of stimulus sessions selected by the user
%     
% OUTPUT VARIABLES
%     LISTOK = 0 if the user selected a non-existent stimulus session; otherwise, 
%         the function returns LISTOK = 1 if the user selected a correct list of stimulus 

for i=1:length(list_stimel_user)
    if (isempty(find(lower(list_stimel) == lower(list_stimel_user(i)))))
        errordlg(strcat('Stimulation section ',num2str(list_stimel_user(i)), ' does not exist !'));
        listOK = 0;
        return
    end
end
listOK = 1;

