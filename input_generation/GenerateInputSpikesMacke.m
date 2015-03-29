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
%	fileName -- the filename where output should be saved. If empty, no file will be saved
function [spikes_binary, spiketimes, c_actual] = GenerateInputSpikesMacke(num_synapses, rate_per_syn, c, T0, dt, fileName)

num_timesteps = T0 / dt;

%% Build covariance matrix
proportion_spikes = rate_per_syn / num_timesteps;
variance_val = proportion_spikes * (1-proportion_spikes);

mu = repmat([proportion_spikes], 1, num_synapses)';    % set the means
v = mu.*(1-mu);     % calculate the variances
C = diag(v);        % build covariance matrix
C(C==0) = c * variance_val;

%% Make binary matrix with Macke's function
spikes_binary = sampleDichGauss01(mu,C,num_timesteps);   % generate samples from the DG model

%% Create spiketimes matrix and convert binary matrix into good form for us
% Finding every occurrence of 1 and adding 1/dt ones to follow it.
spiketimes = [];
num_ones = 1 / dt;
for i=1:num_synapses
    spiketimes_row = find(spikes_binary(i,:) == 1);
    spiketimes(i,1:length(spiketimes_row)) = spiketimes_row;
    for ind_start=spiketimes_row
        ind_end = min(ind_start + num_ones, num_timesteps);
        spikes_binary(i,ind_start:ind_end) = 1;
    end;
end;

c_pairwise = corrcoef(spikes_binary');
c_actual = mean(c_pairwise(c_pairwise ~= 1));

%% Save to file if necessary
if (fileName ~= 0)
	cd data_in;
	save('-mat7-binary', fileName, 'spikes_binary', 'spiketimes');
	%save filename.mat -mat7-binary spikes_binary spiketimes;
	cd ..;
end

end

