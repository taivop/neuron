num_synapses = 100;

T0 = 1000;
dt = 0.1;
rate_per_syn = 30;
c = 0.5;

num_timesteps = T0 / dt;
proportion_spikes = rate_per_syn / num_timesteps;
variance_val = proportion_spikes * (1-proportion_spikes);

mu = repmat([proportion_spikes], 1, num_synapses)';    % set the means
v = mu.*(1-mu);     % calculate the variances
C = diag(v);        % build covariance matrix
C(C==0) = c * variance_val;

S = sampleDichGauss01(mu, C, num_timesteps);   % generate samples from the DG model

%% plot spikes in raster plot and histogram of rates
imagesc(S)
colormap(flipud(gray));

rates = sum(S, 2) / (T0 / 1000);
figure();
hist(rates);


%% calculate correlations
c_res = corrcoef(S');

% take mean pairwise correlation
mean_resulting_corr = mean(c_res(c_res ~= 1));

fprintf('Wanted correlation %.2f, got correlation %.2f\n', c, mean_resulting_corr);