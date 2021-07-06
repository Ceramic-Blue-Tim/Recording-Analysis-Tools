function [Signal_array]=nea_electrode_configuration_array(LP_HP_Signal, electode_position)

length_electrode_position=length(electode_position);
tl=length(LP_HP_Signal(:,1));

Signal_array=zeros(tl, 64);

for i=1:length_electrode_position
readpoistion=electode_position(1, i);
Signal_array(:, readpoistion)= LP_HP_Signal(:, i);
end

fig1 = figure;
fig1.PaperUnits      = 'centimeters';
fig1.Units           = 'centimeters';
fig1.Color           = 'w';
fig1.InvertHardcopy  = 'off';
fig1.Name            = ['All signal array NEA'];
%     fig1.DockControls    = 'on';
%     fig1.WindowStyle    = 'docked';
fig1.NumberTitle     = 'off';
set(fig1,'defaultAxesXColor','k');
figure(fig1);

electode_order=[9 1 2 12 13 14 8 15 7 17 19 10 20 5 22 16 23 24 25 27 28 3 29 6 30 32 31 33 28 26 11 4 21 37 39 40 35 41 49 52 61 62 64 48 38 42 50 43 59 36 45 63 46 47 58 57 51 44 60 53 54 55 56 ];

for i=1:63
    
        subplot(7,9,i)
        readpoistion=electode_order(1, i);
        plot(Signal_array(:, readpoistion));

end