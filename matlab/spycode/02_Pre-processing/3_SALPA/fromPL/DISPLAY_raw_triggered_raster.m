function h = DISPLAY_raw_triggered_raster(raw_trace,raw_trigger,varargin)
    h = gcf;
    
    scaling = 50;       % y scale
    t_range = (-100:500)'; % in samples
    row_labels = [];
    spike_overlay = [];
    artefact_overlay = [];
    plot_color = 'k-';
    
    for i = 2:2:nargin-2
        switch(varargin{i-1})
            case 'scaling'
                scaling   = varargin{i}(:);
            case 'color'
                plot_color= varargin{i}(:);
            case 't_range'
                t_range   = varargin{i}(:);
            case 'fig_no'
                fig_no    = varargin{i}(:);
                h = figure(fig_no); clf;
            case 'row_labels'
                row_labels = varargin{i}(:);
            case 'spike_overlay'
                spike_overlay = varargin{i}(:);
            case 'artefact_overlay'
                artefact_overlay = varargin{i}(:);
            otherwise
                fprintf('WARNING: Unknown optional parameter [%s], ignored.\n',varargin{i});
        end
    end

    raw_trigger = raw_trigger( raw_trigger < length(raw_trace) - t_range(end) );
    
    idx    = ( raw_trigger * ones(1,1 + range(t_range)) ) + ( ones(length(raw_trigger),1) * t_range' );
    traces = ( raw_trace( idx ) ./ scaling ) + (1:length(raw_trigger))' * ones(1,1 + range(t_range));

    plot(t_range./10,traces',plot_color);
    ylim([0,1+length(raw_trigger)])
    xlim([t_range(1) t_range(end)]./10)
    
    set(gca,'YTick',1:length(raw_trigger));
    xlabel('time (ms)');
    ylabel('stimulus');

    x_leg = (t_range(end) - .05*range(t_range)) / 10;
    hold on; plot([1;1] * x_leg,length(raw_trigger)+[-.5; .5],'r-')
    text(x_leg,length(raw_trigger),sprintf('%3.1fuV ',scaling),'HorizontalAlignment','right','Color','red','FontSize',8);
    
    if( ~isempty( spike_overlay ) )
        hold on;
        peak_train = sparse( spike_overlay,1,1,length(raw_trace),1 );
        plot_peaks = peak_train(idx);
        [r c] = find(plot_peaks);
        plot( (c(:)+t_range(1))./10,r(:),'r*');
    end
    if( ~isempty( artefact_overlay ) )
        hold on;
        artefact_train = sparse( artefact_overlay,1,1,length(raw_trace),1 );
        plot_artefact  = artefact_train(idx);
        [r c] = find(plot_artefact);
        plot( ([c(:) c(:)+20]'+t_range(1))./10,[r(:) r(:)]','b-','LineWidth',3);
    end
    
    if( length(raw_trigger) == length(row_labels) )
        text((t_range(end)/10).*ones(1,length(raw_trigger)),1:length(raw_trigger),row_labels,'FontSize',4,'HorizontalAlignment','left');
    end
end