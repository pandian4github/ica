function ica()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

test = 0;
sourceIndices = [1, 3, 4];
fs = 11025;
col_range = [10000: 10500];
file_name_prefix = strcat('cols_', num2str(col_range(1)));
file_name_prefix = strcat(file_name_prefix, '_');
file_name_prefix = strcat(file_name_prefix, num2str(col_range(length(col_range))));
file_name_prefix = strcat(file_name_prefix, '_');


% Loads set of test source sounds into U (3*40) and mixing matrix into A
% (3*3)
load ../data/icaTest.mat
% Loads the source signals into sounds (5*44000)
load ../data/sounds.mat

% S contains the set of signals used for the ICA experiment
% M is the mixer matrix
% numSrc - Number of source signals in S matrix
if test == 1
    S = U; 
    numSrc = size(S, 1);
    sourceIndices = [1, 2, 3];
    M = A;
else
    S = sounds(sourceIndices, :);
    numSrc = size(S, 1);
    M = rand(numSrc, numSrc);
end


% X is the set of mixed signals
X = M*S;

colors = [1, 2, 3, 4, 5];
plot_signals_save(S, colors, 'Source signal - ', sourceIndices, 'original');
plot_signals_save(S(:, col_range), colors, 'Source signal - ', sourceIndices, strcat(file_name_prefix, 'original'));
colors = [3, 3, 3, 3, 3];
tmpIndices = [1, 2, 3, 4, 5];
plot_signals_save(X, colors, 'Mixed signal - ', tmpIndices, 'mixed');
plot_signals_save(X(:, col_range), colors, 'Mixed signal - ', tmpIndices, strcat(file_name_prefix, 'mixed'));

eta = 0.01;
num_iterations = 10000;
% Initial guess for W matrix, the unmixing matrix
W = rand(size(M))./100;
W

for i = 1: num_iterations
    Y = W*X;
    Z = sigmoid(Y);
    I = eye(size(Y, 1));
    delW = eta * (I + (1-2*Z)*Y') * W;
    W = W + delW;
end

Y = W*X;
Y = (Y - min(min(Y))) ./ (max(max(Y)) - min(min(Y)));
Y2 = Y .* 2.0;
Y3 = Y2-1;

[D, Cv] = get_matching_indices(S, Y3);
matching = D(1, :);
recoveredIndices = zeros(1, numSrc);
for i = 1: numSrc
    recoveredIndices(1, i) = sourceIndices(matching(i));
end
% plot_signals_save(Y, matching, 'Recovered signal - ', recoveredIndices(1, :), 'recovered_raw');
plot_signals_save(Y3, matching, 'Recovered signal - ', recoveredIndices(1, :), 'recovered');
plot_signals_save(Y3(:, col_range), matching, 'Recovered signal - ', recoveredIndices(1, :), strcat(file_name_prefix, 'recovered'));

% Calculate permuted W matrix
W_perm = zeros(numSrc);
for i = 1: numSrc
    W_perm(matching(i), :) = W(i, :);
end
W_perm;


% Calculate the norm of inv(M) - W
M_inv = pinv(M);
nm = norm(W - M_inv);
nm
nm2 = norm(W_perm - M_inv);
nm2
rms = get_rms_correlation_constants(Cv);
rms

end

