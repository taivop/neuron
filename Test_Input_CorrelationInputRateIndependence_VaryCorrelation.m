
% vary correlation
correlation_exp_results = [];
corrs = [0 0.001 0.01 0.1 0.3 0.5 0.7 0.9 0.99 0.999 1];
input_rate = 30;
for exp_no=1:20
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
%ylim([input_rate-20, input_rate+20]);
xlabel('Correlation');
ylabel('Mean input rate per synapse');
title(sprintf('Input rate dependence on correlation, desired input rate is %dHz', input_rate));
hold on;
plot([0 1], [input_rate input_rate],'k--');
hold off;