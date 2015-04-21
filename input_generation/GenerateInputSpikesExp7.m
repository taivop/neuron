function [spikes_binary, spiketimes] = GenerateInputSpikesExp7(exp, T0, dt, ~)
    
    rate_adjusted = exp.rate / exp.p;
    p = exp.p;
    
    % Get one spike train
    [sb, st] = GenerateInputSpikesUncorrelated(1, rate_adjusted, T0, dt, '');
    
    % Copy this spike train into all synapses
    spiketimes = repmat(st, 100, 1);
    spikes_binary = repmat(sb, 100, 1);
    
    % Apply probability of release
    if p < 1
        [spikes_binary, spiketimes] = ProbabilityOfRelease(p, spikes_binary, spiketimes);
    end;
end










