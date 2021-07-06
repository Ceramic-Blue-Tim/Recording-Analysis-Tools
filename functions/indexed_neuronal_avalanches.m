function [x, Avalanches_probability, avalanche, A, idx]=indexed_neuronal_avalanches(All_spikes, def_avalanch_ms, num_electrode, time_ms, HP_Signal_fix)
All_spikes_rep1=All_spikes;
All_spikes_rep2=All_spikes;
All_spikes_rep1(:, 2)=[];
All_spikes_rep2(:, 1)=[];

mat_All_spikes=cell2mat(All_spikes_rep1);
mat_All_spikes_index=cell2mat(All_spikes_rep2);

merged_All_spikes_index=horzcat(mat_All_spikes, mat_All_spikes_index);
sorted_merged_All_spikes_index=sortrows(merged_All_spikes_index, 1);

sorted_merged_All_spikes_index_rep1=sorted_merged_All_spikes_index;
sorted_merged_All_spikes_index_rep1(:, 2)=[];

idx=sorted_merged_All_spikes_index;
idx(:,1)=[];
idx(length(idx), :)=[];

Merged_All_spikes_ms=sorted_merged_All_spikes_index_rep1*1000;
Merged_All_spikes_number=length(Merged_All_spikes_ms);
D=diff(Merged_All_spikes_ms);

fig1 = figure;
fig1.PaperUnits      = 'centimeters';
fig1.Units           = 'centimeters';
fig1.Color           = 'w';
fig1.InvertHardcopy  = 'off';
fig1.Name            = 'Indexed Neuronal avalanches overview';
fig1.NumberTitle     = 'off';
fig1.DockControls    = 'on';
fig1.WindowStyle    = 'docked';

A=D<def_avalanch_ms;
subplot(411)
plot(Merged_All_spikes_ms);
xlim([0 length(Merged_All_spikes_ms)])
subplot(412)
plot(D);
xlim([0 length(D)])

A(length(A), 1)=0;

subplot(413)
plot(A);
ylim([0 2])
xlim([0 length(A)])

subplot(414)



clear avalanche;
con=1;
av_num_count=0;
t=1;
for i=2:Merged_All_spikes_number-1
    
    if A(i)==1
        
        if A(i-1)==0
            av_num_count=av_num_count+1;
            con=con+1;
            temp_av(t, :)=+idx(i, :);
            t=t+1;
        else
            con=con+1;
            temp_av(t, :)=+idx(i, :);
             t=t+1;

        end
        
    else
        if  A(i-1)==1
                avalanche(1, i-1)= con-1;
                con=1;
                t=1;
                 if  av_num_count==0
                 else
                All_avalanche{av_num_count, :}=temp_av;
                clearvars temp_av;
                 end
        else
            avalanche(1, i-1)= con-1;
             con=1;
             t=1;
             clearvars temp_av;
        end


    end
    
end
avalanche(1, length(A))=0;

plot(avalanche);

xlim([0 length(avalanche)])
avalanche_rot=rot90(avalanche, 3);

Cal=A .* idx;
unit_matrix=eye(length(Cal));
tet=Cal .* unit_matrix;

Stet = sparse(tet) ;
k2 = find(Cal);
tt=tet(:, k2);

Stt = sparse(tt) ;
spikes_location=sorted_merged_All_spikes_index;
spikes_location(length(spikes_location), :)=[];
sLocation=spikes_location(:, 1);
Merged=horzcat(D, A, avalanche_rot, idx, Cal, sLocation);


% 
% a=sorted_merged_All_spikes_index_rep1(sorted_merged_All_spikes_index_rep1(:, 2)==1,1);
% ax=ones(length(a), 1);
% b=sorted_merged_All_spikes_index_rep1(sorted_merged_All_spikes_index_rep1(:, 2)==2,1);
% bx=ones(length(b), 1);

fig1 = figure;
fig1.PaperUnits      = 'centimeters';
fig1.Units           = 'centimeters';
fig1.Color           = 'w';
fig1.InvertHardcopy  = 'off';
fig1.Name            = 'Spikes_indexed location';
fig1.NumberTitle     = 'off';
fig1.DockControls    = 'on';
fig1.WindowStyle    = 'docked';

subplot(211)
for k=1:num_electrode
    hold on
    plot(time_ms/1000, HP_Signal_fix(:, k));
    xlim([min(sLocation) max(sLocation)]) 
end
hold off

subplot(212)

hold on
plot(sLocation, avalanche_rot, '.');
 plot(sLocation, idx, '.');
hold off
 xlim([min(sLocation) max(sLocation)]) 

set(gca,'YScale','log')


 plot(sLocation, idx, '.');
  plot(sLocation, Cal, '.');
 plot(sLocation, avalanche_rot, '.');

% hold on
% plot(a, ax, '.', 'Color', 'blue');
% plot(b, bx, '.', 'Color', 'red');

fig1 = figure;
fig1.PaperUnits      = 'centimeters';
fig1.Units           = 'centimeters';
fig1.Color           = 'w';
fig1.InvertHardcopy  = 'off';
fig1.Name            = 'Indexed cspy Neuronal avalanches';
fig1.NumberTitle     = 'off';
fig1.DockControls    = 'on';
fig1.WindowStyle    = 'docked';

cspy(Stt, 'colormap', 'jet');%S

xlim([1 1000])
ylim([1 1000])


fig1 = figure;
fig1.PaperUnits      = 'centimeters';
fig1.Units           = 'centimeters';
fig1.Color           = 'w';
fig1.InvertHardcopy  = 'off';
fig1.Name            = 'Indexed Histogram Neuronal avalanches';
fig1.NumberTitle     = 'off';
fig1.DockControls    = 'on';
fig1.WindowStyle    = 'docked';
     
set(fig1,'defaultAxesXColor','k');
edge = logspace(0,2 , 10);
set(gca,'XScale','log')
set(gca,'YScale','log')
histogram(avalanche*def_avalanch_ms, edge);
[~, L]=bounds(avalanche);
[N, edges]=histcounts(avalanche, L);
% ylim([0 20])

fig2 = figure;
fig2.PaperUnits      = 'centimeters';
fig2.Units           = 'centimeters';
fig2.Color           = 'w';
fig2.InvertHardcopy  = 'off';
fig2.Name            = 'Indexed Neuronal avalanches';
fig2.NumberTitle     = 'off';
fig2.DockControls    = 'on';
fig2.WindowStyle    = 'docked';
set(fig2,'defaultAxesXColor','k');

S=sum(N);
Avalanches_probability=N/S;
x=1:1:L;
logProb=log(Avalanches_probability);
logx=log(x);

plot(x, Avalanches_probability,'o');
edges = logspace(0,2 ,10);
set(gca,'XScale','log')
set(gca,'YScale','log')
xlim([1 1000])

