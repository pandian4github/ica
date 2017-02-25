function ica_driver()
% ICA Driver function to run different experiments

log_file = 'vary_iterations1.log';
num_trials = 10;
plot_dir = 'plots_vary_iterations111';
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

eta = 0.01;
disp(datestr(now));

iterations_vec = [];
error_norms_vec = [];

for iterations = 5000: 5000: 100000
    iterations_vec = [iterations_vec iterations];
    disp(datestr(now));
    fprintf('---------------------------------- Number of iterations %i -------------------------------\n', iterations);
    total_norm = 0;
    for trial = 1: num_trials
        disp(datestr(now));
        fprintf('----------------------- Trial %i ------------------------\n', trial);
        % Initial guess for W matrix, the unmixing matrix
        W = rand(size(M))./10;
        
        error_norm = ica_analysis(S, M, W, plot_dir, sourceIndices, trial, eta, iterations);
        fprintf('Norm obtained: %f\n', error_norm);
        total_norm = total_norm + error_norm;
    end
    avg_norm = total_norm / num_trials;
    error_norms_vec = [error_norms_vec avg_norm];
    fprintf('Average norm: %f\n', avg_norm);
end

fprintf('Iterations used: ');
disp(iterations_vec);
fprintf('Norms obtained: ');
disp(error_norms_vec);

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

diary off;

end

