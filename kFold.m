function data = kFold(features, labels)

    % Change k to alter number of folds
    k = 10;
    cv = cvpartition(size(features, 1), 'kfold', k);
    
    for i = 1: cv.NumTestSets
        % Create tree from training data.
        tree = createTree(transpose(features(cv.training(i), :)), ...
            labels(cv.training(i)));
        
        % Classify test data using tree.
        predicted = classify(features(cv.test(i), :), tree);
        
        % Calculate F1 score from labels(cv.test(i)) and predicted.
        
        % DrawDecisionTree(root);
        % pause
        
    end
end


function predicted = classify(features, tree)
    
    predicted = transpose(zeros(size(features, 1), 1));
    for i = 1: size(features, 1)
        node = tree;
        x = (features(i, :));
        % Traverse tree until leaf node.
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