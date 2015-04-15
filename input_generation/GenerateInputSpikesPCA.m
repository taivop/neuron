function [spikes_binary, spiketimes, desired_rates] = GenerateInputSpikesPCA()

    num_synapses_per_pattern = 10;

    % Create patterns with gaussian noise (sample from normal distribution with
    % specified mean and stdev)
    mu1 = 40;      % means
    mu2 = 40;
    sigma1 = 0;     % stdevs    
    sigma2 = 15;
    pattern1 = normrnd(mu1, sigma1, num_synapses_per_pattern, 1);
    pattern2 = normrnd(mu2, sigma2, num_synapses_per_pattern, 1);
    
    spikes_binary = [];
    spiketimes = [];
    
    num_cycles = 10;
    for i=1:num_cycles
        % Apply patterns to base of 10Hz
        desired_rates = ones(100, 1) * 10;
        if rand() > 0.5
            desired_rates(20:20+num_synapses_per_pattern-1) = pattern1;
        else
            desired_rates(70:70+num_synapses_per_pattern-1) = pattern2;
        end;

        % Generate spikes
        [spikes_binary_1, spiketimes_1] = GenerateInputSpikesUncorrelated(1000/num_cycles, desired_rates, 100, 0.1, '');
        spikes_binary = [spikes_binary spikes_binary_1];
        spiketimes = [spiketimes spiketimes_1];
    end;
end


%end