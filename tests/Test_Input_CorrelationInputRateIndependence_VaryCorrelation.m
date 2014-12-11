addpath('..');

% vary correlation
correlation_exp_results = [];
corrs = [0.001 0.01 0.03 0.05 0.1 0.3 0.5 0.7 0.9 0.99 0.999];
input_rate = 30;
num_experiments = 9;

fprintf('Running tests to see the rate of generated input as a function of desired correlation.\n');
fprintf('Ideally, the resulting graph should be constant at desired input rate (%d in this test).\n', input_rate);
fprintf('Now running %d experiments...\n', num_experiments);

for exp_no=1:num_experiments
    fprintf('\tExperiment %2d\n', exp_no);
    mean_rates_corr = [];
    for correlation=corrs
        [spikes_binary, spiketimes] = GenerateInputSpikes(100, input_rate, correlation, 1000, 0.1, '');
        mean_rate_per_syn = mean(sum(spiketimes ~= 0, 2));
        mean_rates_corr = [mean_rates_corr mean_rate_per_syn];
    end;
    correlation_exp_results = [correlation_exp_results; mean_rates_corr];
end;


plot(corrs, correlation_exp_results);
xlim([0 1]);
ylim([input_rate * 0.5 input_rate * 1.5]);
%ylim([input_rate-20, input_rate+20]);
xlabel('Correlation');
ylabel('Mean input rate per synapse');
title(sprintf('Input rate dependence on correlation, desired input rate is %dHz', input_rate));
hold on;
plot([0 1], [input_rate input_rate],'k--');
hold off;