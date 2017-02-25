function [ C ] = get_correlation_matrix( A, B )
% Find correlation constants between original sources and obtained sources
% A - original sources; B - obtained sources; 
% C - numSrc * numSrc matrix containing the correlation constants between
% all pairs
    
    numSrc = size(A, 1);
    C = zeros(numSrc);
    for i = 1: numSrc
        for j = 1: numSrc
            C(i, j) = corr2(B(i, :), A(j, :));
        end
    end
    C

end

