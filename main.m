clear;
clc;
load('data/facialPoints.mat');
load('data/labels.mat');
points = reshape(points, [132, 150]);
labels = transpose(labels);

% ===========================================================
% Optional - shift values by n in points in points and labels
%            where n = 1 to size(points, 2).
% rndNum = randi([1, size(points, 2)], 1, 1);
% points = circshift(points, rndNum, 2);
% labels = circshift(labels, rndNum);
% ===========================================================

data = kFold(points, labels);
formatPrintData(data);