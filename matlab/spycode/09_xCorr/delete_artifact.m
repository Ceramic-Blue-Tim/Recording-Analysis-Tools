% DELETE_ARTIFACT.m
% by MIchela Chiappalone

% NOTE: no error check!!!


function [y]= delete_artifact (x, art_train, cwin)

% INPUT
%         x         = sequence of spikes
%         art_train = positions of the artifacts
%         cwin      = blanking window, for eliminating the contribution of the artifact

% OUTPUT
%         y         = sequence of spikes after the blanking

for i=1:length(art_train)
    x(art_train(i):(art_train(i)+cwin-1))= zeros(cwin,1);                
end
y=x;

return