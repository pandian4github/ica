function ica_driver_vary_eta()
% ICA Driver function to run different experiments

log_file = 'vary_eta4.log';
num_trials = 2;
w_smallness_factor = [10, 20, 20, 30, 50, 40, 30, 20, 30, 10, 50, 10, 20, 30, 40, 50];
plot_dir = 'plots_vary_eta4';
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

num_iterations = 100000;
disp(datestr(now));

eta_vec = [];
error_norms_vec = [];
error_norms_perm_vec = [];
cc_rms_vec = [];

etas = [0.001, 0.003, 0.006, 0.01, 0.02, 0.04, 0.06, 0.08, 0.1, 0.3, 0.6, 1.0];
etas = [0.0001, 0.001, 0.01, 0.1, 1.0];
for eta = etas
    eta_vec = [eta_vec eta];
    disp(datestr(now));
    fprintf('---------------------------------- Learning rate %f -------------------------------\n', eta);
    total_norm = 0;
    total_norm_perm = 0;
    total_cc_rms = 0;
    for trial = 1: num_trials
        disp(datestr(now));
        fprintf('----------------------- Trial %i ------------------------\n', trial);
        % Initial guess for W matrix, the unmixing matrix
%         W = rand(size(M))./w_smallness_factor(trial);
        W = squeeze(W_vec(trial, :, :));
        
        [error_norm, error_norm_perm, cc_rms] = ica_analysis(S, M, W, plot_dir, sourceIndices, trial, eta, num_iterations);
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

fprintf('Learning rates used: ');
disp(eta_vec);
fprintf('Norms obtained: ');
disp(error_norms_vec);
fprintf('Permuted norms obtained: ');
disp(error_norms_perm_vec);
fprintf('Correlation constants RMS obtained: ');
disp(cc_rms_vec);

xlabel  = 'Learning rate';
ylabel = 'Error norm';
title = 'Effect of learning rate on error norm';

file_name = strcat(plot_dir, '/');
for i = 1: numSrc
    file_name = strcat(file_name, num2str(sourceIndices(i)));
    file_name = strcat(file_name, '_');
end
file_name = strcat(file_name, 'iterations_');
file_name = strcat(file_name, num2str(num_iterations));
file_name = strcat(file_name, '_');
file_name = strcat(file_name, 'eta_vs_error_norm');

plot_norm_graph_save(eta_vec, error_norms_vec, xlabel, ylabel, title, file_name);

% Plot the graph for permuted norms
file_name = strcat(plot_dir, '/');
for i = 1: numSrc
    file_name = strcat(file_name, num2str(sourceIndices(i)));
    file_name = strcat(file_name, '_');
end
file_name = strcat(file_name, 'iterations_');
file_name = strcat(file_name, num2str(num_iterations));
file_name = strcat(file_name, '_');
file_name = strcat(file_name, 'eta_vs_error_norm_perm');

plot_norm_graph_save(eta_vec, error_norms_perm_vec, xlabel, ylabel, title, file_name);

% Plot the graph for CC RMS
ylabel = 'Correlation constants RMS';
title = 'Effect of learning rate on correlation constants RMS';

file_name = strcat(plot_dir, '/');
for i = 1: numSrc
    file_name = strcat(file_name, num2str(sourceIndices(i)));
    file_name = strcat(file_name, '_');
end
file_name = strcat(file_name, 'iterations_');
file_name = strcat(file_name, num2str(num_iterations));
file_name = strcat(file_name, '_');
file_name = strcat(file_name, 'eta_vs_cc_rms');

plot_norm_graph_save(eta_vec, cc_rms_vec, xlabel, ylabel, title, file_name);

diary off;

end

