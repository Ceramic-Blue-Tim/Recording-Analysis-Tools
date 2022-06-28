%PRMEM Size of memory and loops for intermediate results
%
%       [loops,rows,last] = prmem(m,k)
%
% The numbers of loops and rows are determined that are needed
% if in total an intermediate array of m*k is needed such that
% rows*k < PRMEMORY. The final number of rows for the last loop
% is returned in last.

% Copyright: R.P.W. Duin, duin@ph.tn.tudelft.nl
% Faculty of Applied Physics, Delft University of Technology
% P.O. Box 5046, 2600 GA Delft, The Netherlands

function [loops,n,n1] = prmem(m,k)
global PRMEMORY;
if isempty(PRMEMORY)
        mem = inf;
else
        mem = PRMEMORY;
end
n     = min([floor(mem/k),m]);
if n == 0
        error('PRMEMORY too small for given data size');
end
loops = ceil(m/n);   
n1 = m - (loops-1)*n; 