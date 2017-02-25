function [ Z ] = sigmoid( Y )
% Calculate the sigmoid of each value of Y and store in Z
%     Z = sigmf(Y, [1, 0])
    Z = zeros(size(Y));
    Z = 1./(1 + exp(-Y));
end

