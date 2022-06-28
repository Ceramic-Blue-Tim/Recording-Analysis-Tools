%MINC Minimum of colummns
% 
%       [Y,I] = minc(X)
% 
% Y is a row vector containing the minimum of the elements of
% the columns of X. For row vectors X is copied into Y.

% Copyright: R.P.W. Duin, duin@ph.tn.tudelft.nl
% Faculty of Applied Physics, Delft University of Technology
% P.O. Box 5046, 2600 GA Delft, The Netherlands

function [Y,I] = minc(X)
[m,n] = size(X);
if m == 1
        Y = X;
        I = ones(1,n);
else
        [Y,I] = min(X);
end
return