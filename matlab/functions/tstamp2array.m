function [tstamp] = tstamp2array(fpath)
% Get parameters from hdr files
    tstamp = readmatrix(fpath, 'NumHeaderLines', 1);
end