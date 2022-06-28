% loadBD.m
function [BDTrns, burstEl] = loadBD(folder, fName)
% startFolder = pwd;
% cd(folder)
filename = fullfile(folder, fName);
load(filename);
burstEl = find(~cellfun('isempty', burst_detection_cell));
BDTrns = [];
for k = 1:length(burstEl)
    BDcurElec = burst_detection_cell{burstEl(k)};
    NumBcurElec = size(BDcurElec,1);
    BDTrns = [BDTrns; burstEl(k)*ones(NumBcurElec,1) BDcurElec(:,1:2)];
    BDTrns = BDTrns(1:end-1,:);
end
% cd(startFolder)