% Generatesz two groups of trains.
% 1st group (25 synapses) gets 40Hz input, the 2nd group (75 synapses) gets
% 10Hz.

function [spikes_binary, spiketimes] = GenerateInputSpikesGroups(T0, dt, fileName)

    [b1, t1] = GenerateInputSpikesUncorrelated(25, 40, T0, dt, '');
    [b2, t2] = GenerateInputSpikesMacke(75, 10, T0, dt, '');

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
end;

end










