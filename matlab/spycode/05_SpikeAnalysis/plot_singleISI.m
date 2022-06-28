% PLOT_SINGLEISI.m

% by M. Chiappalone (02 Febbraio 2006, 13 Aprile 2006)

clr
[FileName,PathName] = uigetfile('*.mat','Select a Peak Detection MAT-file');
cd(PathName)
s=strfind(PathName,'\');
PDFolder=PathName(1:s(end-1)-1);
cd ..
cd ..
expFolderPath=pwd;

SingleChannelFolder = createResultFolderNoOverwrite(expFolderPath, PDFolder, 'SingleChannelISI');
if FileName == 0
   errordlg('Selection Failed - End of Session', 'Error');
   return
end
if exist(fullfile(PathName, FileName))
    % --------------- USER information
    [bin_samp, max_x, ylim, fs, cancelFlag]= uigetISIinfo;

    if cancelFlag
        errordlg('Selection Failed - End of Session', 'Error');
        return
    end
    % --------------- PLOT phase
    load (fullfile(PathName, FileName))
    [bins,n_norm,max_y] = f_single_ISIh_Michela(peak_train, fs, max_x, bin_samp);
    % bins [sec]
    mbins=1000*bins; % mbins[msec]
    y=plot(mbins, n_norm , 'LineStyle', '-', 'col', 'b', 'LineWidth', 2);

    axis ([0 (max_x*1000) 0 ylim])
    title ('Inter Spike Interval - ISI Histogram');
    xlabel('Inter Spike Interval [msec]');
    ylabel('Probability per bin');
    cd (SingleChannelFolder)
    name=FileName(1:end-4);
    saveas(y,name,'jpg')
    %saveas(y,name,'fig')
    %close;
    EndOfProcessing (PathName, 'Successfully accomplished');

end
clear all
