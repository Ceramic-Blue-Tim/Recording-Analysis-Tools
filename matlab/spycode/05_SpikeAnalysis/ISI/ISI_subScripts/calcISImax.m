function [ISImax, pks, flags] = calcISImax(bins, ISIhist, mpd, voidParamTh, ISITh, elecNum)
% initialize variables
% array of ISImax threshold for burst detection
ISImax = zeros(elecNum,1);
% array of flags: 
% the first flag tells if a channel is bursting or not -->
% flag(1) = 1 --> the channel has to be analyzed
% flag(1) = 0 --> the channel has not to be analyzed
% the second flag tells if the algorithm has managed to determine a correct
% threshold:
% flag(2) = 1 --> the threshold is determined by the ISI histogram
% flag(2) = 0 --> the threshold is not determined
flags = zeros(elecNum,2);
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
%         [peaks,locs] = findpeaks(yy,'minpeakdistance',mpd,'minpeakheight',mph);
        [peaks,locs] = findpeaksISI(yy,'minpeakdistance',mpd);
%         [peaks,locs] = findpeaksIBEI(yy,'minpeakdistance',mpd);
        if ~isempty(peaks) && any(peaks)       % if there is at least one peak
            pks{i,1} = [xx(locs) peaks(:)];
            numPeaks = size(pks{i,1},1); 
            % index of peaks < 10^2 ms
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
                flags(i,1) = 1;
                flags(i,2) = 0;
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
                    flags(i,1) = 1;
                    flags(i,2) = 0;
                    continue
                end
                ISImax(i) = xx(idxMin(idxMaxVoidParameter));
                flags(i,:) = [1 1];
            end
        end
    end
end