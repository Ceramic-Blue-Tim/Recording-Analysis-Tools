function [h, r]= connectivitymap_NOclu (C, Cdi0_table, threshold)
% by Michela Chiappalone (22 Giugno 2006)

% -----------> VARIBALES DEFINITION
mcmea_electrodes = GlobalsParams.DEFAULT_ELECTRODES_LAYOUT;
x=[];
y=[];
xs=[];
ys=[];
h=[];

cluster=C(:,1);


% -----------> PROCESSING PHASE
% Evaluate the connections only for the elements whose PSTH area is above a
% defined threshold
for i=1:60
    for j=1:60
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
    xlim([0 9])
    ylim([0 9])
    set(gca,'ytick',(1:8), 'YTickLabel',{[]}, 'xtick',(1:8), 'XTickLabel',{[]});

    % -----------> PLOT PHASE: Plot the spot indicating the electrodes of the array
    for i=1:60
        %plot(C(i,2), C(i,3), '.b', 'MarkerSize', 30, 'LineWidth', 4)
        text(C(i,2)-0.1, C(i,3), num2str(C(i)), ...
            'EdgeColor','blue', 'BackgroundColor','white', 'FontWeight', 'bold')
        hold on
    end
end
