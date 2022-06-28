function aVa_createSaveFigure(xdata,ydata,xdataFit,ydataFit,param,binWidth,slope,rmse,path,figName)
% created by Valentina Pasquale (September 2006)
% aVa_createSaveFigure create and save a figure representing the
% avalanches distribution (size1, size2, or lifetime depending on the value
% of param) and the power-law fitting.
% Inputs:   xdata - array containing xdata
%           ydata - array containing ydata
%           xdataFit - array containing xdata for the fitting
%           ydataFit - array containing ydata for the fitting
%           param - integer variable (values: 1, size1; 2, size2; 3,
%                   lifetime)
%           binWidth - integer variable: bin width [ms]
%           slope - the slope of the power-law fitting in log-log
%                   coordinates
%           path - destination folder
%           figName - name of the figure 
start = pwd;
cd(path)
switch param
    case 1      % size1
        handle = figure('Name','Probability distribution of avalanches size - Version 1');
%         set(gcf, 'PaperUnits', 'centimeters');
%         set(gcf, 'PaperPositionMode', 'manual');
%         set(gcf, 'PaperPosition', [0.25 2.5 8 6]);
        set(gca, 'FontSize', 16)
        loglog(xdata, ydata, 'k.-', 'LineWidth', 1)
        hold all
        if (~isempty(ydataFit))
            loglog(xdataFit, ydataFit, 'r', 'LineWidth', 1)
        end
        powerlaw = 1.2*(xdata(2:end)).^(-1.5);
        loglog(xdata(2:end),powerlaw, 'k--', 'LineWidth', 1)
        axis([1 1e+4 1e-6 1])
        % title('Probability distribution of avalanches size - Version 1')
        xlabel('size [#electrodes]')
        ylabel('P(size)')
        if (~isempty(ydataFit))
            legend(['bin width ',num2str(binWidth),' ms'],['fitting: slope ',num2str(slope)], 'slope -1.5', 'Location', 'NorthEast')
        else
            legend(['bin width ',num2str(binWidth),' ms'], 'slope -1.5', 'Location', 'SouthWest')
        end
        legend('boxoff')
        box off
    case 2      % size2
        handle = figure('Name','Probability distribution of avalanches size - Version 2');
%         set(gcf, 'PaperUnits', 'centimeters');
%         set(gcf, 'PaperPositionMode', 'manual');
%         set(gcf, 'PaperPosition', [0.25 2.5 8 6]);
        set(gca, 'FontSize', 16)
        loglog(xdata, ydata, 'k.-', 'LineWidth', 1)
        hold all
        if (~isempty(ydataFit))
            loglog(xdataFit, ydataFit, 'r', 'LineWidth', 1)
        end
        axis([1 1e+2 1e-6 1])
        powerlaw = 1.2*(xdata(2:end)).^(-1.5);
        loglog(xdata(2:end),powerlaw, 'k--', 'LineWidth', 1)
        % title('Probability distribution of avalanches size - Version 2')
        xlabel('size [#electrodes]')
        ylabel('P(size)')
        if (~isempty(ydataFit))
            legend(['bin width ',num2str(binWidth),' ms'],['fitting: slope ',num2str(slope)], 'slope -1.5', 'Location', 'SouthWest')
        else
            legend(['bin width ',num2str(binWidth),' ms'], 'slope -1.5', 'Location', 'SouthWest')
        end
        legend('boxoff')
        box off
    case 3      % lifetime
        handle = figure('Name','Probability distribution of avalanches lifetime');
%         set(gcf, 'PaperUnits', 'centimeters');
%         set(gcf, 'PaperPositionMode', 'manual');
%         set(gcf, 'PaperPosition', [0.25 2.5 8 6]);
        set(gca, 'FontSize', 16)
        loglog(xdata, ydata, 'k.-', 'LineWidth', 1)
        hold all
        if (~isempty(ydataFit))
            loglog(xdataFit, ydataFit, 'r', 'LineWidth', 1)
        end
        axis([1 1e+3 1e-6 1])
        powerlaw = 1.4*(xdata(2:end)).^(-2);
        loglog(xdata(2:end),powerlaw, 'k--', 'LineWidth', 1)
        % title('Probability distribution of avalanches lifetime')
        xlabel('lifetime [#bins]')
        ylabel('P(lifetime)')
        if (~isempty(ydataFit))
            legend(['bin width ',num2str(binWidth),' ms'],['fitting: slope ',num2str(slope)], 'slope -2', 'Location', 'NorthEast')
        else
            legend(['bin width ',num2str(binWidth),' ms'], 'slope -2', 'Location', 'NorthEast')
        end
        legend('boxoff')
        box off
end
saveas(gcf, [figName '.fig'], 'fig')
saveas(gcf, [figName '.jpg'], 'jpg')
% figure(handle)
% set(gcf, 'PaperUnits', 'centimeters');
% set(gcf, 'PaperPositionMode', 'manual');
% set(gcf, 'PaperPosition', [0.25 2.5 8 6]);
% set(gca, 'FontSize', 8)
% print('-r500','-dtiff',figName)
%close all
cd(start)