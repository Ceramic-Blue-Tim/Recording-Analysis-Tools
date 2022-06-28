% last modification by Noriaki on May 25th, 2006
% History:
%   - insertion of error check .
%   - markers positioned exactly above the peak

% plotpeaksraw
clr
[Rawfile,Rawpath] = uigetfile('*.mat','Select the Raw data MAT-file of one electrode');
if (Rawfile == 0)
    errordlg('Selection Failed - End of Session', 'Error');
    return
end

[Ptrainfile,Ptrainpath] = uigetfile('*.mat','Select the corresponding Peak_train MAT-file');
if (Ptrainfile == 0)
    errordlg('Selection Failed - End of Session', 'Error');
    return
end

Rawexp = Rawfile(1:end-4);
Ptrainexppmarker = find(Ptrainfile=='_');
Ptrainexp = Ptrainfile(Ptrainexppmarker(1)+1:end-4)

% checks if Raw data and Peak_train MAT-file corresponds to the same experiment, phase or electrode. 
if (strcmp (Rawexp,Ptrainexp) == 1)

    load (fullfile(Rawpath,Rawfile))       % data loaded
    load (fullfile(Ptrainpath,Ptrainfile)) % peak_train & artifact loaded

    [fs, starttime, endtime, startend]=uigetRASTERinfo;
    
    xtime=(starttime:endtime)'/fs; % [x-scale in sec]

    data_plot= data(starttime:endtime);
    peak_plot= peak_train(starttime:endtime);
    %peakposition= (find(peak_plot)+starttime-1)/fs;
    peakposition = find(peak_plot);

    figure
    plot (xtime, data_plot)
    hold on
    plot (xtime(peakposition),data_plot(peakposition),'*r')
    submarker=find(Rawfile=='_');
    number = Rawfile(1:submarker(1)-1);
    phase = Rawfile(submarker(1)+1:submarker(2)-1);
    type = Rawfile(submarker(2)+1:submarker(3)-1);
    section = Rawfile(submarker(3)+1:submarker(4)-1);
    electrode = Rawfile(submarker(4)+1:end-4);
    titolo=strcat(number,'-',phase,'-',type,'-',section,'-',electrode);
    set(gca,'Title',text('String',titolo,'Color','k'))
    xlabel('Time [sec]');
    ylabel('Amplitude [uV]');
    
    EndOfProcessing (Rawpath, 'Successfully accomplished');
else
    errordlg ('Raw data and Peak_train MAT-file do not correspond')
end
clear all