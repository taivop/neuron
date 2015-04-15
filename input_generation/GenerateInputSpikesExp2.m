function [spikes_binary, spiketimes] = GenerateInputSpikesExp2(exp, T0, dt, fileName)
    
    % If we want to put group1 to synapses 76-100, not 1-25, then exp_swap
    % should be set to 1.
    if exp.swap
        [b1, t1] = GenerateInputSpikesUncorrelated(75, exp.rate_group2, T0, dt, '');
        [b2, t2] = GenerateInputSpikesUncorrelated(25, exp.rate_group1, T0, dt, '');
    else
        [b1, t1] = GenerateInputSpikesUncorrelated(25, exp.rate_group1, T0, dt, '');
        [b2, t2] = GenerateInputSpikesUncorrelated(75, exp.rate_group2, T0, dt, '');
    end;

    spikes_binary = vertcat(b1, b2);

    % pad t1 or t2 with zeros to vertcat them
    if size(t1, 2) > size(t2, 2)
        % need to pad t2
        pad_extent = abs(size(t1, 2) - size(t2, 2));
        t2 = [t2 zeros(size(t2,1), pad_extent)];
    elseif size(t1, 2) < size(t2, 2)
        % need to pad t1
        pad_extent = abs(size(t1, 2) - size(t2, 2));
        t1 = [t1 zeros(size(t1,1), pad_extent)];
    end;

    spiketimes = vertcat(t1, t2);
end










