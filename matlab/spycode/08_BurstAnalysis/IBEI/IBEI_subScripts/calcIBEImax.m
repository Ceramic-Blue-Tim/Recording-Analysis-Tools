function [ISImax, pks, flags] = calcIBEImax(bins, ISIhist, mpd, voidParamTh, ISITh, elecNum)
% initialize variables
% array of ISImax threshold for burst detection
ISImax = zeros(elecNum,1);
% array of flags that tell if a channel is bursting or not
flags = zeros(elecNum,1);
% peaks detected
pks = cell(elecNum,1);
for i = 1:elecNum
    % considering the decimal logarithm of x coordinate
    % in this way x-values are linearly spaced
    % xx -> bins
    % yy --> (smoothed) ISI histogram
    xx = bins{i,1};
    yy = ISIhist{i,1};
    % NB: ISIhist are smoothed histograms!
    if (~isempty(yy))       % if there's a histogram (!)
%         [peaks,locs] = findpeaksIBEI(yy,'minpeakdistance',mpd,'minpeakheight',mph);
        [peaks,locs] = findpeaksIBEI(yy,'minpeakdistance',mpd);
        if ~isempty(peaks) && any(peaks)       % if there is at least one peak
            pks{i,1} = [xx(locs) peaks(:)];
            numPeaks = size(pks{i,1},1);
            %% 
            % index of peaks < th
            idxPeakIntraBurst = find(pks{i,1}(:,1)<ISITh);
            % if there is more than one peak < 10^2 ms, it considers the
            % biggest one
            if(numel(idxPeakIntraBurst)>1)
                [maxPeakIntraBurst,idxMax] = max(pks{i,1}(idxPeakIntraBurst,2));
                idxPeakIntraBurst = idxPeakIntraBurst(idxMax);
                % if there is no peak identified below 10^2 ms, the channel
                % is not analyzed
            else if(isempty(idxPeakIntraBurst))
                    continue
                end
            end
            % we save the first peak's x- and y-coordinate
            y1 = pks{i,1}(idxPeakIntraBurst,2);
            x1 = pks{i,1}(idxPeakIntraBurst,1);
            locs1 = find(xx==x1);
            % this is the number of peaks found after the peak intra-burst
            % (i.e. the maximum peak between 0 and ISITh)
            numPeaksAfterBurst = numPeaks-idxPeakIntraBurst;
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if numPeaksAfterBurst == 0
%             if numPeaks == 1
%                 dyy = diff(yy);
%                 xEdgesDown = xx(find(diff(sign(abs(dyy)-diffTh))<0)+1);
%                 ISImax(i) = xEdgesDown(find(xEdgesDown>x1,1));
%                 flags(i) = 1;
                continue
            end            
            if numPeaksAfterBurst >= 1
                yMin = zeros(numPeaksAfterBurst-1,1);
                idxMin = zeros(numPeaksAfterBurst-1,1);
                voidParameter = zeros(numPeaksAfterBurst-1,1);
                c = 0;
                for j = idxPeakIntraBurst:numPeaks
                    c = c+1;
                    x2 = pks{i,1}(j,1);
                    locs2 = find(xx==x2);
                    y2 = pks{i,1}(j,2);
                    [yMin(c),tempIdxMin] = min(yy(locs1:locs2));
                    idxMin(c) = tempIdxMin+locs1-1;
                    % the void parameter is a measure of the degree of separation
                    % between the two peaks through the minimum
                    voidParameter(c) = 1-(yMin(c)/sqrt(y1.*y2));
                end
                idxMaxVoidParameter = find(voidParameter>=voidParamTh,1);
                % if there is no minimum that satisfies the threshold
                if isempty(idxMaxVoidParameter)
%                     % it looks for the minimum that has the maximum void
%                     % parameter (the first one in ascending order)
%                     [maxVoidParameter, idxMaxVoidParameter] = max(voidParameter);
% %                     dyy = diff(yy);
% %                     xEdgesDown = xx(find(diff(sign(abs(dyy)-diffTh))<0)+1);
% %                     ISImax(i) = xEdgesDown(find(xEdgesDown>x1,1));
% %                     flags(i) = 1;
                    continue
                end
                ISImax(i) = xx(idxMin(idxMaxVoidParameter));
                flags(i) = 1;
            end
        end
    end
end