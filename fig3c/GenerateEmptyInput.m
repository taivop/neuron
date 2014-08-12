% This function generates spike train data.
% Output:
%	Matrix(nrSpiketrains x T0/dt) spikes_binary -- shows whether each spiketrain had a spike in a given timebin
%	Matrix(nrSpiketrains x a) -- shows timebin numbers when the spiketrains had spikes. a is the maximum amount of spikes any given train had.
% Input:
%   deltaT -- shows how large should be the time lag between 500ms mark and spike

% Assuming dt = 0.1ms, spike train length is 1 second.

function [spikes_binary, spiketimes] = GenerateEmptyInput_STDP()

spikes_binary = zeros(1,10000);
spiketimes = [];

end

