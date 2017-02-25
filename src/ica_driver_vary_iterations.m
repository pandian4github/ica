function ica_driver()
% ICA Driver function to run different experiments

log_file = 'vary_iterations3.log';
num_trials = 3;
w_smallness_factor = [10, 10, 20, 30, 50, 40, 30, 20, 30, 10, 50, 10, 20, 30, 40, 50];
plot_dir = 'plots_vary_iterations3';
mkdir(plot_dir);

% Loads set of test source sounds into U (3*40) and mixing matrix into A
% (3*3)
load ../data/icaTest.mat
% Loads the source signals into sounds (5*44000)
load ../data/sounds.mat

diary(log_file);

fprintf('Running driver for source indices: ');
sourceIndices = [1, 3, 4];
disp(sourceIndices);

S = sounds(sourceIndices, :); % source signal matrix
numSrc = size(S, 1);
M = rand(numSrc, numSrc); % mixing matrix

% Precalculate set of W matrices which can be used for all learning rates
W_vec = zeros(num_trials, numSrc, numSrc);
for i = 1: num_trials
    W = rand(numSrc)./w_smallness_factor(i);
    W_vec(i, :, :) = W;
end

eta = 0.01;
disp(datestr(now));

iterations_vec = [];
error_norms_vec = [];
error_norms_perm_vec = [];
cc_rms_vec = [];

iterations_to_use = [10, 100, 1000, 10000, 100000];
for iterations = iterations_to_use
    iterations_vec = [iterations_vec iterations];
    disp(datestr(now));
    fprintf('---------------------------------- Number of iterations %i -------------------------------\n', iterations);
    total_norm = 0;
    total_norm_perm = 0;
    total_cc_rms = 0;
    for trial = 1: num_trials
        disp(datestr(now));
        fprintf('----------------------- Trial %i ------------------------\n', trial);
        % Initial guess for W matrix, the unmixing matrix
%         W = rand(size(M))./w_smallness_factor(trial);
        W = squeeze(W_vec(trial, :, :));
        
        [error_norm, error_norm_perm, cc_rms] = ica_analysis(S, M, W, plot_dir, sourceIndices, trial, eta, iterations);
        fprintf('Norm obtained: %f Permuted norm obtained: %f CC RMS obtained: %f\n', error_norm, error_norm_perm, cc_rms);
        total_norm = total_norm + error_norm;
        total_norm_perm = total_norm_perm + error_norm_perm;
        total_cc_rms = total_cc_rms + cc_rms;
    end
    avg_norm = total_norm / num_trials;
    avg_norm_perm = total_norm_perm / num_trials;
    avg_cc_rms = total_cc_rms / num_trials;
    error_norms_vec = [error_norms_vec avg_norm];
    error_norms_perm_vec = [error_norms_perm_vec avg_norm_perm];
    cc_rms_vec = [cc_rms_vec avg_cc_rms];
    fprintf('Average norm: %f Average permuted norm: %f CC RMS: %f\n', avg_norm, avg_norm_perm, avg_cc_rms);
end

fprintf('Iterations used: ');
disp(iterations_vec);
fprintf('Norms obtained: ');
disp(error_norms_vec);
fprintf('Permuted norms obtained: ');
disp(error_norms_perm_vec);
fprintf('Correlation constants RMS obtained: ');
disp(cc_rms_vec);

xlabel  = 'Number of iterations';
ylabel = 'Error norm';
title = 'Effect of number of iterations on error norm';

file_name = strcat(plot_dir, '/');
for i = 1: numSrc
    file_name = strcat(file_name, num2str(sourceIndices(i)));
    file_name = strcat(file_name, '_');
end
file_name = strcat(file_name, 'eta_');
file_name = strcat(file_name, num2str(eta));
file_name = strcat(file_name, '_');
file_name = strcat(file_name, 'num_iterations_vs_error_norm');

plot_norm_graph_save(iterations_vec, error_norms_vec, xlabel, ylabel, title, file_name);

% Plot the graph for permuted norms
file_name = strcat(plot_dir, '/');
for i = 1: numSrc
    file_name = strcat(file_name, num2str(sourceIndices(i)));
    file_name = strcat(file_name, '_');
end
file_name = strcat(file_name, 'eta_');
file_name = strcat(file_name, num2str(eta));
file_name = strcat(file_name, '_');
file_name = strcat(file_name, 'num_iterations_vs_error_norm_perm');

plot_norm_graph_save(iterations_vec, error_norms_perm_vec, xlabel, ylabel, title, file_name);

diary off;

% Plot the graph for CC RMS
ylabel = 'Correlation constants RMS';
title = 'Effect of learning rate on correlation constants RMS';
file_name = strcat(plot_dir, '/');
for i = 1: numSrc
    file_name = strcat(file_name, num2str(sourceIndices(i)));
    file_name = strcat(file_name, '_');
end
file_name = strcat(file_name, 'eta_');
file_name = strcat(file_name, num2str(eta));
file_name = strcat(file_name, '_');
file_name = strcat(file_name, 'num_iterations_vs_cc_rms');

plot_norm_graph_save(iterations_vec, cc_rms_vec, xlabel, ylabel, title, file_name);

end

