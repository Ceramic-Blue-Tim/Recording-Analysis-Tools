% PLOT_SINGLEPSTH.m

% by M. Chiappalone (02 Febbraio 2006)

clr
[FileName,PathName] = uigetfile('*.mat','Select the PSTH MAT-file');

if FileName == 0
    errordlg('Selection Failed - End of Session', 'Error');
    return
end    
if exist(fullfile(PathName, FileName))
    % --------------- USER information
    prompt  = {'X-axis Lim (msec)'};
    title   = 'Plot single PSTH settings';
    lines   = 1;
    def     = {'400'};
    Ianswer = inputdlg(prompt,title,lines,def);

    if isempty (Ianswer)
        errordlg('Selection Failed - End of Session', 'Error');
        return
    end
    % --------------- PSTH parameters
    figure();
    xlim  =  str2double(Ianswer{1,1}); % X-axis limit for the plot
    binindex1=strfind(PathName, 'bin');
    binindex2=strfind(PathName, '-');
    binsize=str2num(PathName(binindex1+3:binindex2(end)-1));
    timeframeindex=strfind(PathName, 'msec');
    timeframe= str2num(PathName(binindex2(end)+1:timeframeindex-1));
    x=binsize*[1:timeframe/binsize];

    clear title prompt lines def Ianswer binindex1 binindex2

    % --------------- PLOT phase
    load (fullfile(PathName, FileName))
    y=plot(x, psthcnt, 'LineStyle', '-', 'col', 'b', 'LineWidth', 2);
    ylim= ceil(max(psthcnt));
    axis ([0 xlim 0 ylim])

    tmp         = split(filename, '_');
    tmp2        = split(tmp(end), '.');
    electrode   = char(tmp2(1));
    stimindex= strfind(FileName, 'stim');
    stimname = strrep(FileName(stimindex:end-6), '_', ' ');
    titolo=strcat('PSTH',' ', stimname, ' el ', electrode);
    title(titolo);
    xlabel('Time Relative to Stimulus (msec)');
    ylabel('Number of Evoked Spikes');
    
    EndOfProcessing (PathName, 'Successfully accomplished');
end


clear all
