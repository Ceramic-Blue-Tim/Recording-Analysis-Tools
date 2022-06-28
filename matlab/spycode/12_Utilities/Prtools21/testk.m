%TESTK Error estimation of K-NN rule
% 
%       e = testk(A,labels,k,T,labelsT)
% 
% Tests a set of objects T on the labeled training set A using
% the k-NN rule and returns the classification error e. If no
% labels given for T the fraction not assigned to class 1 is
% returned.
% 
%       e = testk(A,labels,k)
% 
% returns the leave-one-out error estimate. Default k = 1.
% 
% The global PRMEMORY is read for the maximum size of the
% internally declared matrix, default inf.
% 
% The advantages of the use of testk over testd are that it
% has less overhead and that it enables the leave-one-out
% error estimation
%
% See also knnc, classd, testd

% Copyright: R.P.W. Duin, duin@ph.tn.tudelft.nl
% Faculty of Applied Physics, Delft University of Technology
% P.O. Box 5046, 2600 GA Delft, The Netherlands

function e = testk(a,lab,knn,t,labt)
[nlab,lablist,m,k,c] = clinit(a,lab);
if nargin == 2
        d = classk(a,lab); [dmax,J] = maxc(d');
        e = nstrcmp(lablist(J,:),lab) / m;
        return
elseif nargin == 3
        d = classk(a,lab,knn); [dmax,J] = maxc(d');
        e = nstrcmp(lablist(J,:),lab) / m;
        return
elseif nargin == 4
        [n,kt] = size(t);
        lablistt = lablist;
        nlabt = nlab(ones(1,n),:);
elseif nargin == 5
        [nlabt,lablistt,n,kt,ct] = clinit(t,labt);
else
        error('Wrong number of arguments')
end
if k ~= kt 
        error('Data sizes do not match');
end
d = classk(a,lab,knn,t); [dmax,J] = maxc(d');
e = nstrcmp(lablist(J),labt) / n;
return