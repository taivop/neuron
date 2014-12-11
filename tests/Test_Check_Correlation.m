addpath('..');

dt = 0.1;
T0 = 1000;

[spikes_binary, spiketimes] = GenerateInputSpikes(100, 30, 1, T0, dt, '');
%check correlation coefficient
nrpairs = 100;
for i=1:1
    
    num_spikes_total = sum(sum(spiketimes ~= 0))
    
    aux =randperm(100);
    
    t1 = spiketimes(aux(1),:)*dt/1000;
    t2 = spiketimes(aux(2),:)*dt/1000;
    
    t1(t1==0) = [];
    t2(t2==0) = [];

    edges = 0:dt/1000:(T0/1000); % 1 ms bins

    t1_binned = histc(t1, edges); % timestamps to binned
    t2_binned = histc(t2, edges); % timestamps to binned
    xc = xcorr(t1_binned, t2_binned, 0); % actual crosscorrelation
    xc
    corrcoef(i) = max(xc)/mean(length(t1),length(t2));
end
coef = mean(corrcoef)