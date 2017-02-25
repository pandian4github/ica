function [ D, Cv ] = get_matching_indices( A, B )
% D - vector of size numSrc matching obtained sources with indices of
% original sources
% A - original sources; B - obtained sources; 
    
    C = get_correlation_matrix(A, B);
    Cv = [];
    numSrc = size(A, 1);
    D = zeros(1, numSrc);
    CC = zeros(1, numSrc);
    for i = 1: numSrc
        [c, I] = max(abs(C(i, :)));
        Cv = [Cv c];
        D(1, i) = I;
    end

end

