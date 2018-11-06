function tree = createTree(features, labels)
    if sum(labels(1)==labels)==length(labels)
        tree.class = labels(1);
    else 
        % Function to select best attribute and threshold to split data.
        [tree.attribute, tree.threshold]= ...
            CHOOSE_ATTRIBUTE(features, labels);
        
        % Save feature evaluated in node for draw function.
        tree.op = tree.attribute;
        
        %The data is divided in two sets, the set less than or equals to
        %the threshold and another set that cntains the rest of the data
        %the find function returns the index of the vector that meet the
        %given condition
        leftChildFeatures = features(find(features( ...
            :, tree.attribute) < tree.threshold),:);
        leftChildLabels = labels(find(features( ...
            :, tree.attribute) < tree.threshold),:);
        rightChildFeatures = features(find(features( ...
            :, tree.attribute) >= tree.threshold),:);
        rightChildLabels = labels(find(features( ...
            :, tree.attribute) >= tree.threshold), :);

        if size(leftChildFeatures,1) == 0
            tree.class = majorityVote(leftChildLabels);
        else
            tree.kids{1} = CreationTree(leftChildFeatures,leftChildLabels);
        end
        
        if size(rightChildFeatures,1) == 0
            tree.class = majorityVote(rightChildLabels);
        else
            tree.kids{2}=CreationTree(rightChildFeatures,rightChildLabels);
        end
    end
end