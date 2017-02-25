function plot_signals( S, D, label, originalIndices, file_name )
% Function to plot the source signals present in S matrix
    numSrc = size(S, 1);
    
    if (numSrc == 2)
        height = 2.5;
    elseif (numSrc == 3)
        height = 4;
    elseif (numSrc == 4)
        height = 6;
    elseif (numSrc == 5)
        height = 8;
    end
    
    fig = figure('PaperPosition',[.25 .25 8 height]);
    set(fig, 'Visible', 'off');
    rows = numSrc; 
    cols = 1;
    
    colors = ['r', 'g', 'b', 'm', 'y'];
    for i = 1: numSrc
        ax = subplot(rows, cols, i);
        plot(ax, S(i, :), colors(D(i)));
        
        % Add label just above the subplot
        mx = max(S(i, :));
        if (mx <= 0.5)
            y = mx + 0.5;
        elseif (mx <= 1.0)
            y = 1.5;
        elseif (mx <= 1.5)
            y = 2.5;
        elseif (mx <= 2.0)
            y = 2.5;
        else
            y = 3;
        end
%         text(0, y, strcat(label, num2str(originalIndices(i))));
    end
    
    print(fig, file_name, '-dpng');
%     clear title xlabel ylabel;
%     title('Source signals');
end

