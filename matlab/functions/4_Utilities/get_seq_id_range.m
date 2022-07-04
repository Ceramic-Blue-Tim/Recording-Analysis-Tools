function [id_start, id_stop] = get_seq_id_range(fs, sequence, rec_len)
    % Declare variables
    cnt_read_samples   = 0;
    id_start            = zeros(sequence.nb,1);
    id_stop             = zeros(sequence.nb,1);

    for i = 1:sequence.nb
        % For last sequence
        if i == sequence.nb
            % Remain samples > required samples : read nb_required
            if (rec_len - cnt_read_samples) > (sequence.duration_s(i)*fs)
                nb_samples_to_read  = sequence.duration_s(i) * fs;
            % Remain samples < required samples : read nb_remaining (truncate)
            else
                nb_samples_to_read  = rec_len - cnt_read_samples;
            end
        % For other sequence
        else
            nb_samples_to_read  = sequence.duration_s(i) * fs; % Read samples
        end

        % Generate sample id range
            id_start(i)    = (cnt_read_samples+1);
            id_stop(i)     = cnt_read_samples + nb_samples_to_read;

        % Update number of samples read
        cnt_read_samples = id_stop(i);
    end
end