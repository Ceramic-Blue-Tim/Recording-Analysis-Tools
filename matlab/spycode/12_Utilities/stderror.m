
function [boundary] = stderror (mu, x)
% Function that takes in INPUT an array for calculate the se value with
% respect to the mu value (it can be the mean value, the median value or whatever)
% Boundary is the resulting value that will be used as upper and lower
% threshold
%
boundary = sqrt(sum((x-mu).^2)/length(x))/sqrt(length(x));