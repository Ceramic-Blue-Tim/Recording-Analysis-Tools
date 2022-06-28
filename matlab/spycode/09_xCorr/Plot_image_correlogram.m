% Plot_image_correlogram.m
% by Michela Chiappalone (22 Giugno 2006)
function [Cdi0]= computeCdi0cluster(cluster)

r_cluster=r_table(cluster,1);
x=length(r_cluster{1,1});
ccA = reshape (cell2mat(r_cluster), x, 15)';
center=median(1:x);
ccA_peak=ccA(:, center-1:center+1);
Cdi0=sum(cca_peak, 2);

