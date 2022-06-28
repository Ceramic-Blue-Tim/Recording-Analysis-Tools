%KMEANS k-means clustering
% 
%       labels = kmeans(A,k,n)
% 
% k-means clustering of data vectors in A. labels is a vector
% with cluster labels (1, .. , k) for each vector. n is the
% desired number of clustering attempts, starting from a
% random initialisation. The clustering with the smallest sum
% of within cluster distances is returned.
% Default: k = 2, n = 1.

% Copyright: R.P.W. Duin, duin@ph.tn.tudelft.nl
% Faculty of Applied Physics, Delft University of Technology
% P.O. Box 5046, 2600 GA Delft, The Netherlands

function I = kmeans(A,kmax,it)
if nargin == 1, kmax = 2; end
if nargin < 3, it = 1; end
[m,n] = size(A);
Jbest = inf;
for i = 1:it     % do for desired # of attempts
        k = kmax;                                       % reset number of clusters
  X = gauss(k,covm(A),mean(A));% get seeds for this attempt
  I2 = zeros(1,m);     % initialize clustering
  D = distm(A,X);                   % get distances between objects and seeds
  [E,I] = minc(D);     % find smallest distances and seeds
  while any(I ~= I2)     % do as long as clustering changes
     I2 = I;     % store previous clustering
     Z = max(expandd(I,k));     % find means actually used 
           for j=find(Z)                        % get new cluster means
        X(j,:) = meanc(A(I==j,:));
           end
           X(~Z,:) = [];                        % remove unused means
           k = sum(Z);                          % adjust number of clusters
     D = distm(A,X);                % get distances between objects and means
     [E,I] = minc(D);     % find smallest distances and clusters
  end
        J = 0;
        for j = 1:k                                     % use sum of mean within cluster distances
                J = J + mean(E(I==j));
        end
  if J < Jbest     % as a criterion; switch if better
     Ibest = I;     % store best clustering
     Jbest = J;     % store best criterion value
  end
end
I = setstr((Ibest+'0')');% return best clustering
return