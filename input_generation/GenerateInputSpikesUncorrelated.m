% This function generates spike train data.
% Output:
%	Matrix(nrSpiketrains x T0/dt) spikes_binary -- shows whether each spiketrain had a spike in a given timebin
%	Matrix(nrSpiketrains x a) -- shows timebin numbers when the spiketrains had spikes. a is the maximum amount of spikes any given train had.
% Input:
%	nrSpikeTrains -- number of spike trains to generate, each spike train will be a row of the matrix.
%	rate -- (in Hz) the mean rate at which the spiketrains should have spikes.
%	T0 -- (in ms) the total amount of time for which the simulation should be done.
%	dt -- (in ms) the length of one timebin.
%	fileName -- the filename where output should be saved. If empty, no file will be saved.

function [spikes_binary, spiketimes] = GenerateInputSpikesUncorrelated(nrSpikeTrains, rate, T0, dt, fileName)

% Corner case: no input given
if rate == 0
    spikes_binary = zeros(nrSpikeTrains, T0/dt);
    spiketimes = [];
    return;
end;


spikes_binary = zeros(nrSpikeTrains, T0/dt);
spiketimes = [];

% Build spiketimes matrix
for i=1:nrSpikeTrains
    newRow = HomoPoisSpkGenTaivo(rate, T0/1000, dt)';
    if i==1
        spiketimes = newRow;
    else
        % zero-pad spiketimes matrix
        if(size(newRow, 2) > size(spiketimes, 2))
            % 'spiketimes' matrix should be padded
            padLength = size(newRow, 2) - size(spiketimes, 2);
            padding = zeros(size(spiketimes, 1), padLength);
            spiketimes = [spiketimes padding];
        else
            % 'newRow' should be padded
            padLength = size(spiketimes, 2) - size(newRow, 2);
            padding = zeros(1, padLength);
            newRow = [newRow padding];
        end;
        
        % vertcat 'newRow' to 'spiketimes'
        spiketimes = [spiketimes; newRow];
    end;
end;

% Round spiketimes to nearest timebin
spiketimes = round(spiketimes);

% Create spikes binary matrix
for i=1:nrSpikeTrains
    ithRow = spiketimes(i,:);

    for spktime=ithRow(ithRow ~= 0)
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