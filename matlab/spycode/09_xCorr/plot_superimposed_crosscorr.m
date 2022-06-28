%function plot_superimposed_crosscorr()
% modified by Luca Leonardo Bologna (11 June 2007)
%   - in order to handle the 64 channels of MED64 Panasonic system

[filenames, pathnames]=uigetfiles('*.mat', 'Select the functions to be plotted');

% VARIABLE DEFINITION --------------
[r,c]=size(filenames);

binsize=10; %msec, bin of the crosscorrelogram
window=150;
plus=rem(window,binsize);
x=[-(window+plus):binsize:(window+plus)]'; % in this way there is always a bin centered in zero

y_input=12; % to one to whom the selected channel is correlated

coll = ['k', 'r', 'b', 'g', 'c'];

% ---------------------------
cd(pathnames)

for i=1:c
    load(filenames{1,i})
    if length(r_table)==87 %added for compatibility with previous versions of SM
        r_table(end+1)=[];
    end
    r=r_table{y_input,1};
    plot(x,r,coll(i),'LineWidth',2)
    hold on

end


