function [Signal]=rawshort2signal(fileID_raw, rec_param)

% Set measurement duration
nb_samples              = rec_param.time_s * rec_param.fs;
rec_time_ms             = rec_param.time_s * 1e3;

% Read binary file
A                       = fread(fileID_raw,[rec_param.nb_chan+1 nb_samples],'uint16', 'n');
time_temp               = [rec_time_ms : -1e3/rec_param.fs : 0];
time                    = rot90(time_temp); clear time_temp;
time(rec_time_ms+1, :)  = [];

% Rearrange data in the variable Signal
trans_A                 = transpose(A); clear A;
B                       = (trans_A-rec_param.offset_ADC)*rec_param.conv_f; clear trans_A;
l_B                     = length(B(:,1));
Signal                  = horzcat(time(1:l_B, 1), B); clear B time;

end