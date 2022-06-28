function [finalfig, histo]= plotprocesscorrelogram (cellarray, x, flag)

%plainarray= cell2mat(cellarray);
%[r,c]=size(plainarray);
[r,c]=size(cellarray);
histo=[];
scrsz = get(0,'ScreenSize');
finalfig=figure('Position',[1+100 scrsz(1) scrsz(3)/3 scrsz(4)-200]);

for i=1:c
    plainarray= cell2mat(cellarray(:,i));
    if (flag==1|flag==2)
        temp=nonzeros(plainarray);
    else
        temp=plainarray;
    end
    subplot(c,1,i)
    [n,xout] = hist(temp,x);
    %n(1)=0; % Clear the elemnts in the first bin: they are artifacts
    % hist(temp,x);
    bar(xout,n,1)
    set(gca,'FontSize', 6)
    
    if (flag==1) % C(0)
        axis([0 1 0 800])
        
    elseif (flag==2) % Coincidence index          
        axis([0 1 0 300]) % CI
        
    else % flag=3 Peak Position
        axis([x(1) x(end) 0 500])
    end
    
    ylabel('Freq', 'Fontsize', 8)
    if (i==c)
        if (flag==1) % C(0)
            xlabel('Correlation coefficient C(0)', 'Fontsize', 8)            
        elseif (flag==2) % CI           
            xlabel('Coincidence index', 'Fontsize', 8)
        else % flag=3 - Peak position
            xlabel('Correlation peak position (msec)')
        end
    end
    
    thisto=[n', xout'];
    histo=[histo,thisto];
    clear temp n xout thisto
end
