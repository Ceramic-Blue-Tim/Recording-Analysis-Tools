function plot_array (x, y, electrode, xmin, xmax, ymin, ymax)
% Function PLOT_ARRAY
% by Michela Chiappalone 02-02-2004
% modified by Luca leonardo Bologna 10 June 2007
%   - in order to handle

% INPUT--> x =
%          y =
%          electrode =
%          xmin, xmax, ymin,ymax =


% VARIABLE
lookuptable= [  
    11  1; 21  2; 31  3; 41  4; 51  5; 61  6; 71  7; 81  8; ...
    12  9; 22 10; 32 11; 42 12; 52 13; 62 14; 72 15; 82 16; ...
    13 17; 23 18; 33 19; 43 20; 53 21; 63 22; 73 23; 83 24; ...
    14 25; 24 26; 34 27; 44 28; 54 29; 64 30; 74 31; 84 32; ...
    15 33; 25 34; 35 35; 45 36; 55 37; 65 38; 75 39; 85 40; ...
    16 41; 26 42; 36 43; 46 44; 56 45; 66 46; 76 47; 86 48; ...
    17 49; 27 50; 37 51; 47 52; 57 53; 67 54; 77 55; 87 56; ...
    18 57; 28 58; 38 59; 48 60; 58 61; 68 62; 78 63; 88 64];
% mcsmea_electrodes = [(12:17)'; (21:28)'; (31:38)'; (41:48)'; (51:58)'; (61:68)'; (71:78)';(82:87)']; % electrode names
% mcmea_electrodes = [(11:18)'; (21:28)'; (31:38)'; (41:48)'; (51:58)'; (61:68)'; (71:78)';(81:88)']; % electrode names
% chNum=64;

% PROCESSING
graph_pos = lookuptable(find(lookuptable(:,GlobalsParams.DEFAULT_LUT_SEL)==electrode),2);

subplot(8,8,graph_pos)
hold on
plot(x, y)

axis([xmin xmax ymin ymax])
box off
set(gca,'ytick',[]);
set(gca,'xtick',[]);

clear all

return
