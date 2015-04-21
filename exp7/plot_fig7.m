for rate=[10 30 50]

    load(sprintf('data_out/results_%dHz', rate));

    rates_output = rates_output';

    % take only p >= some value
    %rates_output = rates_output(:,4:end);
    %ps = ps(4:end);

    means = mean(rates_output);
    stdevs = std(rates_output);

    f = figure;

    subplot(2,1,1);
    hold on;

    plot(ps, means, 'bx-', 'LineWidth', 2);
    plot(ps, means+stdevs,'r--');
    plot(ps, means-stdevs,'r--');
    title('Mean output rate');
    ylabel('Output rate, Hz');

    subplot(2,1,2);
    plot(ps, stdevs, 'r.--', 'MarkerSize', 15);
    title('Standard deviation');
    xlabel('Probability of release');
    ylabel('Output rate, Hz');
    
    savefig(f, sprintf('figures/res_%dHz.fig', rate));
    saveas(f, sprintf('figures/res_%dHz.png', rate));
    close(f);
end;