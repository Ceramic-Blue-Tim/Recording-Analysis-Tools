function [end_folder]=createresultfolder(finalfolder, exp_num, string)
% by Michela Chiappalone (10 Marzo 2006)

resultfolder= strcat(exp_num, '_', string);
cd(finalfolder)
enddir= dir;
numenddir= length(dir);
if isempty(strmatch(resultfolder, strvcat(enddir(1:numenddir).name),'exact'))
    mkdir(resultfolder) % Make a new directory only if it doesn't exist
end
cd(resultfolder)
end_folder=pwd;
cd(finalfolder)

clear resultfolder enddir numenddir
