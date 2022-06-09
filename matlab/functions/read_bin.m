function [Signal, fname_no_ext, rec_param] = read_bin(bin_fpath, rec_duration_secs)

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
    
% Load signal from binary file
    fprintf(sprintf("[Loading] : %s\n", fname_no_ext));   % Display file selected
    [Signal] = binshort2signal(bin_fpath, rec_param);

end