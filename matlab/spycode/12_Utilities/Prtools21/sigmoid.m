%SIGMOID Sigmoid function
% 
%       Y = sigmoid(X)
% 
% Compute sigmoid function values of input matrix X
% 
%       Y = sigmoid(X,w)
% 
% Compute sigmoid function values of [m,k] matrix X weighted
% by [k+1,n] weight matrix w. Each row input vector in X with
% size k is weighted by each column weight vector in w,
% treating the last item as constant term.

% Copyright: R.P.W. Duin, duin@ph.tn.tudelft.nl
% Faculty of Applied Physics, Delft University of Technology
% P.O. Box 5046, 2600 GA Delft, The Netherlands

function Y = sigmoid(X,W)
if nargin == 1
        Y = 1./(1+exp(-X));
else
        [m,k] = size(X);
        [k1,n] = size(W);
        if k1~=k+1
                error('Data sizes do not match');
        end
        Y = [X,ones(m,1)]*W;
        Y = 1./(1+exp(-Y));
end
return

