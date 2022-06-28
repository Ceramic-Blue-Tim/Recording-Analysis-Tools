function P=findpeaksCustom(x,y,SlopeThreshold,AmpThreshold,minPeakDistance)
% Function to locate the positive peaks in a noisy x-y data
% set.  Detects peaks by looking for downward zero-crossings
% in the first derivative that exceed SlopeThreshold.
% Returns list (P) containing peak number and
% position, height, and width of each peak. SlopeThreshold and
% AmpThreshold control sensitivity:  higher values will neglect 
% smaller features.

% smoothwidth=round(smoothwidth); % round smoothwidth (in case not int)
% peakgroup=round(peakgroup);
% d = fastsmooth(diff(y),smoothwidth); % takes into account the first derivative of y and smoothes it (according to
                                      % smoothwidth)
d = diff(y);
% if peakgroup = 3 --> (3/2+1)->3
% peakgroup = 5 --> (5/2+1)->4
% peakgroup = 7 --> (7/2+1)->5
% n = round(peakgroup/2+1);
P = [0 0 0];  % initialize P
% vectorlength = length(y);
peak = 1;   % counter of peaks
% if smoothwidth = 3 and length(y) = 9 --> 3,4,5,6
% for j = smoothwidth:length(y)-smoothwidth,
for j = 2:length(y)-1
    if sign(d(j-1)) > sign (d(j)), % Detects zero-crossing (local maxima)
        if d(j-1)-d(j) > SlopeThreshold*(x(j+1)-x(j))
            % if d(j)-d(j+1) > SlopeThreshold*y(j), % if slope of derivative is larger than SlopeThreshold
            if y(j) > AmpThreshold,  % if height of peak is larger than AmpThreshold
%                 for k = 1:peakgroup, % Create sub-group of points near peak
%                     % groupindex means the index in the group of points near peak
%                     groupindex=j+k-n+1;
%                     % check on leftmost index
%                     if groupindex<1, groupindex=1;end
%                     % check on rightmost index
%                     if groupindex>vectorlength, groupindex=vectorlength;end
%                     % xx and yy is the vicinity of the peak (peakgroup points)
%                     xx(k)=x(groupindex);yy(k)=y(groupindex);
%                 end
%                 % xke' log10(yy)????
%                 [coef,S,MU]=polyfit(xx,log(abs(yy)),2);  % Fit parabola to log10 of sub-group with centering and scaling
%                 % [coef,S,MU]=polyfit(xx,yy,2);
%                 c1=coef(3);c2=coef(2);c3=coef(1);
%                 PeakX = -((MU(2).*c2/(2*c3))-MU(1));   % Compute peak position and height of fitted parabola
%                 PeakY = exp(c1-c3*(c2/(2*c3))^2);
%                 MeasuredWidth = norm(MU(2).*2.35703/(sqrt(2)*sqrt(-1*c3)));
                % cmq se peakgroup < 7 non fa l'approssimazione con la
                % parabola...
%                 if peakgroup<7,
%                     PeakY = max(yy);
%                     pindex = val2ind(yy,PeakY);
%                     PeakX = xx(pindex(1));
%                 end
                PeakY = y(j);
                PeakX = x(j);
                if (j-minPeakDistance)<1, endL = 1; else endL = j-minPeakDistance; end
                if peak > 1
                    if P(peak-1,1) > endL
                        if P(peak-1,3) >= PeakY
                            continue;
                        else
                            P(peak-1,:) = [j PeakX PeakY];
                            continue;
                        end
                    end
                end
                % Construct matrix P. One row for each peak
                % detected, containing peak
                % position (x-value) and peak height (y-value).
                P(peak,:) = [j PeakX PeakY];
                peak = peak+1;
            end
        end
    end
end
% function [index,closestval]=val2ind(x,val)
% % Returns the index and the value of the element of vector x that is closest to val
% % If more than one element is equally close, returns vectors of indicies and values
% % Tom O'Haver (toh@umd.edu) October 2006
% % Examples: If x=[1 2 4 3 5 9 6 4 5 3 1], then val2ind(x,6)=7 and val2ind(x,5.1)=[5 9]
% % [indices values]=val2ind(x,3.3) returns indices = [4 10] and values = [3 3]
% dif=abs(x-val);
% index=find((dif-min(dif))==0);
% closestval=x(index);