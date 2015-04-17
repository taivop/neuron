function [spikes_binary, spiketimes] = GenerateInputSpikesExp5(exp, T0, dt, ~)
    
    [b2, t2] = GenerateInputSpikesUncorrelated(exp.count_group2, exp.rate_group2, T0, dt, '');
    
    % If there are no synapses in group 1
    if exp.count_group1 == 0
        spikes_binary = b2;
        spiketimes = t2;
        return;
    end;
    
    [b1, t1] = GenerateInputSpikesUncorrelated(exp.count_group1, exp.rate_group1, T0, dt, '');
    
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