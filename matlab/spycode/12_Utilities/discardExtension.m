function [ output_args ] = discardExtension( input_args )
%DISCARDEXTENSION discard extension from a filename (if any)

dotIdxs=find(input_args=='.');
if ~isempty(dotIdxs)
    output_args = input_args(1:dotIdxs(end)-1);
end
