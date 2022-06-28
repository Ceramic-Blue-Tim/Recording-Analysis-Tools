function [dispwarn] = plotpsth_pdf(start_folder, end_folder, fs, blanking, pspdf)
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
        load( fullfile(start_folder,all_phases(f).name) );
        bin_size = 50   * 1000 / fs;
        win_size = 5000 * 1000 / fs;
        
        all_psth_m(1:blanking,:) = 0;
        all_psth_m = all_psth_m ./ n_stim;
        
        t_avg = (bin_size:bin_size:win_size)';
        h = DISPLAY_avg_burst(t_avg, all_psth_m, bin_size, n_stim, els, 0);
        
        % prepare for print
        subplot(4,1,1); title(strrep(all_phases(f).name,'_','\_'),'FontSize',12)
            org_units = get(h,'Units');
            set(h, 'PaperPositionMode','auto');
            set(h, 'Units', 'inches');
            set(h, 'Position', [0 0 11 8]);
            set(h, 'PaperType','a4')
            orient landscape
            
        if(pspdf == 1)
            % print to pdf file
            print(h,'-dpdf',fullfile(end_folder,all_phases(f).name(1:end-4)));
        elseif(pspdf == 0)
            % print to multi-page postscript file
            print(h,'-dpsc2','-append',fullfile(end_folder,'PSTH_Plots'));        
        end
        
        set(h,'Units',org_units);
    end
end
