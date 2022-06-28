function [SpikeAnalysis]=createSpikeAnalysisfolder(start_folder, exp_num)
% by Michela Chiappalone (10 Marzo 2006)

SpikeAnalysis= strcat(exp_num, '_SpikeAnalysis');
cd(start_folder) 
cd ..            % SpikeAnalysis must be in the main EXP dir
enddir= dir;
numenddir= length(dir);
if isempty(strmatch(SpikeAnalysis, strvcat(enddir(1:numenddir).name),'exact'))
    mkdir(SpikeAnalysis) % Make a new directory only if it doesn't exist
end
cd (SpikeAnalysis)
SpikeAnalysis=pwd;
clear spikeanalysis enddir numenddir
