%{
%   Input:  Matrix of features, vector of labels.
%   Output: Struct containing decision tree with the format:
%
%   tree {
%       op        :: String, index of attribute tested.
%       attribute :: Number, index of attribute tested.
%       threshold :: Number, used to split data.
%       class     :: Number, 1 or 0.
%       kids      :: Cell array of length 2 containing subtrees.
%  }
%}

function tree = createTree(features, labels)
    if sum(labels(1)==labels)==length(labels)
        tree.class = labels(1);
    else 
        % Function to select best attribute and threshold to split data.
        [tree.attribute, tree.threshold] = ...
            CHOOSE_ATTRIBUTE(features, labels);
        
        % Save feature evaluated in node for draw function.
        tree.op = int2str(tree.attribute);
               
        % Divide data in to two sets based on tree.attribute and
        % tree.threshold.       
        leftChildFeatures = features( ...
            features(:, tree.attribute) < tree.threshold);
        leftChildLabels = labels( ...
            features(:, tree.attribute) < tree.threshold);
        rightChildFeatures = features( ...
            features(:, tree.attribute) >= tree.threshold);
        rightChildLabels = labels( ...
            features(:, tree.attribute) >= tree.threshold);

        if size(leftChildFeatures,1) == 0
            tree.class = majorityVote(leftChildLabels);
        else
            tree.kids{1} = createTree(leftChildFeatures,leftChildLabels);
        end
        
        if size(rightChildFeatures,1) == 0
            tree.class = majorityVote(rightChildLabels);
        else
            tree.kids{2} = createTree(rightChildFeatures,rightChildLabels);
        end
    end
end