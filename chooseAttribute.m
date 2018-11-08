function [best_attribute, best_threshold] = chooseAttribute(X, y)

    nodeEntropy = calcEntropy(y);
    thresholds = zeros(size(X, 1), 2);

    for i = 1:size(X, 1)
        % Find range from column 1 to end
        inc_value = range(X(i, :)) / 4;
        
        % Store threshold in index 1, infGain in index 2.
        threshold_infGain = zeros(size(X, 2), 2); 
        
        % Find best threshold for this attribute by calculating inf gain.
        for j = 1:3
            % Threshold = min from row x + (value * multiplier)
            curr_threshold = min(X(i, :)) + (inc_value * j);
            
            % Calculate entropy for left/right nodes and inf gain.
            Pl = sum(y(X(i, :) < curr_threshold)) / length(y);
            Nl = calcEntropy(y(X(i, :) < curr_threshold));
            Rl = calcEntropy(y(X(i, :) >= curr_threshold));   
            infGain = nodeEntropy - (Pl * Nl) - ((1 - Pl) * Rl);
            threshold_infGain(j, 1) = curr_threshold;
            threshold_infGain(j, 2) = infGain;
        end
        
        % Store maximum inf gain and corresponding threshold.
        [~, m] = max(threshold_infGain(:, 2));
        thresholds(i, :) = threshold_infGain(m, :);
    end
    [~, best_attribute] = max(thresholds(:, 2));
    best_threshold = thresholds(best_attribute, 1);
end


%{ 
%   Input:  X       - vector
%   Output: entropy - entropy value
%}

function entropy = calcEntropy(y)
    p = sum(y == 0);
       
    n = length(y) - p;
    entropy = -((p / (p + n)) * log2(p / (p + n))) ...
        - ((n / (n + p)) * log2(n / (n + p)));
end