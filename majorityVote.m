%{
%   Input:  Vector containing binary data.
%   Output: Modal value from input vector.
%}

function class = majorityVote(labels)
    if sum(labels == 0) >= sum(labels == 1)
        class = 0;
    else
        class = 1;
    end
end