function plot_signals( X, Y, x_label, y_label, title_, file_name )
% Function to plot the source signals present in S matrix
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

