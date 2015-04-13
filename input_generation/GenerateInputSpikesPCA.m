function [spikes_binary, spiketimes, desired_rates] = GenerateInputSpikesPCA()

num_synapses_per_pattern = 10;

% Create patterns with gaussian noise (sample from normal distribution with
% specified mean and stdev)
mu1 = 40;      % means
mu2 = 40;
sigma1 = 2;     % stdevs    
sigma2 = 10;
pattern1 = normrnd(mu1, sigma1, num_synapses_per_pattern, 1);
pattern2 = normrnd(mu2, sigma2, num_synapses_per_pattern, 1);

% Apply patterns to base of 10Hz
desired_rates = ones(100, 1) * 10;
desired_rates(20:20+num_synapses_per_pattern-1) = pattern1;
desired_rates(70:70+num_synapses_per_pattern-1) = pattern2;

% Generate spikes
[spikes_binary, spiketimes] = GenerateInputSpikesUncorrelated(100, desired_rates, 1000, 0.1, '');

end


%end