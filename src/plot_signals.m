function plot_signals( S, D, label, originalIndices )
% Function to plot the source signals present in S matrix
    numSrc = size(S, 1);
    
    if (numSrc == 1 || numSrc == 2 || numSrc == 3)
        rows = numSrc;
        cols = 1;
    elseif (numSrc == 4)
        rows = 2;
        cols = 2;
    elseif (numSrc == 5)
        rows = 3;
        cols = 2;
    end
    rows = numSrc; 
    cols = 1;
    
    figure
    colors = ['r', 'g', 'b', 'm', 'y'];
    for i = 1: numSrc
        ax = subplot(rows, cols, i);
        plot(ax, S(i, :), colors(D(i)));
        
        % Add label just above the subplot
        mx = max(S(i, :));
        if (mx <= 0.5)
            y = 1;
        elseif (mx <= 1.0)
            y = 1.5;
        elseif (mx <= 1.5)
            y = 2.5;
        elseif (mx <= 2.0)
            y = 2.5;
        else
            y = 3;
        end
        text(0, y, strcat(label, num2str(originalIndices(i))));
    end
%     clear title xlabel ylabel;
%     title('Source signals');
end

