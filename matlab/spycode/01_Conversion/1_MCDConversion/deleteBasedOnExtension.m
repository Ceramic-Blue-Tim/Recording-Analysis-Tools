function deleteBasedOnExtension( ext,name )
%DELETEBASEDONEXTENSION Summary of this function goes here
%   the function delete the file whose name is given as parameter
%   if the file is a ".med" file, also the ".dat" file is deleted
if strcmp(ext,'mcd')
    delete(name);
elseif strcmp(ext,'med')
    medDatName=name;
    medDatName(end-3:end)='.dat';
    delete(name);
    delete(medDatName);
end