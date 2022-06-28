function append_peak_train
% This function want to create a single data stream from different
% recording. To do that, it is necessary to load several files and the
% final output will be the complete recording file.

% Function ---> UIGETFILES
% The selected files are returned to FILENAMES as a cell array of strings. 
% The directory containing these files is returned to PATHNAME as a string.
[filenames, pathname] = uigetfiles( '*.mat', 'Select the files to append');
cd(pathname)
default=pathname((length(pathname)-18):(length(pathname)-1));

full_peak_train=[];

for i=1:length(filenames)
    load (filenames{1,i}) % now the variable peak_train is loaded
    full_peak_train=[full_peak_train; peak_train];
    clear peak_train
end

peak_train= round(full_peak_train/10);
clear full_peak_train pathname filenames

% Function ---> UIPUTFILES
[filename, pathname] = uiputfile( default, 'Save file as');
cd(pathname)
save(filename, 'peak_train');
