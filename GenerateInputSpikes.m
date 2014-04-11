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

function [spikes_binary, spiketimes] = GenerateInputSpikes(nrSpikeTrains, rate, c, T0, dt, fileName)

if (c == 0)
    spikes_binary = zeros(nrSpikeTrains, T0/dt);
    for i=1: nrSpikeTrains
        spiketimes(i,:) = sort(rand(1, round(rate*T0/1000)) * T0/dt);
        for j=1:size(spiketimes,2)
            spikes_binary(i,ceil(spiketimes(i,j):spiketimes(i,j)+1/dt-1)) = 1;
        end
    end
    spikes_binary(:,(T0/dt+1):end) = [];
else
    
    mother_rate = rate/c;
    spiketimesMother = sort(rand(1, round(mother_rate*T0/1000)) * T0/dt);
    spikes_binary = zeros(nrSpikeTrains, T0/dt);
    
    for i=1: nrSpikeTrains
        aux = spiketimesMother(rand(size(spiketimesMother))<c);
        spiketimes(i,1:length(aux)) = aux;
     
        for j=1:length(aux)
            spikes_binary(i,ceil(aux(j):aux(j)+1/dt-1)) = 1;
        end
    end
    spikes_binary(:,(T0/dt+1):end) = [];
end

if (fileName ~= 0)
	cd data_in;
	save('-mat7-binary', fileName, 'spikes_binary', 'spiketimes');
	%save filename.mat -mat7-binary spikes_binary spiketimes;
	cd ..;
end

end

