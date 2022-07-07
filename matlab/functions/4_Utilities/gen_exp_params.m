% @title      Generate experiments parameters information file
% @file       gen_exp_params.m
% @author     Romain Beaubois
% @date       05 Jul 2022
% @copyright
% SPDX-FileCopyrightText: © 2022 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Generate experiments parameters information file
% 
% @details
% > **05 Jul 2022** : file creation (RB)

function gen_exp_params(dir_path, exp_name, label, duration_s, el_list, stim_width)
    sequence = struct(...
        'label', label, ...
        'duration_s', duration_s, ...
        'nb', length(label) ...
    );

    stim = struct(...
        'electrodes',               el_list.stim, ...
        'electrodes_no_stim_close', el.no_stim_close, ...
        'electrodes_no_stim_far',   el.no_stim_far, ...
        'width',                    stim_width, ...
        'tstamp',                   [] ...
    );

    % Fetch stimulation time stamp if availables
    fprintf("[Loading] : Stimulation time stamps experiment %s\n", exp_name);
    [parent_dir_path]   = fileparts(dir_path);
    fpath_stim_tstamp   = fullfile(parent_dir_path, 'stim_tstamp', exp_name+".csv");
    if isfile(fpath_stim_tstamp)
        tstamp              = tstamp2array(fpath_stim_tstamp);
        stim.tstamp         = tstamp;
    else
        warning("Stimulation time stamp file not found for experiment %s", exp_name);
    end


    % Save information file in the same folder as *.bin file
    save(fullfile(dir_path, exp_name + ".mat"), 'sequence', 'stim');
    fprintf("[Saved] : Sequence information experiment %s\n", exp_name);
end