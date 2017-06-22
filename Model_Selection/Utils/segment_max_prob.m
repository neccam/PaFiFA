function [ pred ] = segment_max_prob ( probs, nFrames, th )
        
    %% Segmentation Part
    nongesture = probs(:,1);
    smoothed_nongesture = smooth(nongesture);
    [pks,locs] = findpeaks(smoothed_nongesture);
    locs(pks < th) = [];
    pks(pks < th) = [];

    valid = ones(numel(locs),1);
    for l = 1:numel(locs)-1
        if valid(l) == 1
            dist = abs(locs(l) - locs(l+1:end));
            if sum(dist <= 16)
                nElem = sum(dist <= 16);
                idx = l+1 : l+nElem;
                if sum(pks(idx) < pks(l)) == nElem
                    valid(idx) = 0;
                elseif sum(pks(idx) < pks(l)) == 0
                    valid(l) = 0;
                else
                    idxx = (pks(idx) < pks(l));
                    valid(idxx) = 0;
                end
            end
        end
    end
    locs(~valid) = [];
    locs = locs + 8;
    % Eliminate Border NonGestures
    locs(locs < 16) = [];
    locs(abs(nFrames - locs) < 16) = [];
    
    probs = [zeros(8, 250) ;probs; zeros(7, 250)];
    
    pred = [];
    if numel(locs) > 0
        for l = 1:numel(locs)+1
           if l == 1 % First Segment
               idx = 1:locs(l);
           elseif l == numel(locs)+1 % Last Segment
               idx = locs(l-1) + 1 : nFrames;
           else % Mid Segment
               idx = locs(l-1) + 1 : locs(l);
           end
           
           gest_probs = probs(idx, 2:end);
           [~, curr_pred] = find(gest_probs == max(gest_probs(:)));
           pred(idx) = curr_pred(1);
        end
    else
        gest_probs = probs(:, 2:end);
        [~, predx] = find(gest_probs == max(gest_probs(:)));
        pred(1:numel(labels)) = predx(1);
    end
    
end

