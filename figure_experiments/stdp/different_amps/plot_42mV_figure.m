cd('data/');

file = 'res_STDP_amp42_2015-04-20_20-34-13';

d = load(file);

cd ..;

% Plot figures
f = figure;
set(f, 'units', 'inches', 'pos', [2 2 5.77 4.3275])

plot(d.deltaTvalues,d.meanWeights,'k.-','LineWidth',2,'MarkerSize', 20)
line([min(d.deltaTvalues) max(d.deltaTvalues)], [1.25 1.25],'Color', 'k', 'LineStyle', '--');
axis tight;

amp = 42;
title('BPAP amplitude 42mV');
xlabel('\Deltat, ms')
ylabel('Mean final weight')

% Save into file
set(gca,'fontsize', 13);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 2 5.77 4.3275]);
print('../../../../bscthesis/figures/valid_stdp_bpap42', '-depsc');

%close(f);
