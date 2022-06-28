function finalfig = plotxcorrAnalysisHist(cellarray, x, flag)

% modified by Luca Leonardo Bologna in order to handle the 64 channels od
% the MED64 panasonic system

scrsz = get(0,'ScreenSize');
finalfig = figure('Position',[scrsz(3)/4 scrsz(4)/6 scrsz(3)/2 scrsz(4)/1.5]);

% flag = 1 for c0 
% flag = 2 for CI0
% flag = 3 for peakLatency
% flag = 4 for cPeak
% flag = 5 for CIpeak

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

if (flag ~= 3)
    maxy = 40;
else
    maxy = 10;
end
m = zeros(size(lookuptable,1),1);
for i = 1:size(lookuptable,1)
    t = reshape(cell2mat(cellarray(lookuptable(i,1),:)),size(lookuptable,1),1);
    if (flag ~= 3)
        temp = nonzeros(t);
    else
        temp = t(~isnan(t));
    end
    graph_pos = lookuptable(i,2);
    subplot(8,8,graph_pos)
    set(gca, 'FontSize', 8)
    h = histc(temp, x);
    if (~isempty(temp))
        m(i) = mean(temp);
    else
        m(i) = NaN;
    end
    if (max(h) > maxy)
        maxy = max(h);
    end
    bar(x, h, 'histc')
    axis off
    if (i==size(lookuptable,1))
        axis on
        if (flag==1) % C(0)
            xlabel('Correlation coefficient C(0)', 'Fontsize', 8)            
        elseif (flag==2) % CI0          
            xlabel('Coincidence index CI0', 'Fontsize', 8)
        elseif (flag==3) % Peak latency
            xlabel('Correlation peak latency from 0 [msec]', 'Fontsize', 8)
        elseif (flag==4) % Cpeak          
            xlabel('Correlation coefficient Cpeak', 'Fontsize', 8)
        elseif (flag==5) % CIpeak          
            xlabel('Correlation coefficient CIpeak', 'Fontsize', 8)
        end
        ylabel('Freq', 'Fontsize', 8)
    end
end
for i = 1:size(lookuptable,1)
    subplot(8,8,lookuptable(i,2))
    if (~isnan(m(i)) && m(i) >= min(x) && m(i) <= max(x))
        text(x(1), 1.2*maxy, num2str(m(i)), 'Fontsize', 8)
    end    
    axis([x(1) x(end) 0 maxy])
    axis square
end
