% Generatesz two groups of trains.
% 1st group (1/2 of all synapses) gets 2 times the input rate as the 2nd.

function [spikes_binary, spiketimes] = GenerateInputSpikesGroups(nrSpikeTrains, rate_per_syn, c, T0, dt, fileName)

nrTrainsInGroup1 = round(nrSpikeTrains / 2);

[b1, t1] = GenerateInputSpikesMacke(nrTrainsInGroup1, rate_per_syn * 2, c, T0, dt, '');
[b2, t2] = GenerateInputSpikesMacke(nrSpikeTrains - nrTrainsInGroup1, rate_per_syn, c, T0, dt, '');

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










