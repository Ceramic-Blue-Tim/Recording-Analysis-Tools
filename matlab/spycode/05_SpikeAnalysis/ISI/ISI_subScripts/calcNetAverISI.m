% calcNetAverISI.m
% by Valentina Pasquale, April 2008
% It averages the ISI histograms of all channels and outputs a single
% network averaged ISI histogram
% ARGUMENTS:
% x: cell array of x-data (bins)
% y: cell array of y-data (hist)
% OUTPUT:
% binsAver: x-data for Network Average ISI histogram
% ISIhistAver: Network Average ISI histogram
function [binsAver,ISIhistAver] = calcNetAverISI(x, y)
if length(x) ~= length(y)
    errordlg('Cell arrays of XData and YData do not have the same length!', '!!Error!!', 'modal');
    return
end
nHist = length(x);              % number of present histograms
l = cellfun('length',x);        % lengths of histograms
[maxl,indMaxl] = max(l);        % find the longest
binsAver = x{indMaxl,1};        % consider the x-data of the longest histogram
ISIhist = zeros(maxl,nHist);
for i = 1:nHist
    if l(i) > 0
        if(l(i)==length(y{i,1}))
            ISIhist(1:l(i),i) = y{i,1};
        else
            disp('error')
        end
    end
end
ISIhistAver = mean(ISIhist,2);  % average histograms