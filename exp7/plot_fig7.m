
load('data_out/results_30Hz');

rates_output = rates_output';

% take only p >= some value
%rates_output = rates_output(:,4:end);
%ps = ps(4:end);

means = mean(rates_output);
stdevs = std(rates_output);

figure;

subplot(2,1,1);
hold on;

plot(ps, means);
plot(ps, means+stdevs,'r--');
plot(ps, means-stdevs,'r--');
title('Mean output rate');

subplot(2,1,2);
plot(ps, stdevs, 'r');
title('Standard deviation');
xlabel('Probability of release');