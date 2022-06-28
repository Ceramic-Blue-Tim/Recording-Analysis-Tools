% plotAFR
% Script for plotting the average firing rate, taking into account the
% different phases so that each phase is plotted with a different color
%
% by Matteo Macrì, modified by M. Chiappalone (May 2010)

[start_folder] = selectfolder('Select the source folder containing AFR analysys');
a=0;c=0;d=0;e=1;

if isempty(start_folder)
    return
else
    cd(start_folder)
    content=dir;
    nome = start_folder;
    riman = start_folder;
    while true                                                             %Divido la directory
        c=c+1;
        [nome, riman] = strtok(riman,'\');

        if isempty(nome);  break; end
        token{c}=nome;
    end
    for i=3:length(dir)                                                    %Conto le fasi contando i file di analisi ifr
        if (~isempty (findstr('ifr_ptrain_',content(i).name)))
            d=d+1;
        else
        end
    end
    num_files = d;
    phaseIdx=[1:num_files];
    load IFR_allPhases.txt;
    load bin;
    S=size(IFR_allPhases);
    r=S(1,1);
    b=0;
    diff=length(dir)-num_files;
    h = figure('Name',token{c-1},'NumberTitle','off');                     %Titolo della finestra di plot
    endValue = 0;
    xValuesAll = [];



    for t = 3:length(dir)
        if (~isempty (findstr('ifr_ptrain_',content(t).name)))
            str = content(t).name ;
            remain = str;

            while true                                                     %Creo una matrice di tutti i nomi dei file divisi
                a=a+1;
                [str, remain] = strtok(remain, '_');
                if isempty(str),a=0;  break; end
                tok{t-diff,a}=str;

            end
        else
        end
    end
end
for t=1:(num_files)                                                        %Controllo sulla start_folder                      
    if ((strcmp('ifr',tok{t,1}))==0)
        errordlg('cartella sbagliata')
    else
    end
end
for t=1:(num_files)                                                        %Controllo sulla formattazione del nome dei file
    if (~isempty(str2num(tok{t,6})))
        errordlg('Rinominare files')
    else
    end
end

phase=tok(:,6);
for i = 1:length(phase)                                                    %Omogeneizzo le fasi fisiologiche e neurobasali eliminando l'indice
    if (findstr('fisio',phase{i})==1)                                      %numerico
        phase{i}='fisio';
    elseif(findstr('nbasal',phase{i})==1)
        phase{i}='nbasal';
    elseif(findstr('control',phase{i})==1)
        phase{i}='control';
    else
    end
end
indexes(1)=1;
for i=2:length(phase)                                                      %Creo una matrice booleana in cui 1 identifica la prima occorrenza
    for k = i-1 :-1:1                                                      %di ogni fase,e le conto.
        if strcmp(phase{i},phase{k})==1
            indexes(i)=0;
            break
        elseif ((strcmp(phase{i},phase{k})==0)&& (k==1))
            indexes(i)=1;
            e=e+1;
        end
    end
end
colori=colormap(jet(e));                                                   %Creo una mappa di colori scalata esattamente al numero necessario
e=1;
colphase(1,:)=colori(1,:);
for i=2:length(phase)                                                      %colphase:matrice con lo stesso numero di righe di phase che associa
                                                                           %ad ogni fase un colore della colormap
    for k = i-1 :-1:1
        if strcmp(phase{i},phase{k})==1
            colphase(i,:)=colphase(k,:);
            break
        elseif ((strcmp(phase{i},phase{k})==0)&& (k==1))
            e=e+1;
            colphase(i,:)=colori(e,:);
        end
    end
end
for t=1:(num_files)

    if(~isempty(find(IFR_allPhases(:,1) == phaseIdx(t),1)))
        ifrCurrentMean = IFR_allPhases(IFR_allPhases(:,1) == phaseIdx(t),2);
        ifrCurrentStd = IFR_allPhases(IFR_allPhases(:,1) == phaseIdx(t),3);
        xValues = (endValue+bin_s):bin_s:(endValue+length(ifrCurrentMean)*bin_s);

        xValuesAll = [xValuesAll; xValues(:)];
        endValue = xValues(end);
        graph(t) =errorbar(xValues,ifrCurrentMean,ifrCurrentStd,'.-','Color',colphase(t,:));     %memorizzo l’handle di ogni grafico in un array
       
        hold all


    end

end
 xlabel('Time [s]')
 ylabel('IFR [spikes/s]')

legend(graph(find(indexes)), phase(find(indexes)))

cd(start_folder)
imgjpg=strcat(token{c-1},'.jpg');                                          %Salvo il plot come immagine in due formati
imgfig=strcat(token{c-1},'.fig');
saveas(h,imgfig)
saveas(h,imgjpg)
        
        