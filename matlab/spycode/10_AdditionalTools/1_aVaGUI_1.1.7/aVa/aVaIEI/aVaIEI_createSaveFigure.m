function aVaIEI_createSaveFigure(path, name, struct, ylim)
% created by Valentina Pasquale (January 2007)
% Content of struct:
%   edges:        histogram edges array
%   histogram:    IEI histogram values
%   mean:         IEI mean
%   median:       IEI median
%   fitting:      power law fitting (cftoolbox object)
%   gof:          goodness of fitting parameters
%   fitValues:    evaluation of fitting
%   tau:          exponent of the power law fitting

current = pwd;
cd(path)                % it should be the folder where to save all the pictures
% linear scale
handle1 = figure;
% set(gcf, 'PaperUnits', 'centimeters');
% set(gcf, 'PaperPositionMode', 'manual');
% set(gcf, 'PaperPosition', [0.25 2.5 8 6]);
set(gca, 'FontSize', 16)
bar(struct.edges, struct.histogram);
axis ([0 max(struct.edges) 0 ylim])
hold on
line(struct.edges,struct.fitValues,'Color',[1 0 0])
title (['Inter-Event Interval - IEI Histogram - mean ', num2str(struct.mean), ' ms']);
xlabel('Inter-Event Interval [ms]');
ylabel('Probability per bin');
legend('data','fitting')
legend('boxoff')
box off
saveas(gcf, [name '.fig'], 'fig')
saveas(gcf, [name '.jpg'], 'jpg')
% figure(handle1)
% set(gcf, 'PaperUnits', 'centimeters');
% set(gcf, 'PaperPositionMode', 'manual');
% set(gcf, 'PaperPosition', [0.25 2.5 8 6]);
% set(gca, 'FontSize', 8)
% print('-r500','-dtiff',name)

% linear scale [0 5ms]
handle2 = figure;
% set(gcf, 'PaperUnits', 'centimeters');
% set(gcf, 'PaperPositionMode', 'manual');
% set(gcf, 'PaperPosition', [0.25 2.5 8 6]);
set(gca, 'FontSize', 16)
bar(struct.edges, struct.histogram);
axis ([0 5 0 ylim])
title (['Inter-Event Interval - IEI Histogram - mean ', num2str(struct.mean), ' ms']);
xlabel('Inter-Event Interval [ms]');
ylabel('Probability per bin');
name2 = [name, '_axis0-5ms'];
box off
saveas(gcf, [name2 '.fig'], 'fig')
saveas(gcf, [name2 '.jpg'], 'jpg')
% figure(handle2)
% set(gcf, 'PaperUnits', 'centimeters');
% set(gcf, 'PaperPositionMode', 'manual');
% set(gcf, 'PaperPosition', [0.25 2.5 8 6]);
% set(gca, 'FontSize', 8)
% print('-r500','-dtiff',name2)

% log-log scale
handle3 = figure;
% set(gcf, 'PaperUnits', 'centimeters');
% set(gcf, 'PaperPositionMode', 'manual');
% set(gcf, 'PaperPosition', [0.25 2.5 8 6]);
set(gca, 'FontSize', 16)
loglog(struct.edges, struct.histogram, 'k.-');
axis ([1e-1 1e+2 1e-6 1])
hold on
loglog(struct.edges,struct.fitValues, 'r')
title (['Inter-Event Interval - IEI Histogram - mean ', num2str(struct.mean), ' ms']);
xlabel('log(IEI) [ms]');
ylabel('log(Probability per bin)');
legend('data',['fitting: slope ', num2str(struct.tau)])
legend('boxoff')
box off
name3 = [name, '_loglog'];
saveas(gcf, [name3 '.fig'], 'fig')
saveas(gcf, [name3 '.jpg'], 'jpg')
% figure(handle3)
% set(gcf, 'PaperUnits', 'centimeters');
% set(gcf, 'PaperPositionMode', 'manual');
% set(gcf, 'PaperPosition', [0.25 2.5 8 6]);
% set(gca, 'FontSize', 8)
% print('-r500', '-dtiff', name3)
%close all
cd(current)