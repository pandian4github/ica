function plot_signals()
% Function to plot the source signals present in S matrix
    X = [10, 100, 1000, 10000, 30000, 50000, 70000, 90000, 100000, 130000, 150000, 170000, 190000, 200000];
    Y = [2, 3, 4, 22, 58, 94, 133, 166, 185, 243, 274, 315, 342, 362];
    x_label = 'Number of iterations';
    y_label = 'Time taken (secs)';
    title_ = 'Number of iterations vs time taken';
    file_name = 'time_taken_plot';
    
    clear title xlabel ylabel;
    
    fig = figure;
    set(fig, 'Visible', 'off');
    
    plot(X, Y);
    xlabel(x_label);
    ylabel(y_label);
    title(title_);
        
    print(fig, file_name, '-dpng');
%     clear title xlabel ylabel;
%     title('Source signals');
end

