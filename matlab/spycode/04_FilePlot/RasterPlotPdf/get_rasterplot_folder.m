function end_folder = get_rasterplot_folder(start_folder)
    peak_pos   = strfind(start_folder,'PeakDetection');
    if(peak_pos > 0)
        end_folder = strcat(start_folder(1:peak_pos-1),'RasterPlotPdf');
    else
        warning('Startfolder does not contain string ''PeakDetection''.\nSaving to current folder [%s].',pwd);
        end_folder = pwd;
    end
end