% PLOT_SINGLEIBI.m
% by M. Chiappalone (26 Maggio 2006)
% modified by Luca Leonardo Bologna 04 June 2007
%   - modified in order to handle 64 channels

clr
[FileName,PathName] = uigetfile('*.mat','Select a Burst Detection file');
mcmea_electrodes = GlobalsParams.DEFAULT_ELECTRODES_LAYOUT;
cd (PathName)
s=strfind(PathName,'\')
BDFolder=PathName(1:s(end-1)-1)
cd ..
cd ..
expFolderPath=pwd;
SingleChannelFolderIBI = createResultFolderNoOverwrite(expFolderPath, BDFolder, 'SingleChannelIBI');

if FileName == 0
    errordlg('Selection Failed - End of Session', 'Error');
    return
end
if exist(fullfile(PathName, FileName))
    % --------------- USER information
    single=1;
    [el, binsec, max_x, ylim, fs, cancelFlag]= uigetIBIinfo(single);

    if cancelFlag
        errordlg('Selection Failed - End of Session', 'Error');
        return
    else
        if isempty (find(mcmea_electrodes==el))
            msgbox ( 'Not existent channel!','End of Session', 'error')
            return
        end

        % --------------- PLOT phase
        load (fullfile(PathName, FileName)) % a cell array with the burst detection is loaded
        if length(burst_detection_cell)==87 %added for compatibility with previous versions
            burst_detection_cell(end+1)=[];
        end
        IBIarray=burst_detection_cell{el,1};
        [r,c]=size(IBIarray);
        if (r<7)
            msgbox ( 'Too few bursts - No possible to build a histogram','End of Session', 'warn')
            return
        else
            figure();
            IBIarray=burst_detection_cell{el,1}(1:end-2,5);
            [bins,n_norm,max_y] = f_single_IBIh_Michela(IBIarray, fs, max_x, binsec);
            % y=plot(bins, n_norm , 'LineStyle', '-', 'col', 'b', 'LineWidth', 2);
            y=bar(bins, n_norm, 1, 'r' );

            axis ([0 max_x 0 ylim])
            title ('Inter Burst Interval - IBI Histogram');
            xlabel('Inter Burst Interval [sec]');
            ylabel('Probability per bin');
            cd (SingleChannelFolderIBI)
            name=FileName(1:end-4);
            saveas(y,name,'jpg')
            %saveas(y,name,'fig')
           
            %close;
        end
    end
end
EndOfProcessing (PathName, 'Successfully accomplished');
clear all
