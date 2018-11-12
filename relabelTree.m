%{
%   Input:  Struct of the format:
%
%   tree {
%       op        :: String, index of attribute tested.
%       attribute :: Number, index of attribute tested.
%       threshold :: Number, used to split data.
%       class     :: Number, 1 or 0.
%       kids      :: Cell array of length 2 containing subtrees as structs.
%       entropy   :: Number, entropy value at node.
%   }  
%
%   Output: Tree struct with same format with op relabelled to entropy.
%}

function tree = relabelTree(tree)

    tree.op = tree.entropy;
    tree.class = tree.entropy;
    if ~isempty(tree.kids)
        % Change tree.op to display different values in DrawDecisionTree().
        tree.kids{1} = relabelTree(tree.kids{1});
        tree.kids{2} = relabelTree(tree.kids{2});
    end
end