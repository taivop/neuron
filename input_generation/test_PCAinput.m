
[spikes_binary, spiketimes, desired_rates] = GenerateInputSpikesPCA();

actual_rates = sum(spiketimes~=0, 2);

plot(desired_rates);
ylim([0 100]);
hold on;
plot(actual_rates);

legend('desired', 'actual');
hold off;