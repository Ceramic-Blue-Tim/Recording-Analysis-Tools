% plotMultISI8x8.m
% by Valentina Pasquale, March 2008
function [success,errorStr] = plotISISmoothPeaks(saveFolderPath,numElec,xx,yy,ISImax,peaks,flags)
if length(xx) ~= length(yy)
    errordlg('Cell arrays of XData and YData do not have the same length!', '!!Error!!', 'modal');
    return
end
% Start processing
for i = 1:length(xx)
    if(~isempty(xx{i,1}) && ~isempty(yy{i,1}))
        hFig = figure;
        semilogx(xx{i,1}, yy{i,1} , 'b.-');
        hold on
        grid on
        if(~isempty(peaks{i,1}))
            semilogx(peaks{i,1}(:,1),peaks{i,1}(:,2),'k*'); 
        end
        if all(flags(i,:))
            semilogx(ISImax(i),yy{i,1}(xx{i,1}==ISImax(i)),'r*');
        end
        set(gca,'FontSize',10)
        yLim = get(gca,'YLim');
        ylim([0 yLim(2)])
        xlabel('ms')
        ylabel('Probability')
        fnameFig = strcat(fullfile(saveFolderPath,['ISImax_ch_',num2str(numElec(i))]),'.fig');
        fnameJpg = strcat(fullfile(saveFolderPath,['ISImax_ch_',num2str(numElec(i))]),'.jpg');
        try
            saveas(hFig,fnameJpg,'jpg');
            saveas(hFig,fnameFig,'fig');
        catch
            success = 0;
            errorStr = lasterror;
            errordlg(errorStr.message,errorStr.identifier)
            return
        end
        close(hFig)
    end
end
success = 1;
errorStr = [];