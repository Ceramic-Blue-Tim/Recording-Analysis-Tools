% compCCorrParam.m
% Function that makes different analysis on the correlogram and produces
% the histograms for C(0), Peak position, Coincidence Index (CI)
% by Michela Chiappalone (9 Maggio 2005)
% modified by V. Pasquale (April 2007)
% modified by Luca Leonardo Bologna (10 June 2007)
%   - in order to handle the 64 channels of the MED64 Panasonic system

function compCCorrParam(binpeak, binzero, binsample, fs, start_folder, end_folder)
% INPUT --> winmsec [msec]
%           binmsec [msec]
%           binpeak = number of bins on one side of maximum peak detected - total winpeak length is (2*binpeak+1)*bin
%           binzero = number of bins on one side of 0 - total winpeak length is (2*binzero+1)*bin
%           start_folder = folder containing the computed cross-correlograms

% -----------> VARIABLE DEFINITION
mcmea_electrodes = [(11:18)'; (21:28)'; (31:38)'; (41:48)'; (51:58)'; (61:68)'; (71:78)';(81:88)'];
% mcmea_electrodes = [(12:17)'; (21:28)'; (31:38)'; (41:48)'; (51:58)'; (61:68)'; (71:78)';(82:87)']; % electrode names
first = 3;
numElectrodes = 64;

% -----------> INPUT FOLDERS & ARRAY DEFINITION
cd(start_folder)
corrfolders = dir;
numcorrfolders = length(corrfolders);

c0 = cell(88,numcorrfolders-2);
CI0 = cell(88,numcorrfolders-2);
cPeak = cell(88,numcorrfolders-2); 
CIpeak = cell(88,numcorrfolders-2); 
peakLatency = cell(88,numcorrfolders-2);
exp_phase = 0;

% -----------> COMPUTATION
if ~rem(binsample,2)
    binsample=binsample+1;
end
binmsecNew = binsample*1000/fs;
for i = first:numcorrfolders  % Cycle over the 'Cross correlation' folders
    exp_phase = exp_phase+1;
    currentcorrfolder = corrfolders(i).name;
    cd(currentcorrfolder)
    currentcorrfolder = pwd;
    corrfiles = dir;
    numcorrfiles = length(dir);
    for j = first:numcorrfiles                     % Cycle over the 'Cross correlation' files
        filename = corrfiles(j).name;
        tmp         = split(filename, '_');
        tmp2        = split(tmp(end), '.');
        el          = char(tmp2(1));
        electrode = str2double(el);                % Electrode name in DOUBLE
        load(filename)                             % Variable r_table is loaded --> one for each electrode
        if length(r_table)==87
            r_table(end+1)=[];
        end
        % -------------> PROCESSING
        r_table{electrode,1} = zeros(size(r_table{electrode,1},1),1);                   % autocorrelation is excluded
        x = length(r_table{electrode,1});            % Length of the correlogram [bins]
        r_mcmea = r_table(mcmea_electrodes,1);       % select only the rows of mcmea electrodes (11,13,...88)
        %% Add IC for Check if the electrode are silent
%         for CheckCurrEl=1:size(r_mcmea,1)
%             CurrCheck=r_mcmea{CheckCurrEl,:};
%             if ~isempty(CurrCheck)
%                
%                 CheckPeak=sort(max(CurrCheck),'ascend');
%                 
%                 if CheckPeak<=0.1 | isempty(CheckPeak)
%                     CheckPeak=CheckPeak(1);
%                     r_mcmea{CheckCurrEl,:}=zeros(size(r_table{electrode,1},1),1);
%                 end
%             end
%         end
        
        %%
        missingElec = find(cellfun('isempty',r_mcmea));
        for k = 1:length(missingElec)
            r_mcmea{missingElec(k)} = zeros(x,1);
            c0{mcmea_electrodes(missingElec(k)), exp_phase} = zeros(numElectrodes,1);
            CI0{mcmea_electrodes(missingElec(k)), exp_phase} = zeros(numElectrodes,1);
            cPeak{mcmea_electrodes(missingElec(k)), exp_phase} = zeros(numElectrodes,1);
            CIpeak{mcmea_electrodes(missingElec(k)), exp_phase} = zeros(numElectrodes,1);
            peakLatency{mcmea_electrodes(missingElec(k)), exp_phase} = zeros(numElectrodes,1);
        end
        cc = reshape(cell2mat(r_mcmea), x, numElectrodes)';     % Reshape the cell array (cc is 60*[bins])
       
        
        center = median(1:x);                        % Center of the correlogram (index of the bin centered in 0)
        ccarea = sum(cc,2);                          % Area of the correlogram (sum over columns --> ccarea is 60*1)
        clear filename k
        
        
     
        if(~isempty(find(cc)))
            % Cpeak
            [maxv, maxi] = max(cc,[],2);                 % Peak amplitude [uVolt] and position [samples]
            %[r, c] = size(maxi);
            cPeak_temp = zeros(numElectrodes, 1);
            for k = 1:numElectrodes  % Cycle on all the electrodes
                maxes = find(cc(k,:) == maxv(k));
                if(isscalar(maxes))         % if there is only one maximum value
                    if (maxi(k)-binpeak) > 0 && (maxi(k)+binpeak) < size(cc,2)
                        cPeak_temp(k,1) = sum(cc(k, (maxi(k)-binpeak):(maxi(k)+binpeak)));
                    end
                else                        % if there are more than one max values, it considers the one which is closest to zero
                    d = maxes - center;
                    absd = abs(d);
                    [minv, mini] = min(absd);
                    maxi(k) = center + d(mini);   
                    if (maxi(k)-binpeak) > 0 && (maxi(k)+binpeak) < size(cc,2)
                        cPeak_temp(k,1) = sum(cc(k, (maxi(k)-binpeak):(maxi(k)+binpeak)));
                    end              
                end
            end
            cPeak{electrode, exp_phase} = cPeak_temp;

            % Coincidence Index around peak (CIpeak)
            warning off MATLAB:divideByZero
            CIpeak_temp = cPeak_temp./ccarea;
            CIpeak_temp(isnan(CIpeak_temp)) = 0;             % Put equal to zero the NaN elements --> the area is zero!
            CIpeak{electrode, exp_phase} = CIpeak_temp;      

            % Peak latency
            peakLatency_temp = (maxi-center)*binmsecNew;
            peakLatency{electrode, exp_phase} = peakLatency_temp;  % Peak latency from zero [msec]

            % C(0)
            c0_temp = zeros(numElectrodes, 1);
            cc_temp = cc(:,(center-binzero):(center+binzero));      % cross correlogram close to 0
            c0_temp = sum(cc_temp,2);
            c0{electrode, exp_phase}= c0_temp;        

            % Coincidence Index around zero (CIzero)
            warning off MATLAB:divideByZero
            CI0_temp = c0_temp./ccarea;
            CI0_temp(isnan(CI0_temp)) = 0;              % Put equal to zero the NaN elements --> the area is zero!
            CI0{electrode, exp_phase} = CI0_temp;        
            
            cd(currentcorrfolder)
            clear cc
        else                        % if cc has no elements ~= 0 --> the electrode is off...
            cPeak{electrode, exp_phase} = zeros(numElectrodes, 1);
            CIpeak{electrode, exp_phase} = zeros(numElectrodes, 1);
            peakLatency{electrode, exp_phase} = NaN*ones(numElectrodes, 1);    % put the peak latencies equal to NaN 
            c0{electrode, exp_phase} = zeros(numElectrodes, 1);
            CI0{electrode, exp_phase} = zeros(numElectrodes, 1);
        end
    end % of FOR on j    
    cd(start_folder)    
end % of FOR on i

% -----------> PLOT and SAVING
savePlotCCorrParam(c0, CI0, cPeak, CIpeak, peakLatency, binmsecNew, corrfolders, end_folder)