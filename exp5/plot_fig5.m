
res = load('data_out/results2');
comp  = load('data_out/results_comparison3');

figure;
plot(res.counts_group1, res.rates_output);
hold on;
plot(comp.counts_group1, comp.rates_output, '--');

legend('Neuron trained with high-rate channel', 'Neuron trained on flat input');
xlabel('Number of synapses receiving higher-rate input');
ylabel('Output rate, Hz')
title('')


hold off;