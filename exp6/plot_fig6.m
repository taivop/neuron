
load('data_out/results');

smooth_window1 = 0.1;
smooth_window2 = 1;
dt = 0.1;

time_in_sec = T0 / 1000;

bool = zeros(1, T0/dt);
bool(spikes_post) = 1000/dt;
bool_raw = bool / (1000/dt);

%% Smoothing
smoothed1 = smooth(bool, smooth_window1*1000/dt);
smoothed2 = smooth(bool, smooth_window2*1000/dt);

%% Calculating mean rates
low_secs = (0:2:16);
high_secs = (1:2:17);

bool1 = zeros(1, T0/dt);
bool1(spikes_post) = 1;

total_low = 0;
for s=low_secs
    total_low = total_low + sum(bool1(s*10000+1:(s+1)*10000));
end;

total_high = 0;
for s=high_secs
    total_high = total_high + sum(bool1(s*10000+1:(s+1)*10000));
end;

rate_low = total_low/size(low_secs, 2)
rate_high = total_high/size(high_secs, 2)


%%
% Make x-axis for showing time in seconds
times = linspace(0, time_in_sec, size(smoothed1, 1));

% Plot is shown from 2sec to 18sec since the rate calculation fails at
% endpoints.

f = figure;

subplot(2,1,1);
plot(times, smoothed1);
ylabel('Output rate, Hz');
title(sprintf('Instantaneous output rate, %.1fs sliding time window', smooth_window1));
xlim([2 time_in_sec-2]);

subplot(2,1,2);
plot(times, smoothed2);
xlabel('Time, s');
ylabel('Output rate, Hz');
title(sprintf('Instantaneous output rate, %.0fs sliding time window', smooth_window2));
xlim([2 time_in_sec-2]);
line([0 20], [rate_low rate_low], 'Color', 'r', 'LineStyle', '--');
line([0 20], [rate_high rate_high], 'Color', 'r', 'LineStyle', '--');