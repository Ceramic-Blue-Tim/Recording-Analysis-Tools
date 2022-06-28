% plotNetAverISI.m
% by Valentina Pasquale, April 2008
% It plots the network averaged ISI histogram
% ARGUMENTS:
% binsAver: x-values
% ISIhistAver: y-values
% OUTPUT:
% hFig: handle of the figure
function [hFig] = plotNetAverISI(binsAver,ISIhistAver,txt)
hFig = figure();
if strcmp(txt,'log')
    semilogx(binsAver, ISIhistAver, 'b.-');
else if strcmp(txt,'lin')
        plot(binsAver, ISIhistAver, 'b.-');
    end
end
% box off
% xLim = get(gca,'XLim');
% set(gca,'XTick',xLim,'XTickLabel',{num2str(xLim(1)),num2str(xLim(2))});
% yLim = get(gca,'YLim');
% set(gca,'YTick',yLim,'YTickLabel',{num2str(yLim(1)),num2str(yLim(2))});
grid on
xlabel('ISI [ms]')
ylabel('Probability')