%{
%   Input:  Matrix of features, vector of corresponding labels.
%   Output: Struct containing decision tree with format:
%
%   tree {
%       op        :: String, index of attribute tested.
%       attribute :: Number, index of attribute tested.
%       threshold :: Number, used to split data.
%       class     :: Number, 1 or 0.
%       kids      :: Cell array of length 2 containing subtrees as structs.
%  }
%}

function [tree, opTree] = createTree(features, labels)
    tree.kids = {};
    tree.op = '';
    opTree.kids = {};
    opTree.op = '';
    opTree.class = calcEntropy(labels);
    
    % This doesn't make sense. If features is empty, labels will be too.
    if isempty(features)
        tree.class = -1; % majorityVote(labels);
    elseif sum(labels(1) == labels) == length(labels)
        tree.class = labels(1);
    else 
        % Function to select best attribute and threshold to split data.
        [tree.attribute, tree.threshold] = ...
            choose_attributes(features, labels);
        tree.op = int2str(tree.attribute);
               
        % Divide data in two sets based on attribute and threshold.
        lIndices = features(tree.attribute, :) < tree.threshold;     
        leftChildFeatures = features(:, lIndices);
        leftChildLabels = labels(lIndices);
        
        rIndices = features(tree.attribute, :) >= tree.threshold;
        rightChildFeatures = features(:, rIndices);
        rightChildLabels = labels(rIndices);
        
        opTree.op = num2str(calcEntropy(labels));
        [tree.kids{1}, opTree.kids{1}] =  ...
            createTree(leftChildFeatures, leftChildLabels);
        [tree.kids{2}, opTree.kids{2}] = ...
            createTree(rightChildFeatures, rightChildLabels);
    end
end

function entropy = calcEntropy(X)
    p = sum(X == X(1));
    
    if p == length(X)
        entropy = 0;
    else
        n = length(X) - p;
        entropy = -((p / (p + n)) * log2(p / (p + n))) ...
            - ((n / (n + p)) * log2(n / (n + p)));
    end
end

