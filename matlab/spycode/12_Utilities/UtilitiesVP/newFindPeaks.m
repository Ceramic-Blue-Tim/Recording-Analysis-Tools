function P = newFindPeaks(x,y,SlopeThreshold,AmpThreshold,minPeakDistance)
% Function to locate the positive peaks in ISI histogram.
% Detects peaks by looking for downward zero-crossings
% in the first derivative that exceed SlopeThreshold.
% Returns list (P) containing peak position (x & y) 
% SlopeThreshold and AmpThreshold control sensitivity: higher values will neglect 
% smaller features.
d = diff(y);
P = [0 0];  % initialize P
peak = 1;   % counter of peaks
for j = 2:length(y)-1
    if sign(d(j-1)) > sign(d(j)), % Detects zero-crossing (local maxima)
        x1 = (x(j)+x(j-1))/2;
        x2 = (x(j+1)-x(j))/2;
        if d(j-1)-d(j) > SlopeThreshold*(x2-x1) % if slope of derivative is larger than SlopeThreshold
            if y(j) > AmpThreshold,  % if height of peak is larger than AmpThreshold
                PeakY = y(j);
                PeakX = x(j);
%                 if (j-minPeakDistance)<1
%                     endL = 1; 
%                 else
%                     endL = j-minPeakDistance; 
%                 end
%                 if peak > 1 % if there's more than one peak
%                     if P(peak-1,1) > endL % if the preceding peak is closer than minPeakDistance
%                         if P(peak-1,2) >= PeakY % if it is higher, ignore the current peak
%                             continue;
%                         else
%                             P(peak-1,:) = [PeakX PeakY]; % overwrite the preceding peak with the new one
%                             continue;
%                         end
%                     end
%                 end
                % Construct matrix P. One row for each peak
                % detected, containing peak
                % position (x-value) and peak height (y-value).
                P(peak,:) = [PeakX PeakY];
                peak = peak+1;
            end
        end
    end
end