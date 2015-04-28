load('data_100s_meta_cluster');

T0 = T0/4;

exc_weights = g_plas_history(1:100,1:T0/100);
mean_evolution = mean(exc_weights, 1);
stdev_evolution = std(exc_weights, 0, 1);

%mean_evolution = smooth(mean_evolution, 3);
%stdev_evolution = smooth(stdev_evolution, 3);

x = linspace(0, T0/1000 * 100 / 3600 * 60, size(mean_evolution,2));

f = figure;
set(f, 'units', 'inches', 'pos', [2 2 5.77*2 4.3275/2])
axis tight;
ylim([1 2]);

hold on;
std_top = area(x, mean_evolution+stdev_evolution, 'EdgeColor', 'none', ...
    'FaceColor', [206 206 206]/256);
h = plot(x, mean_evolution, 'b-', 'LineWidth', 1);
std_bottom = area(x, mean_evolution-stdev_evolution, 'EdgeColor', 'none', ...
    'FaceColor', 'white');

legend('1SD range', 'Mean weight');
xlabel('Time, min');
ylabel('Synaptic weight');
hold off;

% metaplasticity kicks in and spreads the weights
set(gca,'fontsize', 13);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 2 5.77*2 4.3275/2]);

print('../../../bscthesis/figures/valid_metaplasticity_evolution.eps', '-depsc');