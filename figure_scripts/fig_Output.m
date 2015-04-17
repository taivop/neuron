function [f] = fig_Output(spikes_post, T0, smooth_window)
    % Plots smoothed mean firing rate.
    % Assumes dt=0.1.
    % At edges, the rate is calculated over only a handful of timesteps, so
    % the calculation is inaccurate for the first and last second. These
    % zones are not shown.

    dt = 0.1;

    time_in_sec = T0 / 1000;

    bool = zeros(1, T0/dt);
    bool(spikes_post) = 1000/dt;
    
    if smooth_window == 0
        smoothed = bool;
    else
        smoothed = smooth(bool, smooth_window*1000/dt);
    end;

    % Make x-axis for showing time in seconds
    times = linspace(0, time_in_sec, size(smoothed, 1));

    f = figure;

    % Plot
    plot(times, smoothed);
    xlabel('Time, s');
    ylabel('Output rate, Hz');
    title(sprintf('Instantaneous output rate, smoothed with a %.1fs sliding time window', smooth_window));
    
    xlim([1 time_in_sec-1]);
    %line([1 1], [0 200], 'LineStyle', '--');
    %line([time_in_sec-1 time_in_sec-1], [0 200], 'LineStyle', '--');
    
    
end