function tree = CreationTree(features, labels)

    %base case:
    if sum(labels(1)==labels)==length(labels)
        tree.class = labels(1);
    else 
        %The function to choose the attribute and the threshold to split
        %the data i called
        [tree.attribute, tree.threshold]=CHOOSE_ATTRIBUTE(features, labels);
        %The data is divided in two sets, the set less than or equals to
        %the threshold and another set that cntains the rest of the data
        %the find function returns the index of the vector that meet the
        %given condition
        set_match = features(find(features(:,tree.attribute)<= tree.threshold),:);
        set_match_labels = labels(find(features(:,tree.attribute)<= tree.threshold),:);
        set_rest = features(find(features(:,tree.attribute)> tree.threshold),:);
        set_rest_labels = labels(find(features(:,tree.attribute)> tree.threshold);
        %We save in "op" the feature evaluated in this node, to print the
        %node
        tree.op = tree.attribute;
        if(size(set_match,1)==0)
            if(sum(set_match_labels==1)>=sum(set_match_labels==0))
                tree.class=1;
            else
                tree.class=0;
            end
        else
            tree.kids{1}=CreationTree(set_match,set_match_labels);
        end
        
        if(size(set_rest,1)==0)
            if(sum(set_rest_labels==1)>=sum(set_rest_labels==0))
                tree.class=1;
            else
                tree.class=0;
            end
        else
            tree.kids{2}=CreationTree(set_rest,set_rest_labels);
        end
                
 

end

    