%CLINIT Classifier initialisation routine
% 
%       [nlab,lablist,m,k,c,p] = clinit(A,lab,labprob)
%
% The labels and dimensions of the dataset (a,lab,labprob) are 
% retrieved and checked. A should be a set of feature vectors
% stored in its rows. Their labels (strings) have to be stored
% into the rows of lab. The class apriori probabilities should be
% supplied in the packed variable labprob = packd(prob,classlist).
% In the rows of classlist the labels of all classes should be
% given. In the corresponding elements of the vector prob the
% apriori probabilities of the classes have to be listed such
% that sum(prob) = 1. It is possible that in labprob more classes
% are defined then available in (A,lab). If labprop=0 or if
% prob=0 equal class probabilities are assumed. If labprob = []
% or if prob =[], the apriori probabilities are set equal to the
% class frequencies in A,lab.
%
% This routines returns the following items:
%   lablist: A subset of classlist containing all string labels
%            available in lab.
%   nlab:  : An integer vector such that lab=lablist(nlab).
%   m      : Number of feature vectors (rows) in A.
%            This is also the number of rows in lab and nlab.
%   k      : Number of features (columns) in A.
%   c      : Number of classes actually present in A,lab.
%            This is also the maximum in nlab, the number of
%            rows in lablist and the length of p.
%   p      : vector with normalised apriori probabilities 
%            for the classes defined in lablist. sum(p) = 1.

% Copyright: R.P.W. Duin, duin@ph.tn.tudelft.nl
% Faculty of Applied Physics, Delft University of Technology
% P.O. Box 5046, 2600 GA Delft, The Netherlands

function [nlab,lablist,m,k,c,p] = clinit(a,lab,labprob)
[m,k] = size(a);
%if ~isstr(lab)
%       error('Labels should be string variables')
%end
[ms,s] = size(lab);
if ms ~= m
        error('Number of labels should be equal to number of feature vectors')
end
if nargin == 2, labprob = []; end
if isempty(labprob)
        [nlab,lablist] = renumlab(lab);
        [lb,J] = sort(lablist(:,1));
        [M,JJ] = sort(J);
        nlab = JJ(nlab);
        lablist = lablist(J,:);
        [c,cs] = size(lablist);
        p = sum(expandd(nlab,c))'/m;
elseif labprob == 0
        [nlab,lablist] = renumlab(lab);
        [c,cs] = size(lablist);
        p = ones(c,1)/c;
else
        [nlab,lablist1] = renumlab(lab);
        [c,cs] = size(lablist1);
        [prob,classlist] = unpackd(labprob);
        if isempty(classlist)           % set default labels
                classlist = [1:c]';
        end
%       if ~isstr(classlist)
%               error('No propper classlist packed in labprob');
%       end
        [cs,ss] = size(classlist);
        prob = prob(:);
        ps = length(prob(:));
        if ps == 1
                prob = [prob(1), ones(1,cs-1)*((1-prob(1))/(cs-1))]';
                ps = cs;
        end
        if ps~=cs
                error('Sizes of classlist and apriori probabilities do not match');
        end
        if abs(1-sum(prob)) > 0.001
                error('Apriori probabilities should add up to one')
        end
        [nlab1,nlab2,lablist] = renumlab(classlist,lablist1);
        nlab = nlab2(nlab);
        [c2,s2] = size(lablist);
        if c2 > cs
                error('Some labels are for undefined classes');
        end
        p = prob / sum(prob);
end
return