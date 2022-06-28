function [peak_train]= delartcontr (peak_train, artifact, cancwinsample)
% DELete ARTifact CONTRibution
% INPUT
%      peak_train = vector for peak position and amplitude
%      artifact   = vector containing artifact position
%      cancwinsample = blanking window after artifact [sample]
% OUTPUT
%      peak_train = vector without artifact contribution

% by Michela Chiappalone (13 Marzo 2006)

for a=1:length(artifact) % delete the artifact contribution
    if (artifact(a)~=0)
        peak_train(artifact(a):(artifact(a)+cancwinsample-1))= zeros(cancwinsample,1);
    end
end
