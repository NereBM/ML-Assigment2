%{
%   Input:  Cell array of structs with format:
%
%   struct {
%       recall :: Number, true positive / true positive + false negative
%       precision :: Number, true positive / true positive + false positive
%       f1Score :: Number, 2 * precision * recall / precision + recall
%   }
%
%   Output: Print recall, precision and f1 scores per fold.
%           Print mean f1 score for all cross validation.
%}


function formatPrintData(data)

    f1Scores = zeros(length(data), 1);
    for i = 1:length(data)
       fprintf('\nFold %d\n', i);
       fprintf('Recall value    = %.2f\n', data{i}.recall);
       fprintf('Prevision value = %.2f\n', data{i}.precision);
       fprintf('F1 score        = %.2f\n', data{i}.f1Score);
       f1Scores(i) = data{i}.f1Score;
    end
    fprintf('\nMean f1 score = %.2f\n', mean(f1Scores));
end