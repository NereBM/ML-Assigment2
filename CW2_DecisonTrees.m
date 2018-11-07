clear;
clc;

%1.Create data
load('facialPoints.mat');
load('labels.mat');

[matrix,attributesLabel,attributesActive] = ID3pre();

%2.Create decision tree

%{
tree
{
    string op;
    tree kids;
    int class;
    int attribute;
    float threshold; 
};
%}

function [matrix,attributes,activeAttributes]  = ID3pre()
%The preprocess of the function
    S = size(points);
    matrix = reshape(points,[S(3),S(1)*S(2)]);
    attributes = labels;
    [~,columns] = size(matrix);
    activeAttributes = ones(1,columns);
end

function [tree] = ID3tree(matrix,attributesLabel,attributesActive) 
    
    %Check the data
    if(isempty(matrix))
        error("Please check the points data!");
    end
    if(isempty(attributesLabel))
        error("Please check the labels data!");
    end
    
    numAttributesActive = length(attributesActive);
    numAttributes = length(attributesLabel);
    
    tree = struct('op', 'null', 'kids', 'null', 'class', 'null', 'attribute', 'null', 'threshold', 'null');
    
    if (sum(attributesLabel) == 0)
        tree.class = 0;
        return
    end
    if (sum(attributesLabel) == numAttributes)
        tree.class = 1;
        return
    end
    %{
    if (sum(attributesActive) == 0)
        if(sum(attributesLabel)) >= numAttributes/2)
            tree.class = 1;
        else
            tree.class = 0;
        end  
        return
    end
    %}
       
    [best_feature,best_threshold] = ChooseAttribute(matrix,attributesLabel,attributesActive);


end

function [best_feature,best_threshold] = ChooseAttribute(matrix,attributesLabel,attributesActive)
    %Calculate the base information entropy
    p1 = sum(attributesLabel)/length(attributesLabel);
    p1_entropy = (-1)*p1*log2(p1);
    p0 = (length(attributesLabel)-sum(attributesLabel))/length(attributesLabel);
    p0_entropy = (-1)*p0*log2(p0);  
    baseEntropy = p1_entropy + p0_entropy;
    
    
    %Store the Gain and the corresponding thresholds
    InfoGain = zeros(1,length(attributesActive));
    Threshold = zeros(1,length(attributesActive));
    
    %Calculate the maximum Gain with corresponding thresholds for each attribute
    for counter = 1 : length(attributesActive)
        if attributesActive(counter) > 0 %The attribute can be used
            maxInfoGain = 0; 
            threshold = -1;
            featedList = matrix(:,counter);%The counterth column
            [ascendOrder,preOrderIndex] = sort(featedList);%sort the featedList
            preOrderLabels = attributesLabel(preOrderIndex);%Get the labels in same sequence
            numberOrder = length(ascendOrder);%number of continuous value
           
            midList = zeros(1,numberOrder-1);
            for i = 1:(numberOrder-1)%calculate the mid point
                midList(i) = (ascenOrder(i) + ascenOrder(i+1))/2;
            end
            
            for i = 1:length(midList)%Calculate the information gain of each mid
                
                %Divide the data into two sets based on the mid point
                beforeData = ascenOrder(1:i);
                afterData = ascenOrder((i+1):length(midList));
                
                %Calculate the Entropy seperately
                newBeforeP1 = sum(preOrderLabels(1:i)) / i;
                newBeforeP0 = (i-sum(preOrderLabels(1:i))) / i;  
                
                newAfterP1 = sum(preOrderLabels(i+1:midList)) / (midList-i);
                newAfterP0 = (midList-i-sum(preOrderLabels(i+1:midList))) / (midList-i);
                
                newBeforeEntropy = (-1)*newBeforeP1*log2(newBeforeP1) + (-1)*newBeforeP0*log2(newBeforeP0);
                newAfterEntropy = (-1)*newAfterP1*log2(newAfterP1) + (-1)*newAfterP0*log2(newAfterP0);
                
                %Add it together
                newTotalEntropy = length(beforeData)/length(ascendOrder)*newBeforeEntropy + length(afterData)/length(ascendOrder)*newAfterEntropy;
                
                %The final information gain
                infoGain = baseEntropy - newTotalEntropy;
     
                if infoGain > maxInfoGain%Receive the max infomation gain from all kinds of thresholds
                    maxInfoGain = infoGain;
                    threshold = midList(i);
                end
               
            end
            InfoGain(counter) = maxInfoGain;%the max information gain of this attribute
            Threshold(counter) = threshold;%store the threshold of this attribute   
            attributesActive(counter) = 0;%turn off this attributes
                    
        else%The attribute can not be used
            InfoGain(counter) = 0;%No gain can be used
            Threshold(counter) = 0;%No threshold can be used
        end
      
    end
    
    %Information gain of all attributes were stored in InfoGain
    %Best Threshold for largest gain value of all attributes were stored in Threshold  
    best_feature = find(InfoGain==max(InfoGain));
    best_threshold = Threshold(best_feature);
   
end

%3.Evaluation
















