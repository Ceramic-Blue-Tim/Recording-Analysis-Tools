function savePlotCCorrParam(c0, CI0, cPeak, CIpeak, peakLatency, binsize, CCorrFolders, resultFolder)

% savePlotCCorrParam: plot and save histograms of parameters extracted
% from compCCorrParam

cd(resultFolder) % Save the histograms and the cell array
ind = strfind(resultFolder,filesep);
str = resultFolder(ind(end)+1:end);
filename = strcat(str,'_CCorrAnalysis');
save(filename, 'c0', 'CI0', 'cPeak', 'CIpeak', 'peakLatency');
clear ind str filename

% first = 3;
% for i = first:max(size(CCorrFolders))
%     currentCCorrFolder = CCorrFolders(i).name;
%     ind = strfind(currentCCorrFolder,'_');
%     str = currentCCorrFolder(ind(1)+1:end);
%     
%     % C(0)
%     flag = 1;
%     x = 0:0.05:1; % Maximum possible value is 1
%     filename = strcat(str,'_c0');
%     cellTemp = c0(:,i-2);
%     h1 = plotxcorrAnalysisHist (cellTemp, x, flag);
%     saveas(h1, filename, 'jpg')
%     saveas(h1, filename, 'fig')
%     clear filename x flag cellTemp
%     %close
%     
%     % CI0
%     flag = 2;
%     x = 0:0.05:1; % Maximum possible value is 1
%     filename = strcat(str,'_CI0');
%     cellTemp = CI0(:,i-2);
%     h2 = plotxcorrAnalysisHist (cellTemp, x, flag);    
%     saveas(h2, filename, 'jpg')
%     saveas(h2, filename, 'fig')
%     clear filename x flag
%     %close
%     
%     % Peak Position
%     flag = 3;
%     x = -55:binsize:55;    
%     filename = strcat(str, '_peakLatency');
%     cellTemp = peakLatency(:,i-2);
%     h3 = plotxcorrAnalysisHist (cellTemp, x, flag);   
%     saveas(h3, filename, 'jpg')
%     saveas(h3, filename, 'fig')
%     clear filename x flag cellTemp
%     close
%     
%     % cPeak
%     flag = 4;
%     x = 0:0.05:1; % Maximum possible value is 1
%     filename = strcat(str,'_cPeak');
%     cellTemp = cPeak(:,i-2);
%     h4 = plotxcorrAnalysisHist (cellTemp, x, flag);
%     saveas(h4, filename, 'jpg')
%     saveas(h4, filename, 'fig')
%     clear filename x flag cellTemp
%     close
%     
%     % CIpeak
%     flag = 5;
%     x = 0:0.05:1; % Maximum possible value is 1    
%     filename = strcat(str,'_CIpeak');
%     cellTemp = CIpeak(:,i-2);
%     h5 = plotxcorrAnalysisHist (cellTemp, x, flag);        
%     saveas(h5, filename, 'jpg')
%     saveas(h5, filename, 'fig')
%     clear filename x flag cellTemp
%     close all
% end

