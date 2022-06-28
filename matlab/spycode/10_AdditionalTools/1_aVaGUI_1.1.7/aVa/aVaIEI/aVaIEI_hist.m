function hist = aVaIEI_hist(ieiData, ieiMultipl, edges)
% created by Valentina Pasquale (January 2007)
% input:    data: a matrix whose first column contains the IEI values
%                 [samples] and the second one their multiplicity
% output:   hist: IEI histogram

for i = 1:max(size(edges))-1
     ind = find(ieiData >= edges(i) & ieiData < edges(i+1));
     hist(i) = sum(ieiMultipl(ind));
end
hist(max(size(edges))) = sum(ieiMultipl(find(ieiData == edges(end))));
hist = hist';       % a column vector
