num_synapses=100;
rate_per_syn=30;
c=0.51;
T0=1000;
dt=0.1;

[spikes_binary, spiketimes] = ...
    GenerateInputSpikesMacke(num_synapses, rate_per_syn, c, T0, dt, '');


%% plot spikes in raster plot and histogram of rates
imagesc(spikes_binary)
colormap(flipud(gray));

rates = sum(spiketimes~=0, 2) / (T0 / 1000);
figure();
hist(rates);


%% calculate correlations
c_res = corrcoef(spikes_binary');

% take mean pairwise correlation
mean_resulting_corr = mean(c_res(c_res ~= 1));


fprintf('Wanted correlation %.2f\nGot correlation %.2f\n', c, mean_resulting_corr);