%clear;
%clc;

%{
Create data and preprocess
load('facialPoints.mat');
load('labels.mat');

S = size(points);
matrix = reshape(points,[S(3),S(1)*S(2)]);
attributesLabel = labels;
%}



function [best_feature,best_threshold] = ChooseAttribute_bi_partition(matrix,attributesLabel)
    
    [~,columns] = size(matrix);
    %Calculate the base information entropy
    p1 = sum(attributesLabel)/length(attributesLabel);
    p1_entropy = (-1)*p1*log2(p1);
    p0 = (length(attributesLabel)-sum(attributesLabel))/length(attributesLabel);
    p0_entropy = (-1)*p0*log2(p0);  
    baseEntropy = p1_entropy + p0_entropy;
    
    
    %Store the Gain and the corresponding thresholds
    InfoGain = zeros(1,columns);
    Threshold = zeros(1,columns);
    
    %Calculate the maximum Gain with corresponding thresholds for each attribute
    for counter = 1 : columns
        maxInfoGain = 0; 
        threshold = -1;
        featedList = matrix(:,counter);%The counterth column
        [ascendOrder,preOrderIndex] = sort(featedList);%sort the featedList
        preOrderLabels = attributesLabel(preOrderIndex);%Get the labels in same sequence
        numberOrder = length(ascendOrder);%number of continuous value

        midList = zeros(1,numberOrder-1);
        for i = 1:(numberOrder-1)%calculate the mid point
            midList(i) = (ascendOrder(i) + ascendOrder(i+1))/2;
        end

        for i = 1:length(midList)%Calculate the information gain of each mid

            %Divide the data into two sets based on the mid point
            beforeData = ascendOrder(1:i);
            afterData = ascendOrder((i+1):length(midList));

            %Calculate the Entropy seperately
            newBeforeP1 = sum(preOrderLabels(1:i)) / i;
            newBeforeP0 = (i-sum(preOrderLabels(1:i))) / i;  

            newAfterP1 = sum(preOrderLabels(i+1:length(midList))) / (length(midList)-i);
            newAfterP0 = (length(midList)-i-sum(preOrderLabels(i+1:length(midList)))) / (length(midList)-i);

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
   
    end
    
    %Information gain of all attributes were stored in InfoGain
    %Best Threshold for largest gain value of all attributes were stored in Threshold  
     
    best_feature = find(InfoGain==max(InfoGain));
    best_threshold = Threshold(best_feature);
   
end