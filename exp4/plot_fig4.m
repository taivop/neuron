res11 = load('data_out/results_1_1');
res12 = load('data_out/results_1_2');
res21 = load('data_out/results_2_1');
res22 = load('data_out/results_2_2');

figure;

plot(res11.counts_group1, res11.rates_output, 'Color', [1 0 0]);
hold on;
plot(res12.counts_group1, res12.rates_output, 'r');
plot(res21.counts_group1, res21.rates_output, 'b');
plot(res22.counts_group1, res22.rates_output, 'b');

legend('Neuron 1, run 1', 'Neuron 1, run 2', 'Neuron 2, run 1', 'Neuron 2, run 2');
xlabel('Number of synapses in pattern');
ylabel('Output rate, Hz')
title('')
