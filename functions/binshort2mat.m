function [Signal, fname_no_ext, rec_param] = binshort2mat(bin_fpath, rec_duration_secs, save_param)

% Get parameters from hdr files
    [bin_dir, fname_no_ext, ~] = fileparts(bin_fpath);
    hdr_dir             = bin_dir;   % .hdr and .bin files in same directory
    hdr_fpath           = sprintf("%s%s%s.hdr", hdr_dir, filesep, fname_no_ext);

    hdr_fid             = fopen(hdr_fpath);
    file_format         = sscanf(fgetl(hdr_fid), "File Format Version, %d");
    session_start       = sscanf(fgetl(hdr_fid), "Session Start Time, %s");
    sampling_freq       = sscanf(fgetl(hdr_fid), "Sampling freq (Hz), %d");
    conv_factor         = sscanf(fgetl(hdr_fid), "Conversion factor: short to mV, %lf");
    active_channels     = split(string(fgetl(hdr_fid)),',');

    rec_param = struct(... 
    'format', file_format,...
    'start_t', session_start,...
    'fs', sampling_freq,...
    'time_s', rec_duration_secs, ...
    'conv_f', conv_factor, ...
    'active_chan', double(active_channels(2:end)), ...
    'nb_chan', length(active_channels)-1 ...
    );

    clear file_format session_start sampling_freq conv_factor active_channels
    
    fclose(hdr_fid);
    
    % Opening signal from binary file
    fprintf(sprintf("[Processing] : %s\n", fname_no_ext));   % Display file selected
    
    % Open file
    fileID_bin              = fopen(bin_fpath);

    % Set measurement duration
    nb_samples              = rec_param.time_s * rec_param.fs;
    rec_time_ms             = rec_param.time_s * 1e3;
    time_temp               = [rec_time_ms : -1e3/rec_param.fs : 0];
    time                    = rot90(time_temp); clear time_temp;
    time(rec_time_ms+1, :)  = [];

    i = 1;
    while ~feof(fileID_bin)
        A                       = fread(fileID_bin,[rec_param.nb_chan nb_samples],'short', 'n');

        % Rearrange data in the variable Signal
        trans_A                 = transpose(A); clear A;
        B                       = trans_A*rec_param.conv_f; clear trans_A;
        Signal                  = horzcat(time(1:length(B)), B); clear B;
        
        buf_name        = fname_no_ext;
        fname_no_ext    = sprintf("%s_%d", fname_no_ext, i);
        save(sprintf("%s/%s.mat", save_param.path, fname_no_ext), 'Signal', 'rec_param', 'fname_no_ext');
        fname_no_ext    = buf_name;
        i = i + 1;
    end

    % Close file
    fclose(fileID_bin);

end