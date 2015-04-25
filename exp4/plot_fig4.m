res1 = load('data_out/results1');
res2 = load('data_out/results2');
res3 = load('data_out/results3');
res4 = load('data_out/results4');
res5 = load('data_out/results5');
res6 = load('data_out/results6');
res7 = load('data_out/results7');
res8 = load('data_out/results8');
res9 = load('data_out/results9');
res_comp = load('data_out/results_comparison');

counts = res1.counts_group1; % same for every experiment
y = [];

for res=[res1 res2 res3 res4 res5 res6 res7 res8 res9]
    y = [y; res.rates_output];
end;

means = mean(y, 1);
stdevs = std(y, 1);

%% Comparison
means_comp = mean(res_comp.rates_matrix, 1);
stdevs_comp = std(res_comp.rates_matrix, 1);

%% Plotting
f = figure;
set(f, 'units', 'inches', 'pos', [2 2 5.77 4.3275])
set(gca,'fontsize', 13);
hold on;

plot(counts, means, '.-', 'LineWidth', 2, 'MarkerSize', 20);
plot(counts, means_comp, '.-', 'Color', [1 .5 0], 'LineWidth', 2, 'MarkerSize', 20);
plot(counts, means-stdevs, 'k--');
plot(counts, means+stdevs, 'k--');

legend({'Neuron trained with high-rate channel', 'Neuron trained on flat input', ...
    '1SD lines'}, 'Location', 'southeast');
xlabel('Number of synapses in pattern');
ylabel('Output rate, Hz')
title('')

set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 2 5.77 4.3275]);
print('../../bscthesis/figures/exp4_synapsecount.eps', '-depsc');
%saveas(f, '../../bscthesis/figures/exp4_synapsecount.eps', 'eps');
hold off;

