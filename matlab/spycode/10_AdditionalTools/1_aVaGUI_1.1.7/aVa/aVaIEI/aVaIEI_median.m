function median = aVaIEI_median(edges, distrib)
% created by Valentina Pasquale (February 2007)
% input:    distrib: IEI histogram norm (distribution)
% output:   median: median value

area = 0;
index = 0;
while area <= 0.5
    index = index + 1;
    area = area + distrib(index);
end
median = edges(index);