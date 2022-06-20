function []=spike_clustering(Extracted_spikes, cluster_num, num_electrode)
fig1 = figure;
fig1.PaperUnits      = 'centimeters';
fig1.Units           = 'centimeters';
fig1.Color           = 'w';
fig1.InvertHardcopy  = 'off';
fig1.Name            = 'Clustering'
fig1.DockControls    = 'on';
fig1.WindowStyle    = 'docked';
fig1.NumberTitle     = 'off';
set(fig1,'defaultAxesXColor','k');
figure(fig1);

cmap = hsv(cluster_num); 
time=[2: -0.05: -1];
t = rot90(time);

for p=1:num_electrode
    pos_spikes=Extracted_spikes{p,1};
    pos_spikes_rot=rot90(pos_spikes);
    
    [~,score,~,~,~] = pca(pos_spikes_rot, 'VariableWeights','variance');
    opts = statset('Display','final');
    [idx, ~]  = kmeans(score, cluster_num, 'Distance','sqeuclidean','Replicates',3,'Start', 'plus', 'Options', opts);
    % 'hamming''correlation''cosine''cityblock''sqeuclidean'
    ymin = min(min(pos_spikes_rot));
    ymax = max(max(pos_spikes_rot));
    
    % C1_spikes = All_spikes_rot(idx==1,:)
    % C2_spikes = All_spikes_rot(idx==2,:)
    % C3_spikes = All_spikes_rot(idx==3,:)
    % C4_spikes = All_spikes_rot(idx==4,:)
    % 
    % C1_locs=locs_spikes_rot(idx==1,:);
    % C2_locs=locs_spikes_rot(idx==2,:);
    % C3_locs=locs_spikes_rot(idx==3,:);
    % C4_locs=locs_spikes_rot(idx==4,:);
    
    for i = 1:cluster_num
        subplot(cluster_num,num_electrode,num_electrode*(i-1)+p);
        hold on
        plot(t, pos_spikes_rot(idx==i,:)','Color', cmap(i, :));
        plot(t, mean(pos_spikes_rot(idx==i,:))','Color', 'black');
        title(sprintf('Cluster %d',i));
        ylim([ymin, ymax]);
        hold off
    end


end