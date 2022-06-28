function h = DISPLAY_raster_sm(S,fs,varargin)
% Function to make a raster plot of the raw data. It also plots the
% array-wide firing rate. Optionally it plots stimulation times in the
% upper plot as vertical green lines, and/or detected bursts in the lower
% panel as blue asterix.
% If the recording is long the figure can become very heavy, also when
% pasted in Word.
%
% PL Baljon, December 2007
%
    stim_time  = []; % the time points of stimulation (vertical green lines)
    burst_time = []; % time points of bursts (blue asterix)
    BIN_SIZE   = 1; % The binsize for burst detection (in seconds)
    fig_no     = 1;
    for i = 2:2:nargin-2
        switch(varargin{i-1})
            case 'stim_time'
                stim_time = varargin{i};
            case 'burst_time'
                burst_time = varargin{i};
            case 'awfr_bin'
                BIN_SIZE = varargin{i};
            case 'fig_no'
                fig_no = varargin{i};
            otherwise
                fprintf('WARNING: Unknown optional parameter [%s], ignored.\n',varargin{i});
        end
    end
    els = unique(S(:,1));
    h = figure(fig_no); clf;
    
    t = unique(round(linspace(min(S(:,2))/fs,max(S(:,2))/fs,50)));
    
    subplot(5,1,1:4);hold on;
    plot([1/fs;1/fs]*S(:,2)',[S(:,1)'+.4;S(:,1)'-.4],'k','LineWidth',.1);
    plot([0;max(S(:,2))/fs]*ones(1,length(els)+1),-.5+[[els els];[els(end)+1 els(end)+1]]','Color','red');
    set(gca,'YTick',els); set(gca,'YTickLabel',els );
    set(gca,'XTick',t); set(gca,'FontSize',5);
    axis([min(S(:,2))/fs max(S(:,2))/fs min(S(:,1))-.5 max(S(:,1))+.5]);
    if(~isempty(stim_time))
        plot([stim_time stim_time]'./fs,[min(S(:,1))-.5; max(S(:,1))+.5]*ones(1,length(stim_time)),'g');
    end
    set(gca,'XGrid','on');
    ylabel('Electrodes','FontSize',9);
    subplot(5,1,5);
    
    edges = 0:(BIN_SIZE*fs):fs*ceil(max(S(:,2))/fs);
    b_p = histc(S(:,2),edges);
    
    t_ = reshape([edges;edges],[],1);
    b_p = [0; reshape([b_p(1:end-1)'; b_p(1:end-1)'],[],1); 0];
    b_p([1 end]) = 0;

    fill(t_./fs,b_p,'k');
    axis([min(S(:,2))/fs,max(S(:,2))/fs 0 max(b_p)]);
    set(gca,'XTick',t); set(gca,'FontSize',5);
    set(gca,'XGrid','on');
    ylabel(sprintf('AWFR (#/%dms)',1000*BIN_SIZE),'FontSize',9); xlabel('Time (sec)','FontSize',9);
    if(~isempty(burst_time))
        hold on;
        plot(burst_time./fs,(.9*max(b_p)).*ones(length(burst_time),1),'b.','MarkerSize',2);
    end
end