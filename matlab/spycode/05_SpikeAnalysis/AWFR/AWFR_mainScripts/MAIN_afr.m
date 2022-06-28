% MAIN_afr
% It computes the Average Firing Rate based on the point process analysis

[start_folder] = selectfolder('Select the source folder containing PeakDetectionMAT files');

if isempty(start_folder)
    return
else

    % ---------------------> INPUT VARIABLES
    [bin_s, mfr_thresh, cancwin, fs, cancelFlag] = uigetAFRinfo();

    if cancelFlag
        return
    else
        AFR_computation (start_folder, bin_s, mfr_thresh, cancwin,fs)
        
        % -------------------------- END OF PROCESSING
        EndOfProcessing (start_folder, 'Successfully accomplished');
    end
end
clear all