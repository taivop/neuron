num_timesteps = 10000;
num_synapses = 100;

mean_val = 0.1;
stdev_val = sqrt(mean_val * (1-mean_val));

mu = repmat([mean_val], 1, num_synapses)';    % set the mean
v = mu.*(1-mu);     % calculate the variances
C = diag(v);        % build covariance matrix
C(20:30,20:30) = 0.95 * stdev_val^2;
C(find(eye(size(C)))) = v;

[S,g,L] = sampleDichGauss01(mu,C,num_timesteps);   % generate samples from the DG model

% plot spikes in raster plot
imagesc(S)
colormap(flipud(gray));