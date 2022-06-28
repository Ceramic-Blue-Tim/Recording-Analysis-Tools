function [dispwarn] = plotraster_pdf(start_folder, end_folder, fs, pspdf)
    if nargin < 4; pspdf = 0; end % pspdf = 0 -> ps, pspdf = 1 -> pdf
    dispwarn   = 0;
    all_phases = dir(start_folder); % Struct containing the peak-det folders

    % make sure end folder exists.
    if( exist(end_folder,'dir') ~= 7)
        mkdir(end_folder);
    end
    
    for f= 3:length(all_phases)
        fprintf('\t phase [%s].\n',all_phases(f).name);
        % Get the data
        [S last_spike artifact] = CONV_nbt_data( fullfile(start_folder,all_phases(f).name) );
        
        S = UTIL_blank(S, artifact, (0:20)');
        
        S = S( S(:,1) ~= 26 ,:);
%         lookuptable = [36; 37; 87; 33; 28; 77; 71; 22; 27; 38; 63; 62; ... % CLUSTER A
%                        58; 57; 56; 68; 45; 48; 47; 55; 67; 78; 46; 66; ... % CLUSTER B + channel B/A
%                        74; 84; 64; 73; 86; 75; 85; 83; 82; 72; 65; 76; ... % CLUSTER C + channel C/A
%                        42; 52; 41; 44; 61; 53; 51; 43; 31; 32; 54; 21; ... % CLUSTER D + channel D/A
%                        15; 14; 25; 16; 23; 34; 24; 35; 26; 17; 13; 12];    % CLUSTER E + channel E/A
%         [mc_el el_ord] = intersect(lookuptable,sort(lookuptable));
%         el_ord_ = zeros(max(lookuptable),1); 
%         el_ord_(lookuptable) = 1:length(lookuptable);
%         
%         imt_lab = {'A1','A2','A3','A4','A5','A6','A7','A8','A9','A10','A11','A12',...
%                    'B1','B2','B3','B4','B5','B6','B7','B8','B9','B10','B11','chB-A',...
%                    'C1','C2','C3','C4','C5','C6','C7','C8','C9','C10','C11','chC-A',...
%                    'D1','D2','D3','D4','D5','D6','D7','D8','D9','D10','D11','chD-A',...
%                    'E1','E2','E3','E4','E5','E6','E7','E8','E9','E10','E11','chE-A'};

        % make the raster plot
%         h = DISPLAY_raster(S,fs,'stim_time',artifact,'fig_no',1,'el_order',el_ord_,'el_labels',imt_lab(el_ord));
        h = DISPLAY_raster_sm(S,fs,'stim_time',artifact,'fig_no',1);
        
        
        % prepare for print
        subplot(5,1,1:4); title(strrep(all_phases(f).name,'_','\_'),'FontSize',12)
            org_units = get(h,'Units');
            set(h, 'PaperPositionMode','auto');
            set(h, 'Units', 'inches');
            set(h, 'Position', [0 0 11 8]);
            set(h, 'PaperType','a4')
            orient landscape
            
        if(pspdf == 1)
            % print to pdf file
            print(h,'-dpdf',fullfile(end_folder,strrep(all_phases(f).name,'ptrain','RASTER')));
        elseif(pspdf == 0)
            % print to multi-page postscript file
            print(h,'-dpsc2','-append',fullfile(end_folder,'RasterPlots'));        
        end
        
        set(h,'Units',org_units);
    end
end
