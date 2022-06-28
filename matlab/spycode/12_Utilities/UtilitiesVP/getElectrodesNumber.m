% getElectrodesNumber.m
% Takes as input a single trial folder (peak trains folder) and extracts the number of
% files contained into it --> number of recording electrodes
function [n] = getElectrodesNumber(folder)
files = dirr(folder);
n = length(files);