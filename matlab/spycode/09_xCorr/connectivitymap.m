function [h, r]= connectivitymap (C, Cdi0_table, threshold)
% by Michela Chiappalone (22 Giugno 2006)
% modified by Luca Leonardo Bologna (10 June 2007)
%   - in order to handle the 64 channels of MED64 Panasonic system

% -----------> VARIBALES DEFINITION
mcmea_electrodes = GlobalsParams.DEFAULT_ELECTRODES_LAYOUT;
x=[];
y=[];
xs=[];
ys=[];
h=[];

% for i=1:15 % Build the array for the coordinates of each electrode with respect to an 8x8 grid
%     C(i,:) = [floor(cluster(i,1)/10), (9-rem(cluster(i,1),10))];
% end
% C=[cluster, C];
cluster=C(:,1);


% -----------> PROCESSING PHASE
% Evaluate the connections only for the elements whose PSTH area is above a
% defined threshold
for i=1:15
    for j=1:15
        if (j~=i)&&(Cdi0_table(j,i)>=threshold)
            x = [x; C(j,2)]; % j-recording electrode x coordinate
            y = [y; C(j,3)]; % j-recording electrode y coordinate

            xs= [xs; C(i,2)]; % i-recording electrode x coordinate
            ys= [ys; C(i,3)]; % i-recording electrode y coordinate
        end
    end
end


% -----------> PLOT PHASE: Plot the dark lines for the above-threshold connections
xfull=[x xs]; % X coordinates
yfull=[y ys]; % Y coordinates
[r,c]=size(xfull);
if (r>0)
    h=figure;
    for i=1:r
        h= line(xfull(i,:), yfull(i,:),'Color','k', 'LineWidth', 2); % set (h,'Color',[0 0 0]);
        hold on
    end
    axis image
    grid on
    box on
    set(gca, 'TickLength', [0 0], 'XAxisLocation', 'top');

    switch cluster(1)
        case 12 % ClusterA
            xlim([0 5])
            ylim([4 9])
            % set(gca,'ytick',(5:8),'YTickLabel',{'4', '3', '2', '1'}, 'xtick',(1:4),'XTickLabel',{'1', '2', '3', '4'});
            set(gca,'ytick',(5:8), 'YTickLabel',{[]}, 'xtick',(1:4), 'XTickLabel',{[]});
        case 51 % ClusterB
            xlim([4 9])
            ylim([4 9])
            % set(gca,'ytick',(5:8),'YTickLabel',{'4', '3', '2', '1'}, 'xtick',(5:8),'XTickLabel',{'5', '6', '7', '8'});
            set(gca,'ytick',(5:8), 'YTickLabel',{[]}, 'xtick',(5:8), 'XTickLabel',{[]});
        case 55 % ClusterC
            xlim([4 9])
            ylim([0 5])
            % set(gca,'ytick',(1:4),'YTickLabel',{'1', '2', '3', '4'}, 'xtick',(5:8),'XTickLabel',{'5', '6', '7', '8'});
            set(gca,'ytick',(1:4), 'YTickLabel',{[]}, 'xtick',(5:8), 'XTickLabel',{[]});
        case 15 % ClusterD
            xlim([0 5])
            ylim([0 5])
            % set(gca,'ytick',(1:4),'YTickLabel',{'4', '3', '2', '1'}, 'xtick',(1:4),'XTickLabel',{'5', '6', '7', '8'});
            set(gca,'ytick',(1:4), 'YTickLabel',{[]}, 'xtick',(1:4), 'XTickLabel',{[]});
    end

    % -----------> PLOT PHASE: Plot the spot indicating the electrodes of the array
    for i=1:15
        %plot(C(i,2), C(i,3), '.b', 'MarkerSize', 30, 'LineWidth', 4)
        text(C(i,2)-0.1, C(i,3), num2str(C(i)), ...
            'EdgeColor','blue', 'BackgroundColor','white', 'FontWeight', 'bold')
        hold on
    end

end
