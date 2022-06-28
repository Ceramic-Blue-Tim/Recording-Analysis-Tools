% by Michela Chiappalone (11 Dicembre 2006)
function [Cpar, maxv, maxi]= computeCdi0_NOcluster(r_table, nbins, fs)

lutIDEA =  [       12 12; 13 23; 14 13; 15 16; 16 17; 17 27;       ...
            21 21; 22 22; 23 34; 24 24; 25 35; 26 26; 27 28; 28 37;...
            31 32; 32 31; 33 42; 34 14; 35 25; 36 15; 37 46; 38 38;...
            41 44; 42 43; 43 41; 44 11; 45 18; 46 47; 47 48; 48 45;...
            51 54; 52 51; 53 52; 54 81; 55 88; 56 58; 57 56; 58 55;...
            61 61; 62 53; 63 84; 64 74; 65 85; 66 57; 67 68; 68 67;...
            71 62; 72 71; 73 73; 74 64; 75 75; 76 65; 77 77; 78 78;...
                   82 72; 83 82; 84 83; 85 86; 86 76; 87 87];

r_table_idea=r_table(lutIDEA(:,1),1);           % Select the right electrodes
x=length(r_table_idea{1,1});                    % Length of the correlogram [samples]
cc = reshape (cell2mat(r_table_idea), x, [])';  % Reshape the cell array

center=median(1:x);                             % Center of the correlogram
[maxv, maxi]=max(cc,[],2);                      % Peak amplitude [uVolt] and position [samples]

[r, c] = size(maxi);
ccpeak = zeros(r, 1);
for i=1:r % Cycle on all the elctrodes
    if ((maxi(i)-nbins)>0 && (maxi(i)+nbins)<=x)
        ccpeak(i,1) = sum(cc(i, (maxi(i)-nbins):(maxi(i)+nbins)));
    end
end

Cpar= ccpeak;
maxi = (maxi-center)*1000/fs;                   % Peak latency from zero [msec]

% ---- OLD CODE ----- %
% r_table_idea=cell(88,1);
% r_table{11,1}=0*r_table{12,1};
% r_table{18,1}=0*r_table{12,1};
% r_table{81,1}=0*r_table{12,1};
% r_table{88,1}=0*r_table{12,1};
% r_table_idea(lutIDEA(:,1),1)=r_table(lutIDEA(:,2),1);
% r_table_idea=r_table_idea(lutIDEA(:,1),1);
% x=length(r_table_idea{1,1});
% cc = reshape (cell2mat(r_table_idea), x, [])';

