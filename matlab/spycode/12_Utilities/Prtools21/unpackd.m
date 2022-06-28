%UNPACKD Unpack data
%
%   [p1,p2,....] = unpackd(A)
%
% Retrieves the variabels stored in A by packd.
% If A is not packed in this way it is directly returned in p1.
%
% See also: packd

% Copyright: R.P.W. Duin, duin@ph.tn.tudelft.nl
% Faculty of Applied Physics, Delft University of Technology
% P.O. Box 5046, 2600 GA Delft, The Netherlands

function [A,p2,p3,p4,p5,p6,p7,p8,p9] = unpackd(A)
p2 = []; p3 = []; p4 = []; p5 = [];
p6 = []; p7 = []; p8 = []; p9 = [];
if max(size(A)) <= 1, return; end
if min(size(A)) ~= 1 | A(2) ~= 0.1234321
        return   % make transparant in case of no packed variable
end
k = A(3)*3+4;
for i = 1:min([nargout,A(3)])
        pi = ['p' num2str(i)];
        m = A(3*i+1); n = A(3*i+2); str = A(3*i+3);
        if i > 1
                eval([pi '= reshape(A(k:k+m*n-1),m,n);']);
                if str, eval([pi '=setstr(' pi ');']); end
        end
        k = k + m*n;
end     % all this is necessary in order to achieve the transparant option
k = A(3)*3+4;
m = A(4);
n = A(5);
str = A(6);
A = reshape(A(k:k+m*n-1),m,n);
if str, A = setstr(A); end
return