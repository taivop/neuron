% Generatesz two groups of trains.
% 1st group (25 synapses) gets 40Hz input, the 2nd group (75 synapses) gets
% 10Hz.

function [spikes_binary, spiketimes] = GenerateInputSpikesGroupsStochastic(T0, dt, fileName)

    [b1, t1] = GenerateInputSpikesUncorrelated(25, 40, T0, dt, '');
    [b2, t2] = GenerateInputSpikesUncorrelated(75, 10, T0, dt, '');

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
    
    % randomly select channel to receive higher input
    channel = randi(4);
    % swap spiketrains
    if channel ~= 1
        b_src = spikes_binary(1:25,:);
        t_src = spiketimes(1:25,:);
        b_dst = spikes_binary(1+25*(channel-1):25*channel,:);
        t_dst = spiketimes(1+25*(channel-1):25*channel,:);
        
        spikes_binary(1:25,:) = b_dst;
        spiketimes(1:25,:) = t_dst;
        spikes_binary(1+25*(channel-1):25*channel,:) = b_src;
        spiketimes(1+25*(channel-1):25*channel,:) = t_src;
    end;

end










