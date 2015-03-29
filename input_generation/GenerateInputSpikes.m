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

function [spikes_binary, spiketimes] = GenerateInputSpikes(nrSpikeTrains, rate_per_syn, c, T0, dt, fileName)

error('(Taivo) Cannot use GenerateInputSpikes because it does not produce correct spikes_binary matrix.');

rate = rate_per_syn;
spikes_binary = zeros(nrSpikeTrains, T0/dt);

% rate = rate_total / nrSpikeTrains; % divide the spikes between all synapses
N0 = round(nrSpikeTrains + sqrt(c) * (1 - nrSpikeTrains));
%fprintf('N0 = %d\n', N0);

% pregenerate Poissonian trains and put the spiketimes in one big vector
MULTIPLY_HOW_MANY_TIMES = nrSpikeTrains/N0;

spktimes_Poisson = [];
for i=1:N0
    SpkTime = HomoPoisSpkGenTaivo(rate * MULTIPLY_HOW_MANY_TIMES, T0/1000, dt);
    spktimes_Poisson = [spktimes_Poisson; SpkTime];
    %SpkTime = HomoPoisSpkGenTaivo(rate, T0/1000, dt);
    %spktimes_Poisson = [spktimes_Poisson; repmat(SpkTime, round(MULTIPLY_HOW_MANY_TIMES), 1)];
end;

% sort spike times
spktimes_Poisson = sort(spktimes_Poisson);

% round spikes to nearest timebin
spktimes_Poisson = round(spktimes_Poisson);
% if was rounded to 0, assign 1. Maybe should remove completely?
%spktimes_Poisson(spktimes_Poisson == 0) = 1;

% assign each spike to some spike train
master_mask = randi([1,nrSpikeTrains],size(spktimes_Poisson));

for i=1: nrSpikeTrains
    mySpikes = sort(spktimes_Poisson(master_mask == i));
    spiketimes(i,1:length(mySpikes)) = mySpikes;

    for spktime=mySpikes(mySpikes ~= 0)
        spikes_binary(i,ceil(spktime:spktime+1/dt-1)) = 1;
    end
end
spikes_binary(:,(T0/dt+1):end) = [];


% Save to file if necessary
if (fileName ~= 0)
	cd data_in;
	save('-mat7-binary', fileName, 'spikes_binary', 'spiketimes');
	%save filename.mat -mat7-binary spikes_binary spiketimes;
	cd ..;
end

end

