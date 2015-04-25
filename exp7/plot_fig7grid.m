rates = [10 30 50];
f = figure;
set(f, 'units', 'inches', 'pos', [2 2 5.77*2 4.3275])

for i=1:size(rates, 2)
    rate = rates(i);
    load(sprintf('data_out/results_%dHz', rate));

    rates_output = rates_output';

    % take only p >= some value
    %rates_output = rates_output(:,4:end);
    %ps = ps(4:end);

    means = mean(rates_output);
    stdevs = std(rates_output);

    subplot(2,3,i);
    hold on;

    plot(ps, means, 'b.-', 'LineWidth', 2, 'MarkerSize', 20);
    plot(ps, means+stdevs,'r--');
    plot(ps, means-stdevs,'r--');
    set(gca,'fontsize', 13);
    title(sprintf('%dHz', rate));
    ylim([0 120]);
    if i==1
        ylabel('Mean output rate, Hz');
    end;

    subplot(2,3,i+3);
    plot(ps, stdevs, 'r.--', 'MarkerSize', 10);
    set(gca,'fontsize', 13);
    %title('Standard deviation');
    xlabel('Probability of release');
    ylim([0 8]);
    if i==1
        ylabel('SD of output rate, Hz');
    end;
end;

set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 2 5.77*2 4.3275]);

print('../../bscthesis/figures/exp7_PRoutputvariance_grid.eps', '-depsc');