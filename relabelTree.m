%{
%   Input:  Struct of the format:
%
%   tree {
%       op        :: String, index of attribute tested.
%       attribute :: Number, index of attribute tested.
%       threshold :: Number, used to split data.
%       class     :: Number, 1 or 0.
%       kids      :: Cell array of length 2 containing subtrees as structs.
%       features  :: Matrix, features at node.
%       labels    :: Vector, labels at node.
%   }  
%
%   Output: Tree struct with same format with op relabelled to entropy.
%}

function tree = relabelTree(tree)

    tree.op = calcEntropy(tree.labels);
    tree.class = calcEntropy(tree.labels);
    if ~isempty(tree.kids)
        % Change tree.op to display different values in DrawDecisionTree().
        tree.kids{1} = relabelTree(tree.kids{1});
        tree.kids{2} = relabelTree(tree.kids{2});
    end
end


% If labels are all the same, will return NaN
function entropy = calcEntropy(y)
    p = sum(y == y(1));
    
    n = length(y) - p;
    entropy = -((p / (p + n)) * log2(p / (p + n))) ...
        - ((n / (n + p)) * log2(n / (n + p)));
end