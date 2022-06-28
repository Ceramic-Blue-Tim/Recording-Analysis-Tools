function [d, m] = aVaIEI_diff(data)
% created by Valentina Pasquale (January 2007)
% input:    data: a matrix whose first column contains the spikes' time stamps
%                 and the second one the number of spikes recorded at that time
% output:   outData: contains the values of diff of the first column of data, weighted by the second column of data  
d = zeros(size(data,1)-1,1);
m = zeros(size(data,1)-1,1);
d = diff(data(:,1));
temp = data(:,2)*data(:,2)';
m = diag(temp,1);


