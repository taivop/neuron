res1 = load('data_out/results1');
res2 = load('data_out/results2');
res3 = load('data_out/results3');

figure;
hold on;

plot(res1.counts_group1, res1.rates_output);%, 'Color', [1 0 0]);
plot(res2.counts_group1, res2.rates_output);
plot(res3.counts_group1, res3.rates_output);

legend('Neuron 1', 'Neuron 2', 'Neuron 3');
xlabel('Number of synapses in pattern');
ylabel('Output rate, Hz')
title('')
