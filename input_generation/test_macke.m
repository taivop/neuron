
% Paths
p = 'mackeetal';
addpath(p)
addpath(fullfile(p,'lib'))
addpath(fullfile(p,'interface'))

c_desired = 0.9;

actual_correlations = [];
for i=1:100
    [spikes_binary, spiketimes, c_actual] = GenerateInputSpikesMacke(10, 30, c_desired, 1000, 0.1, '');
    actual_correlations = [actual_correlations c_actual];
end;

histogram(actual_correlations);
hold on;
m = mean(actual_correlations);
line([m m],[0 30], 'LineWidth', 2, 'Color', 'r');
line([c_desired c_desired],[0 30], 'LineWidth', 2, 'Color', 'g', 'LineStyle', '--');

fprintf('desired correlation %.2f, actual mean correlation%.2f\n',  c_desired, m);