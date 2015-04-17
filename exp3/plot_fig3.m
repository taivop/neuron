res = load('data_out/results');
comp = load('data_out/results_comparison'); % comparison

adjustment = 0*ones(size(comp.correlations)) * mean(res.rates_output - comp.rates_output);

plot(res.correlations, res.rates_output);
hold on;
plot(comp.correlations, comp.rates_output + adjustment, '--');

legend('Trained with correlated channel', 'Trained without correlation');

xlabel('Correlation coefficient of 25-synapse input channel');
ylabel('Output rate, Hz')
title('')
