for rate=[10 30 50]

    load(sprintf('data_out/results_%dHz', rate));

    rates_output = rates_output';

    % take only p >= some value
    %rates_output = rates_output(:,4:end);
    %ps = ps(4:end);

    means = mean(rates_output);
    stdevs = std(rates_output);

    f = figure;
    set(f, 'units', 'inches', 'pos', [2 2 5.77 4.3275])

    subplot(2,1,1);
    hold on;

    plot(ps, means, 'b.-', 'LineWidth', 2, 'MarkerSize', 20);
    plot(ps, means+stdevs,'r--');
    plot(ps, means-stdevs,'r--');
    title('Mean');
    ylabel('Mean output rate, Hz');

    subplot(2,1,2);
    plot(ps, stdevs, 'r.--', 'MarkerSize', 10);
    title('Standard deviation');
    xlabel('Probability of release');
    ylabel('SD of output rate, Hz');
    
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperPosition', [2 2 5.77 4.3275]);

    print(sprintf('../../bscthesis/figures/exp7_PRoutputvariance_%dHz.eps', rate), '-depsc');
    close(f);
end;