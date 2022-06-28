% plotMultISI8x8.m
% by Valentina Pasquale, March 2008
% Realize a plot of the ISI histograms, displayed in a 8x8 grid (standard MCS
% layout)
% ARGUMENTS:
% hFig: handle of the figure in which to store the plots
% x: cell array containing x data
% y: cell array containing y data
% ySmoothed: cell array containing the same y-data, but LP filtered (i.e.
%   smoothed)
% numElec: array containing the numbers of the electrodes
% autoSclFlag: a flag for autoscaling
% maxY: empty if autoSclFlag = 1; otherwise it contains the max value for
%   y-scale
% pks: array containing the peaks detected in the ISI histograms (y-data)
% txt: a string ('lin' or 'log') that identifies the x-scale (linear or
%   logarithmic)
% RETURNS:
% success: a flag for successful computation
% function [success] = plotMultISI8x8(hFig,x,y,ySmoothed,numElec,autoSclFlag,maxY,pks,txt)
function [success] = plotMultISI8x8(hFig,x,y,numElec,autoSclFlag,maxY,txt,style)
    % Initialize success flag
    success = 0;

    % Make hFig current figure
    figure(hFig)

    % MEA variables
    m = MEA60_lookuptable();
    
    % Check
    if length(x) ~= length(y)
        errordlg('Cell arrays of XData and YData do not have the same length!', '!!Error!!', 'modal');
        return
    end
% Start processing
for i = 1:length(x)
    % MCS version(could really use some improvements btw)
    % graph_pos = m(m(:,2)==numElec(i),1);        % extracts the right position in the layout given the electrode number
    % subplot(8,8,graph_pos)
    
    subplot(8,8,i)
    if(~isempty(x{i,1}) && ~isempty(y{i,1}))
        if strcmp(txt,'lin')
            plot(x{i,1}, y{i,1}, style);
%             if(~isempty(ySmoothed) && ~isempty(ySmoothed{i,1}))
%                 hold on
%                 plot(x{i,1}, ySmoothed{i,1} , 'r-');
%             end
            xLim = get(gca,'XLim');
            set(gca,'XTick',xLim,'XTickLabel',{num2str(xLim(1)),num2str(xLim(2))});
        else if strcmp(txt,'log')
                semilogx(x{i,1}, y{i,1}, 'Color', style);
                hold all
%                 if(~isempty(ySmoothed) && ~isempty(ySmoothed{i,1}))
%                     hold on
%                     plot(x{i,1}, ySmoothed{i,1} , 'r-');
%                 end
%                 if (~isempty(pks) && ~isempty(pks{i,1}))
%                     temp = pks{i,1};
%                     semilogx(temp(:,1),temp(:,2),'k*');
%                 end
                set(gca,'XLim',[10^0 10^5])
                xTick = get(gca,'XLim');
%                 xTick = [10^0 10^5];
                xTickLog = log10(xTick);
                xTickLabel = {['10^',num2str(xTickLog(1))],['10^',num2str(xTickLog(2))]};
                set(gca,'XTick',xTick,'XTickLabel',xTickLabel);
%                 set(gca,'XTick',xTick,'XTickLabel','');
            end
        end
        box off            
        if ~autoSclFlag
            % Changes y scale
            set(gca,'YLim',[0 maxY])
        end
        yLim = get(gca,'YLim');
        set(gca,'YLim',[0 yLim(2)])
        set(gca,'YTick',[0 yLim(2)],'YTickLabel',{num2str(0),num2str(yLim(2))});
%         set(gca,'YTick',[0 yLim(2)],'YTickLabel','');
        set(gca,'FontSize',6)
    else
        box off
        axis off
    end
end
subplot(8,8,64)
set(gca,'FontSize',6)
% set(gca,'XLim',[10^0 10^5])
% xTick = [10^0 10^5];
% xTickLabel = {'10^0','10^5'};
% set(gca,'XTick',xTick,'XTickLabel',xTickLabel);
% set(gca,'YLim',[0 maxY]);
% set(gca,'YTick',[0 maxY],'YTickLabel',{num2str(0),num2str(maxY)});
set(gca,'XTickLabel',{});
set(gca,'YTickLabel',{})
xlabel('ms')
ylabel('Probability')
success = 1;