%% Mat to table

sync = [load('/home/rbeaubois/Documents/ENSEIRB/Internship/Work/Matlab_function/mat/sync1.mat')...
    load('/home/rbeaubois/Documents/ENSEIRB/Internship/Work/Matlab_function/mat/sync2.mat')];

%%
trace       = zeros(5,4);
electrodes  = [4 12 20 21];
file_size   = [5 9];

for files = 1:2
    for i = 1:file_size(files)
        filename = sprintf("csv/sync%d_t%d.csv",files,i);
        fileID = fopen(filename,'w');
        fprintf(fileID,"Electrode;Interburst_CV_s;Mean_burst_freq_Hz;");
        fprintf(fileID,"Mean_interspike_s;Mean_negspks_amp_V;Mean_posspks_amp_V");
        fprintf(fileID,"\n");
        for j = 1:4
            a = sync(files).analysis.Interburst_interval_CV(electrodes(j),i);
            b = sync(files).analysis.Mean_burst_frequency(electrodes(j),i);
            c = sync(files).analysis.Mean_interspike_interval(electrodes(j),i);
            d = sync(files).analysis.Mean_negsps_amp(electrodes(j),i);
            e = sync(files).analysis.Mean_posspks_amp(electrodes(j),i);
            fprintf(fileID,"%d;%.4f;%.4f;%.4f;%.4f;%.4f\n", electrodes(j), a, b, c, d, e);
        end
        fclose(fileID);
    end
end