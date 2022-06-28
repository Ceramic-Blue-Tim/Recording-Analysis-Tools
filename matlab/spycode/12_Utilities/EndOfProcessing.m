function []=EndOfProcessing (start_folder, string)
% by Michela Chiappalone (6 Febbraio 2006)

% --------------> END OF PROCESSING
cd (start_folder)
cd ..
msgbox ( string,'End Of Session', 'warn')
