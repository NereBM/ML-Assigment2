%{
%   Input:  Matrix of features, vector of corresponding labels.
%   Output: Vector of F1 scores,
%}

function f1Scores = kFold(features, labels)

    % Change k to alter number of folds
    k = 10;
    cv = cvpartition(size(features, 1), 'kfold', k);
    f1Scores = zeros(cv.NumTestSets, 1);
    for i = 1: cv.NumTestSets
        % Create tree from training data.
        tree = createTree(transpose(features(cv.training(i), :)), ...
            labels(cv.training(i)));
        
        % Classify test data using tree.
        predicted = classify(features(cv.test(i), :), tree);
        
        f1Scores(i) = calcF1Score(predicted, labels(cv.test(i)));
        % DrawDecisionTree(root);
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
        
        % Traverse tree until leaf node then set.
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
%   Output: F1 score calculated from input vectors.
%}

function f1Score = calcF1Score(predicted, actual)
    
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
    f1Score = 2 * ((precision * recall) / (precision + recall));
end