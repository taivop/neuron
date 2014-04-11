function [spikes_binary, spiketimes, coef] = CorrelatedInputSpikes(nrSpikeTrains, rate, c, T0,dt)

% clear all;
% rate = 30;  %Hz
% T0 = 5000;                      % Simulation time (ms)
% dt = 0.1; 
% nrSpikeTrains =100;
% 
% c = 0.1;

if (c ==0)
    
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

%check correlation coefficient
%{
nrpairs = 100;
for i=1:nrpairs
    
    aux =randperm(nrSpikeTrains);
    
    t1 = spiketimes(aux(1),:)*dt/1000;
    t2 = spiketimes(aux(2),:)*dt/1000;
    t1(t1==0) = [];
    t2(t2==0) = [];

    edges = 0:dt/1000:(T0/1000); % 1 ms bins

    t1_binned = histc(t1, edges); % timestamps to binned
    t2_binned = histc(t2, edges); % timestamps to binned
    %xc = corr(t1_binned, t2_binned); % actual crosscorrelation

    corrcoef(i) = max(xc)/mean(length(t1),length(t2));
end
%}
coef = 0;%mean(corrcoef);




end

