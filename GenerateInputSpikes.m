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

function [spikes_binary, spiketimes] = GenerateInputSpikes(nrSpikeTrains, rate_total, c, T0, dt, fileName)

rate = rate_total;

if (c == 0)
    % how many spikes are we generating in total?
    num_all_spikes = round(rate*T0/1000);
    
    % assign each spike to some synapse
    spikes_assigned = randi(nrSpikeTrains,num_all_spikes,1);
    
    % initialise array of spiketimes; width is num_all_spikes
    spiketimes = zeros(nrSpikeTrains, num_all_spikes);
    
    spikes_binary = zeros(nrSpikeTrains, T0/dt);
    for i=1: nrSpikeTrains
        % how many spikes does this particular synapse get?
        num_spikes_for_this = size(spikes_assigned(spikes_assigned == i),1);
        %fprintf('synapse %d, %d spikes\n', i, num_spikes_for_this);
        
        % divide the spikes assigned to this synapse randomly over time T0
        spiketime_vector = sort(rand(1, num_spikes_for_this) * T0/dt);
        
        % zero-pad the vector and add to spiketimes matrix
        spiketimes(i,:) = horzcat(spiketime_vector, zeros(1,num_all_spikes-num_spikes_for_this)); 
        
        for j=1:size(spiketimes,2)
            if spiketimes(i,j) ~= 0
                spikes_binary(i,ceil(spiketimes(i,j):spiketimes(i,j)+1/dt-1)) = 1;
            end;
        end
    end
    spikes_binary(:,(T0/dt+1):end) = [];
    
    % crop un-necessary zeros from spiketimes matrix
    [nonZeroRows nonZeroColumns] = find(spiketimes);
    rightColumn = max(nonZeroColumns(:));
    spiketimes = spiketimes(1:end, 1:rightColumn);       
    
else
    
    % rate = rate_total / nrSpikeTrains; % divide the spikes between all synapses
    
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

