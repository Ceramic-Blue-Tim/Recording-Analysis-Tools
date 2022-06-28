function mm = calcIEImean(IEIresults)
m = [];
% ind = [];
for ii = 1:length(IEIresults)
    m = [m; IEIresults{ii,1}.mean];
%     for j = 1:length(IEIresults{ii,1}.histogram)-1
%             area = sum(IEIresults{ii,1}.histogram(1:j+1));
%         if area >= 0.99
%             ind(ii) = j;
%             % m = mean(IEIresults{ii,1}.histogram(1:ind(ii)));
%             break
%         end
%     end
end
mm = mean(m);
% indms = (ind*0.1)';
% mean(indms)