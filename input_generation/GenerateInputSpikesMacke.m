% This function generates spike train data.
% Output:
%	Matrix(nrSpiketrains x T0/dt) spikes_binary -- shows whether each spiketrain had a spike in a given timebin
%	Matrix(nrSpiketrains x a) -- shows timebin numbers when the spiketrains had spikes. a is the maximum amount of spikes any given train had.
% Input:
%	nrSpikeTrains -- number of spike trains to generate, each spike train will be a row of the matrix.
%	rate -- (in Hz) the mean rate at which the spiketrains should have spikes.
%	c -- the desired correlation coefficient between the spikes.
%	T0 -- (in ms) the total amount of time for which the simulation should be done.
%	dt -- (in ms) the length of one timebin.
%	fileName -- the filename where output should be saved. If empty, no file will be saved.

function [spikes_binary, spiketimes] = GenerateInputSpikesMacke(num_synapses, rate_per_syn, c, T0, dt, fileName)

num_timesteps = T0 / dt;

%% Build covariance matrix
proportion_spikes = rate_per_syn / num_timesteps;
variance_val = proportion_spikes * (1-proportion_spikes);

mu = repmat([proportion_spikes], 1, num_synapses)';    % set the means
v = mu.*(1-mu);     % calculate the variances
C = diag(v);        % build covariance matrix
C(C==0) = c * variance_val;

%% Make binary matrix with Bethge's function
S = sampleDichGauss01(mu,C,num_timesteps);   % generate samples from the DG model

%% Convert binary matrix into good form for us
% TODO do this by finding every occurrence of 1 and add ten
% (or eleven -- need to check) 1-s following it.

%% Make spiketimes matrix
spiketimes = [];
for i=1:num_synapses
    spiketimes_row = find(S(i,:) == 1);
    spiketimes = [spiketimes; spiketimes_row]; % TODO also need to zero-pad the row
end;


%% Save to file if necessary
if (fileName ~= 0)
	cd data_in;
	save('-mat7-binary', fileName, 'spikes_binary', 'spiketimes');
	%save filename.mat -mat7-binary spikes_binary spiketimes;
	cd ..;
end

end

