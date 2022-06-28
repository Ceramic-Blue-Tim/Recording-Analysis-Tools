
function aVaRS_createSaveFigure(xdata,ydata,xdataFit,ydataFit,param,binWidth,slopes,path,figName)
% created by Valentina Pasquale, Settembre (2006)
% create figures for aVa algorithm
start = pwd;
cd(path)
strings = {'halves';'quarters';'double spacing';'triple spacing'};
% close all

switch param
    case 1      % size1
        for ii = 1:length(xdata)
            figure('Name',['Probability distribution of avalanches size - Version 1 - Bin Width ', num2str(binWidth),' ms - Table ', num2str(ii)])
            if(~isempty(ydata{ii}))
                loglog(xdata{ii}, ydata{ii}, 'b.-')
                hold all
                loglog(xdataFit{ii}, ydataFit{ii}, 'k', 'LineWidth', 1)
                xlabel('size(#electrodes)')
                ylabel('P(size)')
                title(['rescaling ', strings{ii}, ' slope ', num2str(slopes{ii})])
                axis([1 1e+4 1e-6 1])
                saveas(gcf, [figName, '_', strings{ii}])
                saveas(gcf, [figName, '_', strings{ii}], 'jpg')
            end
        end
    case 2      % size2
        for ii = 1:length(xdata)
            figure('Name',['Probability distribution of avalanches size - Version 2 - Bin Width ', num2str(binWidth),' ms - Table ', num2str(ii)])  
            if(~isempty(ydata{ii}))
                loglog(xdata{ii}, ydata{ii}, 'b.-')
                hold all
                loglog(xdataFit{ii}, ydataFit{ii}, 'k', 'LineWidth', 1)
                xlabel('size(#electrodes)')
                ylabel('P(size)')
                title(['rescaling ', strings{ii}, ' slope ', num2str(slopes{ii})])
                axis([1 1e+2 1e-6 1])
                saveas(gcf, [figName, '_', strings{ii}])
                saveas(gcf, [figName, '_', strings{ii}], 'jpg')
            end
        end
    case 3      % lifetime
        for ii = 1:length(xdata)
            figure('Name',['Probability distribution of avalanches lifetime - Bin Width ', num2str(binWidth),' ms - Table ', num2str(ii)])
            if(~isempty(ydata{ii}))
                loglog(xdata{ii}, ydata{ii}, 'r.-')
                hold all
                loglog(xdataFit{ii}, ydataFit{ii}, 'k', 'LineWidth', 1)
                xlabel('lifetime(#bins)')
                ylabel('P(lifetime)')
                title(['rescaling ', strings{ii}, ' slope ', num2str(slopes{ii})])
                axis([1 1e+3 1e-6 1])
                saveas(gcf, [figName, '_', strings{ii}])
                saveas(gcf, [figName, '_', strings{ii}], 'jpg')
            end
        end
end
%close all
cd(start)

