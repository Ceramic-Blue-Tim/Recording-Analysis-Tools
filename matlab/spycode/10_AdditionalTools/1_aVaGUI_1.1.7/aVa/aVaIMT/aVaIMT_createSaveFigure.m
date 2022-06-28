
function aVaIMT_createSaveFigure(xdata,ydata,xdataFit,ydataFit,param,binWidth,slopes,path,figName)
% created by Valentina Pasquale, Settembre (2006)
% create figures for aVa algorithm
start = pwd;
cd(path)

letters = ['A';'B';'C';'D';'E'];
% close all

switch param
    case 1      % size1
        figure('Name',['Probability distribution of avalanches size - Version 1 - Bin Width ', num2str(binWidth),' ms'])
        for jj = 1:max(size(xdata))
            subplot(2,3,jj)
            loglog(xdata{jj}, ydata{jj}, 'b.-')
            hold all
            loglog(xdataFit{jj}, ydataFit{jj}, 'k', 'LineWidth', 1)
            xlabel('size(#electrodes)')
            ylabel('P(size)')
            title(['cluster ', letters(jj), ' slope ', num2str(slopes{jj})])
            axis([1 1e+4 1e-6 1])
        end
    case 2      % size2
        figure('Name',['Probability distribution of avalanches size - Version 2 - Bin Width ', num2str(binWidth),' ms'])
        for jj = 1:max(size(xdata))
            subplot(2,3,jj)
            loglog(xdata{jj}, ydata{jj}, 'b.-')
            hold all
            loglog(xdataFit{jj}, ydataFit{jj}, 'k', 'LineWidth', 1)
            xlabel('size(#electrodes)')
            ylabel('P(size)')
            title(['cluster ', letters(jj), ' slope ', num2str(slopes{jj})])
            axis([1 1e+2 1e-6 1])
        end
    case 3      % lifetime
        figure('Name',['Probability distribution of avalanches lifetime - Bin Width ', num2str(binWidth),' ms'])
        for jj = 1:max(size(xdata))
            subplot(2,3,jj)
            loglog(xdata{jj}, ydata{jj}, 'r.-')
            hold all
            loglog(xdataFit{jj}, ydataFit{jj}, 'k', 'LineWidth', 1)
            xlabel('duration(#bins)')
            ylabel('P(duration)')
            title(['cluster ', letters(jj), ' slope ', num2str(slopes{jj})])            
            axis([1 1e+3 1e-6 1])
        end
end
saveas(gcf, figName, 'fig')
%saveas(gcf, figName, 'jpg')
%close all
cd(start)

