function data = kFold(features, labels)

    % Change k to alter number of folds
    k = 10;
    cv = cvpartition(size(features, 1), 'kfold', k);
    
    for i = 1: cv.NumTestSets
        root = createTree(transpose(features(cv.training(i), :)), ...
            labels(cv.training(i)));
        DrawDecisionTree(root);
        pause
    end
    
end