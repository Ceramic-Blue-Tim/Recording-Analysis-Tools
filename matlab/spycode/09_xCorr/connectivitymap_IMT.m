function [h, r]= connectivitymap_IMT (C, Cdi0_table, threshold)
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
    xlim([0 12])
    ylim([0 10])
    set(gca,'ytick',(1:10), 'YTickLabel',{[]}, 'xtick',(1:12), 'XTickLabel',{[]});

    % -----------> PLOT PHASE: Plot the spot indicating the electrodes of the array
    for i=1:60
        electrode=mcmea_electrodes(i);
        if ((electrode==22)||(electrode==33)||(electrode==27)||(electrode==28)||(electrode==36)||(electrode==37)||(electrode==38)||(electrode==62)||(electrode==63)||(electrode==76)||(electrode==71)||(electrode==77)||(electrode==87))
            % Cluster A
            text(C(i,2)-0.1, C(i,3), num2str(C(i)), 'EdgeColor','black', 'BackgroundColor','white', 'FontWeight', 'bold')            
        elseif ((electrode==45)||(electrode==46)||(electrode==47)||(electrode==48)||(electrode==55)||(electrode==56)||(electrode==57)||(electrode==58)||(electrode==67)||(electrode==68)||(electrode==78)||(electrode==66))
            % Cluster B
            text(C(i,2)-0.1, C(i,3), num2str(C(i)), 'EdgeColor','red', 'BackgroundColor','white', 'FontWeight', 'bold')            
        elseif ((electrode==64)||(electrode==65)||(electrode==72)||(electrode==73)||(electrode==74)||(electrode==75)||(electrode==82)||(electrode==83)||(electrode==84)||(electrode==85)||(electrode==86))
            % Cluster C
            text(C(i,2)-0.1, C(i,3), num2str(C(i)), 'EdgeColor','blue', 'BackgroundColor','white', 'FontWeight', 'bold')
        elseif ((electrode==21)||(electrode==31)||(electrode==32)||(electrode==41)||(electrode==42)||(electrode==43)||(electrode==44)||(electrode==51)||(electrode==52)||(electrode==53)||(electrode==54)||(electrode==61))
            % Cluster D
            text(C(i,2)-0.1, C(i,3), num2str(C(i)), 'EdgeColor','magenta', 'BackgroundColor','white', 'FontWeight', 'bold')            
        else
            % Cluster E
            text(C(i,2)-0.1, C(i,3), num2str(C(i)), 'EdgeColor','green', 'BackgroundColor','white', 'FontWeight', 'bold')            
        end

        hold on
    end
end
