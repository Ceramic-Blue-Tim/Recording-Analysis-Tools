%%
clc
clear all
close all

x = 0 : 1 : 120e3;
y = ones(1, length(x));

[file_name, file_dir]   = uigetfile();   % Select file
fpath                   = sprintf("%s%s",file_dir,file_name);
%%
tstamp                  = tstamp2array(fpath);
padded_tstamp   = [tstamp ; zeros(length(x)-length(tstamp),1)];
stim_state      = double((padded_tstamp>0));
    
yyaxis right
s = scatter(x,y, 5, 'filled');
hold on
yyaxis left
s = scatter(padded_tstamp, stim_state, 5, 'filled');