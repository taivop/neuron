
load('data_out/results');
dt=0.1;

low_secs = (0:2:16);
high_secs = (1:2:17);

bool = zeros(1, T0/dt);
bool(spikes_post) = 1;

total_low = 0;
for s=low_secs
    total_low = total_low + sum(bool(s*10000+1:(s+1)*10000));
end;

total_high = 0;
for s=high_secs
    total_high = total_high + sum(bool(s*10000+1:(s+1)*10000));
end;

rate_low = total_low/size(low_secs, 2)
rate_high = total_high/size(high_secs, 2)