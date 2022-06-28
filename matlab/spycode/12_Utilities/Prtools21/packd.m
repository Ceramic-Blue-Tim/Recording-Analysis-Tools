%PACKD Pack data
%
%   A = packd(p1,p2,...)
%
% Pack a set of variables into a single one. Unpacking can be
% done by unpackd. In A(1) the length of A is stored, which may
% be used for unpacking a collection of packed variables:
% [A1 A2 ...].
%
% See also unpackd

% Copyright: R.P.W. Duin, duin@ph.tn.tudelft.nl
% Faculty of Applied Physics, Delft University of Technology
% P.O. Box 5046, 2600 GA Delft, The Netherlands

function A = packd(p1,p2,p3,p4,p5,p6,p7,p8,p9)
if nargin > 9
 error('Not more than 9 variables can be stored')
end
A = [];
B = [];
for i = 1:9
  if nargin >= i
           pi = ['p' num2str(i)];
           if eval(['isstr(' pi ')'])
                        eval(['A = [A abs(' pi '(:)'')];']);
                else
                        eval(['A = [A ' pi '(:)''];']);
           end
           eval(['B = [B size(' pi ') isstr(' pi ')];']);
        end
end
A = [length([B A])+3 0.1234321 nargin B A];
return