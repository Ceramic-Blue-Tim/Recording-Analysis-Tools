% plot_globalIBI.m
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
NetworkIBI = createResultFolderNoOverwrite(expFolderPath, BDFolder, 'NetworkIBI');
if FileName == 0
    errordlg('Selection Failed - End of Session', 'Error');
    return
end      
if exist(fullfile(PathName, FileName))
    % --------------- USER information
    single=0;
    [el, binsec, max_x, ylim, fs, cancelFlag]= uigetIBIinfo(single);

    if cancelFlag
        errordlg('Selection Failed - End of Session', 'Error');
        return
    end
    % --------------- PLOT phase
    load (fullfile(PathName, FileName)) % a cell array with the burst detection is loaded
    if length(burst_detection_cell)==87 %added for compatibility with previous versions
        burst_detection_cell(end+1)=[];
    end
    IBIarray=[];
    for i=1:64
        el=mcmea_electrodes(i);
        if ((el<=length(burst_detection_cell) && ~isempty( burst_detection_cell{el,1})))

        temp=burst_detection_cell{el,1};
        
        [r,c]=size(temp);
        if r>=3
            IBIarray=[IBIarray; burst_detection_cell{el,1}(1:end-2,5)];
        end
        end
    end

    figure();
    [bins,n_norm,max_y] = f_single_IBIh_Michela(IBIarray, fs, max_x, binsec);
    % y=plot(bins, n_norm , 'LineStyle', '-', 'col', 'b', 'LineWidth', 2);
    
    y=bar(bins, n_norm, 1, 'r' );

    axis ([0 max_x 0 ylim])
    title ('Inter Burst Interval - IBI Histogram');
    xlabel('Inter Burst Interval [sec]');
    ylabel('Probability per bin');
    cd (NetworkIBI)
    nome=strcat('NetworkIBI_',FileName(1:end-4));
    saveas(y,nome,'jpg')
    close;
    EndOfProcessing (PathName, 'Successfully accomplished');
end

