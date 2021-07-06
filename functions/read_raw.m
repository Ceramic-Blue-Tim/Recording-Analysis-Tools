function [Signal, fname_no_ext, rec_param] = read_raw(raw_fpath, rec_duration_secs)

    % Get parameters from hdr files
        [raw_dir, fname_no_ext, ~]  = fileparts(raw_fpath);
        raw_fid                     = fopen(raw_fpath, 'r', 'n', 'UTF-8');

        fgetl(raw_fid);
        fgetl(raw_fid);
        fgetl(raw_fid);
        sampling_freq       = sscanf(fgetl(raw_fid), "Sample rate = %d");
        zero_ADC            = sscanf(fgetl(raw_fid), "ADC zero = %d");
        conv_factor         = sscanf(fgetl(raw_fid), "El = %fµV/AD");
        tmp_active_chans    = string(fgetl(raw_fid));
        active_channels     = split(sscanf(tmp_active_chans, "Streams = %s"),';');
        fgetl(raw_fid);
    
        rec_param = struct(... 
        'fs', sampling_freq,...
        'time_s', rec_duration_secs, ...
        'conv_f', conv_factor, ...
        'offset_ADC', zero_ADC, ...
        'active_chan', string(active_channels(2:end)), ...
        'nb_chan', length(active_channels)-1 ...
        );
    
        clear file_format session_start sampling_freq conv_factor active_channels

        fprintf(sprintf("[Loading] : %s\n", fname_no_ext));   % Display file selected
        [Signal] = rawshort2signal(raw_fid, rec_param);
        fclose(raw_fid);
    end