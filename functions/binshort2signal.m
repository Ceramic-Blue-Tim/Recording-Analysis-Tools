function [Signal]=binshort2signal(bin_filename, rec_param)

% Open file
fileID_bin              = fopen(bin_filename);

% Set measurement duration
nb_samples              = rec_param.time_s * rec_param.fs;
rec_time_ms             = rec_param.time_s * 1e3;

% Read binary file
A                       = fread(fileID_bin,[rec_param.nb_chan nb_samples],'short', 'n');
time_temp               = [rec_time_ms : -1e3/rec_param.fs : 0];
time                    = rot90(time_temp); clear time_temp;
time(rec_time_ms+1, :)  = [];

% Rearrange data in the variable Signal
trans_A                 = transpose(A); clear A;
B                       = trans_A*rec_param.conv_f; clear trans_A;
Signal                  = horzcat(time, B); clear B time;

% Close file
fclose(fileID_bin);

end