%DISTM Distance matrix between two data sets.
% 
%       D = distm(A,B)
% 
% Computation of the distance matrix D between two sets of
% vectors A and B. Distances are computed as squared
% Euclidean.
% 
%       D = distm(A)

% Copyright: R.P.W. Duin, duin@ph.tn.tudelft.nl
% Faculty of Applied Physics, Delft University of Technology
% P.O. Box 5046, 2600 GA Delft, The Netherlands

function D = distm(A,B)
[ma,ka] = size(A);
global PRMEMORY
if (nargin == 1) 
        D = distm(A,A);
else
        [mb,kb] = size(B);
        if ka ~= kb, error('Matrices should have equal numbers of columns'); end
        D = - 2 .* B*A';
        if ~isempty(PRMEMORY)
                sa = sumsq(A');
                sb = sumsq(B');
                [loops,n1,n2] = prmem(mb,ma);
                for j = 1:loops
                        if j == loops, n = n2; else n = n1; end
                        nn = (j-1)*n1;
                        J = [nn+1:nn+n];
                        D(J,:) = D(J,:) + ones(n,1)*sa;
                        D(J,:) = D(J,:) + sb(J)'*ones(1,ma); 
                end
        else
                D = D + ones(mb,1)*sumc(A'.*A');
                D = D + sumc(B'.*B')'*ones(1,ma);
        end
end
J = find(D<0);
D(J) = zeros(size(J));
return