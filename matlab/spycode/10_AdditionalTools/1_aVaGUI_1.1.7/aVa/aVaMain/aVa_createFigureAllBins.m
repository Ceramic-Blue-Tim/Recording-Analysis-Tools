function aVa_createFigureAllBins(xdata, ydata, param, binWidths, path, figName)
% created by Valentina Pasquale (September 2006)
% aVa_createFigureAllBins create and save a figure representing the
% avalanches distribution (size1, size2, or lifetime depending on the value
% of param) for all bin widths.
% Inputs:   xdata - cell array containing all the xdata
%           ydata - cell array containing all the ydata
%           param - integer variable (values: 1, size1; 2, size2; 3,
%                   lifetime)
%           binWidths - array containing all the bin widths
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
        for jj = 1:max(size(xdata))
            loglog(xdata{jj},ydata{jj}, '.-', 'LineWidth', 1)
            hold all
        end
        axis([1 1e+4 1e-6 1])
        % title('Probability distribution of avalanches size - Version 1')
        xlabel('size [#electrodes]')
        ylabel('P(size)')
    case 2      % size2
        handle = figure('Name','Probability distribution of avalanches size - Version 2');
%         set(gcf, 'PaperUnits', 'centimeters');
%         set(gcf, 'PaperPositionMode', 'manual');
%         set(gcf, 'PaperPosition', [0.25 2.5 8 6]);
        set(gca, 'FontSize', 16)
        for jj = 1:max(size(xdata))
            loglog(xdata{jj},ydata{jj}, '.-', 'LineWidth', 1)
            hold all
        end
        axis([1 1e+2 1e-6 1])
        % title('Probability distribution of avalanches size - Version 2')
        xlabel('size [#electrodes]')
        ylabel('P(size)')
    case 3      % lifetime
        handle = figure('Name','Probability distribution of avalanches lifetime');
%         set(gcf, 'PaperUnits', 'centimeters');
%         set(gcf, 'PaperPositionMode', 'manual');
%         set(gcf, 'PaperPosition', [0.25 2.5 8 6]);
        set(gca, 'FontSize', 16)
        for jj = 1:max(size(xdata))
            loglog(xdata{jj},ydata{jj}, '.-', 'LineWidth', 1)
            hold all
        end
        axis([1 1e+3 1e-6 1])
        % title('Probability distribution of avalanches lifetime')
        xlabel('lifetime(#bins)')
        ylabel('P(lifetime)')
end
% create legend
labels = cell(1,1);
for zz = 1:max(size(binWidths))
    labels{zz} = [num2str(binWidths(zz)), ' ms'];
end
legend(labels, 'Location', 'SouthWest')
legend('boxoff')
box off
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