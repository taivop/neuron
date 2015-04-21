function [spikes_binary, spiketimes] = GenerateInputSpikesExp8(exp, T0, dt, ~)
    % Get spike trains
    [sb, st] = GenerateInputSpikesMacke(100, exp.rate, exp.input_correlation, T0, dt, '');

    % Apply probability of release
    if exp.p < 1
        [spikes_binary, spiketimes] = ProbabilityOfRelease(exp.p, sb, st);
    end;
end










