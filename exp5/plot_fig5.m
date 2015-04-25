
res = load('data_out/results2');
comp  = load('data_out/results_comparison3');

f = figure;
set(f, 'units', 'inches', 'pos', [2 2 5.77 4.3275])

plot(res.counts_group1, res.rates_output, '.-', 'MarkerSize', 20, 'LineWidth', 2);
hold on;
plot(comp.counts_group1, comp.rates_output, '.--', 'MarkerSize', 20, 'LineWidth', 2);

legend({'Neuron trained with high-rate channel', 'Neuron trained on flat input'},...
    'Location', 'northwest');
xlabel('Number of synapses receiving higher-rate input');
ylabel('Output rate, Hz')
%title('')

set(gca,'fontsize', 13);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 2 5.77 4.3275]);
print('../../bscthesis/figures/exp5_patterncompletion.eps', '-depsc');
%saveas(f, '../../bscthesis/figures/exp5_patterncompletion.eps', 'eps');
hold off;