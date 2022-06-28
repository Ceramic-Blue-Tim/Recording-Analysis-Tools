function varargout = CONV_nbt_data(peak_folder)
% S: n x 2 matrix, with rows [ #channel tspike ].
% LastSpikeTiming: time (in samples) of last spike
%
%    ELEC_COLUMN = 1;
%    TIME_COLUMN = 2;
%
% For conversion of NBT data, the electrode number should be in the
% (end-5:end-4) characters of the file name. It assumes that the data is in
% the variable peak_train, as a sparse array, already in samples, rather
% than milliseconds.
% ARTEFACT_BLANK removes the 4 ms (=40 samples) after stimulation. If
% there was stimulation, the stimulus time stamps should be in the variable
% artifact.
%
% PL Baljon, November 2007
%
% v1.1 29/01/08 if artifact does not exist, an empty array is made.

ARTEFACT_BLANK = 0;
artifact       = []; % if in .mat file, it is overwritten. if not it is default.

    S = zeros(0,2);
    all_files = dir(peak_folder);
    for f = 3:size(all_files,1)
        load(fullfile(peak_folder,all_files(f).name));
        
        if(exist('all_artifact','var')==1)
            artifact = all_artifact;
        end
        artifact = artifact(artifact > 0);
        if(~isempty(artifact))
            peak_train( (artifact * ones(1,ARTEFACT_BLANK+1)) + (ones(size(artifact,1),1)*(0:ARTEFACT_BLANK)) ) = 0;
        end
        el = str2double(all_files(f).name(end-5:end-4));
        s  = find(peak_train) * 1; % do conversion from ms to samples. in NBT data already in samples.
        S  = vertcat(S,[el.*ones(size(s,1),1) s]);
    end
    S          = sortrows(S,2);
    last_spike = max(S(:,2));
    
    switch(nargout)
        case 1
            varargout = {S};
        case 2
            varargout = {S last_spike};
        case 3
            if(exist('artifact','var')==1)
                varargout = {S last_spike artifact};
            else
                varargout = {S last_spike []};
            end
    end
end