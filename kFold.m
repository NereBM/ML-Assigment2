%{
%   Input:  Matrix of features, vector of corresponding labels.
%   Output: Cell array of structs with format:
%
%   struct {
%       recall :: Number, true positive / true positive + false negative
%       precision :: Number, true positive / true positive + false positive
%       f1Score :: Number, 2 * precision * recall / precision + recall
%       tree :: Struct containing tree
%   }
%}

function data = kFold(features, labels)

    % Change k to alter number of folds
    k = 10;
    cv = cvpartition(size(features, 1), 'kfold', k);
    data = cell(cv.NumTestSets, 1);
    for i = 1: cv.NumTestSets
        % Create tree from training data.
        tree = createTree(transpose(features(cv.training(i), :)), ...
            labels(cv.training(i)));
        
        % Classify test data using tree.
        predicted = classify(features(cv.test(i), :), tree);
        
    
        % Save data in struct
        [data{i}.recall, data{i}.precision] = ...
            calcRecallPrecision(predicted, labels(cv.test(i)));
        data{i}.f1Score = calcF1Score(data{i}.recall, data{i}.precision);
        data{i}.tree = tree;
        % Uncomment below to view tree.
        % DrawDecisionTree(tree);
        % pause
    end
end


%{
%   Input:  Matrix of features, struct containing tree from createTree().
%   Output: Vector containing predicted classes.
%}

function predicted = classify(features, tree)
    
    predicted = zeros(size(features, 1), 1);
    for i = 1: size(features, 1)
        node = tree;
        x = (features(i, :));
        
        % Traverse tree until leaf node then set class to leaf node class.
        while ~isempty(node.kids)
            if x(node.attribute) < node.threshold
                node = node.kids{1};
            else
                node = node.kids{2};
            end
        end
        predicted(i) = node.class;
    end
end


%{
%   Input:  Vectors containing predicted and actual labels for binary
%           classification problem.
%   Output: Recall and precision values.
%}

function [recall, precision] = calcRecallPrecision(predicted, actual)
    
    % true positive, false positive and false negative.
    tp = 0;
    fp = 0;
    fn = 0;

    % Count true positives, false positives and false negatives.
    for i = 1:length(predicted)
        if predicted(i) == actual(i)
            tp = tp + 1;
        elseif predicted(i) == 1 && actual(i) == 0
            fp = fp + 1;
        elseif predicted(i) == 0 && actual(i) == 1
            fn = fn + 1;
        end
    end
    
    precision = tp / (tp + fp);
    recall    = tp / (tp + fn);
end


%{
%   Input:  Recall and precision values.
%   Output: F1 score.
%}

function f1Score = calcF1Score(recall, precision)
    f1Score = 2 * ((precision * recall) / (precision + recall));
end