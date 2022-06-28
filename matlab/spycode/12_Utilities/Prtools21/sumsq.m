%SUMSQ Compute sum of squares in memory saving mode
%
%       S = sumsq(A)
%
% If A is a matrix S = sum(A.*A) avoiding the construction
% of intermediate matrices larger than PRMEMORY

% Copyright: R.P.W. Duin, duin@ph.tn.tudelft.nl
% Faculty of Applied Physics, Delft University of Technology
% P.O. Box 5046, 2600 GA Delft, The Netherlands

function s = sumsq(a);
[m,k] = size(a);
[loops,n0,n1] = prmem(m,k);
s = zeros(1,k);
for j = 1:loops
        if j == loops, n=n1; else n= n0; end
        nn = (j-1)*n0;
        J = [nn+1:nn+n];
        s = s + sumc(a(J,:).*a(J,:));
end


