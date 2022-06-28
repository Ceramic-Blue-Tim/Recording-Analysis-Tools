% MEA60_lookuptable.m
% by Valentina Pasquale, 2008-03-10
% Returns a matrix that contains: 
% first column = subplot index (8x8 layout)
% second column = 11:88 (excluded 11,18,81,88)
function m = MEA60_lookuptable()
MEA60_elec = [(11:18)'; (21:28)'; (31:38)'; (41:48)'; (51:58)'; (61:68)'; (71:78)';(81:88)'];
MEA60_elecReshape = (reshape(MEA60_elec,8,8))';
MEA60_elec2 = MEA60_elecReshape(:);
n = (1:64)';
m = [n MEA60_elec2];
[MEA60_sort, indMEA60_sort] = sort(MEA60_elec2);
m = m(indMEA60_sort,:);
m = m(~(m(:,2) == 11 | m(:,2) == 18 | m(:,2) == 81 | m(:,2) == 88),:);