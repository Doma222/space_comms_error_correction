function Hamming_plot(EbNo_vec, ber_vec_h, ber_vec_og ,hamming_m, distance_vec)

    n = 2^hamming_m - 1;
    k = 2^hamming_m - hamming_m - 1;
    
    figure('Color', 'w');
    
    % to show 0 errors on graph 
    ber_plot_h = ber_vec_h;
    ber_plot_og = ber_vec_og;

    ber_plot_h(ber_plot_h == 0) = 1e-5;
    ber_plot_og(ber_plot_og == 0) = 1e-5;
    
    
    % Plot Hamming results
    semilogy(EbNo_vec, ber_plot_h, 'bo-', ...
        'LineWidth', 1.8, ...
        'MarkerSize', 6, ...
        'MarkerFaceColor', 'b');
    
    hold on;

    % Plot Original results
    semilogy(EbNo_vec, ber_plot_og, 'ro-', ...
        'LineWidth', 1.5, ...
        'MarkerSize', 5, ...
        'MarkerFaceColor', 'k');
    
    % Plot Theoretical Uncoded BPSK
    %theory_ber = berawgn(EbNo_vec, 'psk', 2, 'nondiff');
    %semilogy(EbNo_vec, theory_ber, '-r', 'LineWidth', 1.5);
    
    hold off;
    
    % Formatting & Labels
    grid on;
    grid minor;

    set(gca, 'XScale', 'log');
    set(gca, 'XTick', distance_vec);

    formatted_labels = arrayfun(@(x) sprintf('%.3f', x), distance_vec, 'UniformOutput', false);
    set(gca, 'XTickLabel', formatted_labels);

    xlabel('Distance (Millions of km)', 'FontSize', 11, 'FontWeight', 'bold');
    ylabel('Bit Error Rate (BER)', 'FontSize', 11, 'FontWeight', 'bold');
    title(sprintf('Hamming (%d,%d) Code Performance over AWGN', n, k), ...
        'FontSize', 12, 'FontWeight', 'bold');
    
    xlim([EbNo_vec(1) EbNo_vec(end)]);
    ylim([1e-5 1]);
    
    legend({sprintf('Hamming (%d,%d) Sim', n, k), 'Uncoded Sim'}, ...
        'Location', 'northwest', 'FontSize', 10);
end