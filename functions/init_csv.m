 function [Signal_comp]=init_csv(num_electrode)
% mkdir Analyzing_data
currentFolder = pwd;
MyFolderInfo = dir; 
%% csv reading

list_csv = ls('*.csv');
csv_file_number=size(list_csv, 1);

ini_formart='%f%'
number='f%';
nr='[^\n\r]';

for i=1:num_electrode
    ini_formart=strcat(ini_formart, number);
%     f_char=char(f_array);
    
end
formatSpec=strcat(ini_formart, nr);

if 1 <= csv_file_number
     for i=1:csv_file_number
           disp ('loding');
           disp (list_csv(i, :));
           
          csv_filename=[currentFolder, '\', list_csv(i, :)];
          delimiter = ',';
          startRow = 4;
         
          fileID = fopen(csv_filename,'r');
          textscan(fileID, '%[^\n\r]', startRow-1, 'WhiteSpace', '', 'ReturnOnError', false, 'EndOfLine', '\r\n');
          dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'ReturnOnError', false);
          fclose(fileID);
          Signal = [dataArray{1:end-1}];
          clearvars  filename delimiter startRow fileID dataArray ans;
          
         Signal_comp{i, 1}=Signal;
         Signal_comp{i, 2}=list_csv(i, :);
     end
else
     
    disp ('OK')
end



 end