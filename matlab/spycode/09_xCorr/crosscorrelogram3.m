function [rnorm]= crosscorrelogram3 (input_train, output_train, wsample, binsample, fs, normid)
%
%     input_train  = X-peak train;
%     output_train = Y-peak train;
%     wsample      = length of the correlation window [samples]
%     binsample    = bin [samples]
%     fs           = sampling frequency [samples/sec]
%     normid       = normalization procedure

% by Michela Chiappalone (6 Maggio 2005, 16 Febbraio 2007)
% modified by Luca Leonardo Bologna (14 December 2006)
% modified by PL Baljon (7 january 2008) - Include C module for correlation

peak_input=find(input_train);
peak_output=find(output_train);
npeak_input=length(peak_input);
npeak_output=length(peak_output);
if length(peak_output)==1
    peak_output=[peak_output;inf]; % Why?
end
if ~rem(binsample,2)
    binsample=binsample+1; % redundant in C module, PL'07
end
ceiledNumBin = ceil((wsample - .5*(binsample-1))/binsample); % in C module: floor(...).
wsample      = (binsample-1)/2 + (ceiledNumBin * binsample);
rnorm        = zeros(1 + 2 * ceiledNumBin,1);
% flooredHalfStep=floor(binsample/2);
% absEdge=ceiledNumBin*binsample;
% xSamples=-flooredHalfStep-absEdge:binsample:flooredHalfStep+1+absEdge;
% rnorm=zeros(length(xSamples)-1,1); % Correlogram vector

if ~isempty(peak_output)&& ~isempty(peak_input)
%       if (npeak_input*fs/length(input_train)>0.2) % Useful if you don't use the classical normalization method
%         repInputPeak=repmat(peak_input,[1 length(xSamples)]);
%         temp=repmat(xSamples,[length(peak_input) 1]);
%         repInputPeak=repInputPeak+temp;
%         clear temp
%         for i=1:npeak_input
%             compCount=histc(peak_output,repInputPeak(i,:));
%             rnorm=rnorm+compCount(1:end-1);
%         end

        rnorm = c_corr(peak_input,...
                       peak_output,...
                       binsample,...
                       wsample);
    
        % Normalization Phase
        % Why are the '/' used instead of './'?
        if (normid==1)
            rnorm=rnorm/sqrt(npeak_input*npeak_output); % Normalization by the product of X and Y spikes (classical)
        elseif (normid==2)
            rnorm =rnorm/(npeak_input); % Normalization by the number of spikes in X (Knox, Eytan)
        else % normid =3
            rnorm =rnorm/(npeak_output); % Normalization by the number of spikes in Y
        end
        
        clear peak_input peak_output temp repInputPeak compCount
        % pause(0.2);
    % end
end

return