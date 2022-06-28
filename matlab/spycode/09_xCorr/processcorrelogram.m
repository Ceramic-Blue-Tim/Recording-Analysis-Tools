% PROCESSCORRELOGRAM.m
% Function that makes different analysis on the correlogram and produces
% the histograms for C(0), Peak position, Coincidence Index (CI)
% by Michela Chiappalone (9 Maggio 2005)
% modified by Luca Leonardo Bologna (11 June 2007)
%   - in order to handle the 64 channels of MED64 Panasonic system

function []= processcorrelogram (exp_num, wsample, binsample, binpeak, fs, r_bigfolder, res_folder)

% INPUT --> wsample [sample]
%           binsample [sample]
%           binpeak = number of bins on one side of 0 - total winpeak length is 2*binpeak*bin
%           fs [sample/sec]
%           r_bigfolder = folder containing the computed cross-correlograms
%           res_folder=   folder for results

% -----------> VARIABLE DEFINITION
first=3;
elNum=64;
winmsec= wsample*1000/fs;    % window [msec]
binmsec= binsample*1000/fs;  % bin [msec]
plus= rem(winmsec, binmsec); % Remainder of division
x= [-(winmsec+plus):binmsec:(winmsec+plus)]'; % There is always a bin centered in zero
x0=find(x==0); % Position of the bin centered in zero
thresh=0.05;      % Threshold for the correlogram area
mcmea_electrodes = GlobalsParams.DEFAULT_ELECTRODES_LAYOUT;
peak_statistics=[];

% -----------> INPUT FOLDERS & ARRAY DEFINITION
cd(r_bigfolder)
corrfolders=dir;
numcorrfolders=length(dir);
exphase= numcorrfolders-first+1;

cdi0= cell(88,exphase);
coinc_index= cell(88,exphase);
peak_pos= cell(88,exphase);
exphase=0;

% -----------> COMPUTATION PHASE
for i=first:numcorrfolders   % Cycle over the 'Cross correlation' folders
    exphase= exphase+1;
    currentcorrfolder=corrfolders(i).name
    cd(currentcorrfolder)
    % resdir=strcat ('Analysis_', currentcorrfolder); % Name of the resulting directory
    % name=strrep(currentcorrfolder,'Correlogram_', '');
    currentcorrfolder=pwd;
    corrfiles=dir;
    numcorrfiles=length(dir);

    for j=first:numcorrfiles % Cycle over the 'Cross correlation' files
        filename=corrfiles(j).name;
        tmp         = split(filename, '_');
        tmp2        = split(tmp(end), '.');
        el          = char(tmp2(1));
        electrode= str2num(el);    % Electrode name in DOUBLE
        load(filename)             % Variable r_table is loaded
        if length(r_table)==87 %added for compatibility with previous versions
            r_table(end+1)=[];
        end
        r_table{electrode,1}=zeros(length(x),1); % autocorrelation is excluded
        cc=r_table(mcmea_electrodes,1);
        for k=1:elNum
            if isempty(cc{k})
                cc{k}=zeros(length(x),1);
            end
        end
        ccm = reshape (cell2mat(cc), length(x), elNum)';
        ccmarea=(sum(ccm')');              % Area of the correlogram
        % ccmarea(find(ccmarea<thresh))=0; % Put equal zero the areas under the thresh
        clear cc r_table filename k

        % Coincidence Index (CI)
        r_peak= ccm(:,(x0-binpeak):(x0+binpeak)); % cross correlogram close to the peak
        warning off MATLAB:divideByZero
        ci_temp= (sum(r_peak')')./ccmarea;
        ci_temp(isnan(ci_temp))= 0;     % Put equal to zero the NaN elements
        ci_temp(find(ci_temp<thresh))= [];
        coinc_index{electrode, exphase}=ci_temp;
        clear ci_temp

        % C(0)
        r_peak= ccm(:, x0); % cross correlogram in zero
        cdi0{electrode, exphase}= r_peak;
        %cdi0{electrode, exphase}= (sum(r_peak')'); % cross correlogram close to the peak
        clear r_peak

        % Peak distance and position
        peakpos=zeros(elNum,1);
        for k=1:elNum
            [vmax,imax]=max(ccm(k,:));
            if vmax>0
                peakpos(k,1)=x(imax);
            else
                peakpos(k,1)=-(winmsec+plus+100);
            end
        end
        peakpos(find(peakpos==-(winmsec+plus+100)))=[];
        peak_pos{electrode, exphase}=peakpos;
        clear vmax imax peakpos

        cd(currentcorrfolder)
        clear ccm
    end % of FOR on j
    cd(r_bigfolder)
end % of FOR on i

% --------------> PLOT PHASE
% Plot the histograms for C(0) e CI
coinc_index= coinc_index(mcmea_electrodes,:);
cdi0=cdi0(mcmea_electrodes,:);
peak_pos=peak_pos(mcmea_electrodes,:);

% C(0)
flag=1;
x=[0:0.05:1]; % If the peak window is zero
[h1,histo1]= plotprocesscorrelogram (cdi0, x, flag); % Histogram for cdi0
clear x

% CI
flag=2;
x=[0:0.05:1]; % Maximum possible value is 1
[h2,histo2]= plotprocesscorrelogram (coinc_index, x, flag); % Histogram for coincidence index
clear x

% Peak Position
flag=3;
x=[-30:binmsec:30];
[h3, histo3]= plotprocesscorrelogram (peak_pos, x, flag); % Histogram for coincidence index
clear x


% --------------> SAVING PHASE
cd (res_folder) % Save the histograms and the cell array

% C(0)
filename=strcat( 'Exp_', exp_num,'_C0');
save (filename,'cdi0', 'histo1')
saveas (h1, filename, 'jpg')
clear filename

% CI
peak_area=(binpeak*2+1)*binmsec; % Window around the peak of the correlogram [msec]
filename=strcat( 'Exp_', exp_num,'_CI - Peak Area', num2str(peak_area), 'msec');
savenonzeros_ascii(coinc_index, filename) % Save for ORIGIN
save (filename,'coinc_index', 'histo2')
saveas (h2, filename, 'jpg')

% Peak Position
filename=strcat( 'Exp_', exp_num,'_Max position');
save (filename,'peak_pos', 'histo3')
saveas (h3, filename, 'jpg')

%close all
