
res = load('data_out/results');
comp  = load('data_out/results_comparison');

figure;
plot(res.rates_group1, res.rates_output);
hold on;
plot(comp.rates_group1, comp.rates_output, '--');

legend('Neuron trained with high-rate channel', 'Neuron trained on flat input');
xlabel('Input rate to potentiated group, Hz');
ylabel('Output rate, Hz')
title('Filter implemented by the neuron: the dependence of output rate on the degree of trained input present')
line([17.5 17.5], [35 75], 'LineStyle', ':', 'Color', 'k')


hold off;