%PRODC True product of columns
% 
%       Y = prodc(X)
% 
% Y is a row vector containing the product of the elements of
% the columns of X. For row vectors X is copied into Y.

% Copyright: R.P.W. Duin, duin@ph.tn.tudelft.nl
% Faculty of Applied Physics, Delft University of Technology
% P.O. Box 5046, 2600 GA Delft, The Netherlands

function Y = prodc(X)
[m,n] = size(X);
if m == 1
        Y = X;
else
        Y = prod(X);
end
return