rE = 1:100;

windowcoords = [100, 50, 1000, 900];
f = figure('Position', windowcoords);

% plot initial and final excitatory weights

subplot(2,1,1)
dat = g_plas0(rE);
histogram(dat);
xlim([0.8 1.25]);
xlabel('initial weights')
ylabel('no. synapses in bin')

subplot(2,1,2)
dat = g_plas(rE);
histogram(dat);
xlim([0.8 1.25]);
xlabel('final weights')
ylabel('no. synapses in bin')

savefig(f, 'figures/weighthistogram_30Hz.fig');
print -depsc figures/fig_weighthistogram_30Hz.eps


%close(f)