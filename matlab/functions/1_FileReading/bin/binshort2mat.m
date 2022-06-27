% @title      Convert binary file (short format) to matlab format .mat
% @file       binshort2mat.m
% @author     Tatsuya Osaki, Romain Beaubois
% @date       06 Jul 2021
% @copyright
% SPDX-FileCopyrightText: © 2020 Tatsuya Osaki <osaki@iis.u-tokyo.ac.jp>
% SPDX-FileCopyrightText: © 2021 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: MIT
%
% @brief Convert binary file (short format) to matlab format .mat
% 
% @details
% > **19 Jun 2020** : file creation (TO)
% > **06 Jul 2021** : add bin recordings parameters fetching from hdr file (RB)
% > **27 Jun 2022** : rearrange file to save in compatible format with Spycode (RB)

function binshort2mat(bin_filename, rec_duration_secs, save_param)

    [~, Signal, fname_no_ext, rec_param] = read_bin(bin_filename, rec_duration_secs);

    for i = 1:rec_param.nb_chan
        fpath           = sprintf("%s%s%s_%d.mat", save_param.path, filesep, fname_no_ext, i);
        data            = Signal(:, i);
        save(fpath, 'data');
    end
end