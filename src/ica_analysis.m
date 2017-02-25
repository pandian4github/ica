function [error_norm, error_norm_perm, cc_rms] = ica_analysis(S, M, W, plot_dir, sourceIndices, trial_num, eta, num_iterations)
% Run the ICA for the given set of sources and mixing matrix
% many trials

X = M*S; % mixed signals

numSrc = size(S, 1);
file_name = strcat(plot_dir, '/');
for i = 1: numSrc
    file_name = strcat(file_name, num2str(sourceIndices(i)));
    file_name = strcat(file_name, '_');
end
file_name = strcat(file_name, 'eta_');
file_name = strcat(file_name, num2str(eta));
file_name = strcat(file_name, '_iterations_');
file_name = strcat(file_name, num2str(num_iterations));
file_name = strcat(file_name, '_trial_');
file_name = strcat(file_name, num2str(trial_num));
file_name = strcat(file_name, '_');

original_file_name = strcat(file_name, 'original');
mixed_file_name = strcat(file_name, 'mixed');
recovered_file_name = strcat(file_name, 'recovered');

colors = [1, 2, 3, 4, 5];
plot_signals_save(S, colors, 'Source signal - ', sourceIndices, original_file_name);
colors = [3, 3, 3, 3, 3];
tmpIndices = [1, 2, 3, 4, 5];
plot_signals_save(X, colors, 'Mixed signal - ', tmpIndices, mixed_file_name);

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
plot_signals_save(Y3, matching, 'Recovered signal - ', recoveredIndices(1, :), recovered_file_name);

% Calculate permuted W matrix
W_perm = zeros(numSrc);
filled = zeros(1, numSrc);
for i = 1: numSrc
    % If two signals get matched to a single source signal, just use W
    % matrix for W_perm as well
    if (filled(1, matching(i)) == 1)
        W_perm = W;
        break;
    end
    W_perm(matching(i), :) = W(i, :);
    filled(1, matching(i)) = 1;
end

% Calculate the norm of inv(M) - W
M_inv = pinv(M);
error_norm = norm(W - M_inv);
error_norm_perm = norm(W_perm - M_inv);
cc_rms = get_rms_correlation_constants(Cv);

end

