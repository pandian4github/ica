function plot_signals_cumulative( S, X, Y, D )
% Function to plot the source signals, mixed signals and obtained signals
% S - source signals; X - mixed signals; Y - recovered signals; D -
% matching indices
    numSrc = size(S, 1)
    figure
    cnt = 0;
    for i = 1: numSrc
        ax = subplot(numSrc * 3, 1, i);
        plot(ax, S(i, :));
    end
    cnt = cnt + numSrc;
    for i = 1: numSrc
        ax = subplot(numSrc * 3, 1, i + cnt);
        plot(ax, X(i, :));
    end
    cnt = cnt + numSrc;
    for i = 1: numSrc
        ax = subplot(numSrc * 3, 1, i + cnt);
        plot(ax, Y(i, :));
    end
    
end

