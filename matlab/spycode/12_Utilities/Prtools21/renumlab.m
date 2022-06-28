%RENUMLAB Renumber labels
% 
%       [nlab,lablist] = renumlab(slab)
% 
% The array of labels slab is converted and renumberred to a
% vector of numeric labels nlab. The conversion table lablist
% is such that slab = lablist(nlab,:). 
% slab can be a set of numeric row vectors or a set of strings.
% 
%       [nlab1,nlab2,lablist] = renumlab(slab1,slab2)
% 
% This combines two input arrays of labels slab1 and slab2
% into two numeric label vectors nlab1 and nlab2 with a shared
% conversion table lablist.

% Copyright: R.P.W. Duin, duin@ph.tn.tudelft.nl
% Faculty of Applied Physics, Delft University of Technology
% P.O. Box 5046, 2600 GA Delft, The Netherlands

function [nlab,nlab2,lablist] = renumlab(slab,slab2)
if nargin == 2
        [n1,m] = size(slab);
        [n2,m2] = size(slab2);
        if m~=m2
                error('Input strings should have equal length');
        end
        n = n1+n2;
        slab = [slab;slab2];
else
        [n,m] = size(slab);
end
p = 2.^[1:m];
nlab = zeros(n,1);
lablist = zeros(n,m);
i = 0;
while min(nlab) == 0
        i = i+1;
        t = slab(min(find(nlab==0)),:);
        I = find(slab*p' == t*p');
        nlab(I) = i*ones(size(I));
        lablist(i,:) = t;
end
lablist = lablist(1:i,:);
if isstr(slab), lablist = setstr(lablist); end
if nargin == 2
        nlab2 = nlab(n1+1:n1+n2);
        nlab = nlab(1:n1);
else
        nlab2 = lablist;
end
return