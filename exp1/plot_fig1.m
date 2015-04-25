
res = load('data_out/results');
comp  = load('data_out/results_comparison');

f = figure;
set(f, 'units', 'inches', 'pos', [2 2 5.77 4.3275])
hold on;

plot(res.rates_group1, res.rates_output, '.-', 'MarkerSize', 10);
plot(comp.rates_group1, comp.rates_output, '.--', 'MarkerSize', 10);

legend('Neuron trained with high-rate channel', 'Neuron trained on flat input');
xlabel('Input rate to potentiated group, Hz');
ylabel('Output rate, Hz')
%title('Filter implemented by the neuron: the dependence of output rate on the degree of trained input present')
line([17.5 17.5], [35 75], 'LineStyle', ':', 'Color', 'k')


set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 2 5.77 4.3275]);
print('../../bscthesis/figures/exp1_filter.eps', '-depsc');
%saveas(f, '../../bscthesis/figures/exp1_filter.eps', 'eps');

hold off;