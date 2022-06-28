function savenonzeros_ascii(var, filename)
% Save the content of a cell array as ascii file, divided in a number of
% files equal to the number of exp phases and without the zero elements

[r,c]=size(var);
% c gives me the number of exp phases
for i=1:c
    mat_array=cell2mat(var(:,i));
    nnzvar=nonzeros(mat_array);
    
    nome= strcat(filename, '_', num2str(i), '.txt');
    save (nome, 'nnzvar', '-ASCII')    
end
