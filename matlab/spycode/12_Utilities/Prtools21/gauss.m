%GAUSS Generation of multivariate Gaussian data.
% 
%       X = gauss(n,G,u)
%       X = gauss(n,u,G)
% 
% Generation of n k-dimensional Gaussian distributed vectors
% with covariance matrix G (size k*k) and with mean u (size
% 1*k).
% 
%       X = gauss(n,u)
% 
% Generation of n k-dimensional Gaussian distributed vectors
% with identity covariance matrix and with mean u.
% 
%       X = gauss(n,G)
% 
% Generation of n k-dimensional Gaussian distributed vectors
% with covariance matrix G and with mean 0.
% 
%       X = gauss(n)
% 
% Generation of n 1-dimensional Gaussian distributed points
% with mean 0 and variance 1.

% Copyright: R.P.W. Duin, duin@ph.tn.tudelft.nl
% Faculty of Applied Physics, Delft University of Technology
% P.O. Box 5046, 2600 GA Delft, The Netherlands

function X = gauss(p1,p2,p3)
if nargin == 3
        [m,n] = size(p3);
        if m == n & m > 1
                G = p3; u = p2; n = p1; k = m;
        elseif m == 1 | n == 1
                G = p2; u = p3; n = p1; k = length(u);
        else
                error('Data sizes do not match')
        end
elseif nargin == 2
        [m,n] = size(p2);
        if m == n & m > 1
                G = p2; k = m; u = zeros(1,k); n = p1;
        elseif m == 1 | n == 1
                u = p2; k = length(u); G = eye(k); n = p1;
        else
                error('Data sizes do not match')
        end
elseif nargin == 1
        [m,n] = size(p1);
        if m == 1 & n == 1
                n = p1; u = 0; G = 1; k = 1;
        elseif m == 1 | n == 1
                n = 1; u = p1; k = length(p1); G = eye(k);
        elseif m == n
                G = p1; k = m; u = zeros(1,k); n = 1;
        else
                error('Data sizes do not match')
        end
else
        error('Data sizes do not match')
end
[k1,k2] = size(G);
if n < 1
        error('Illegal number of vectors requested')
elseif any([length(u),k1,k2] ~= k)
        error('Data sizes do not match')
end
[V D] = eig(G);
V = real(V);
D = real(D);
X = randn(n,k)*sqrt(D)*V' + ones(n,1) * reshape(u,1,k);
return