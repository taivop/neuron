rE = 1:100;


windowcoords = [100, 50, 1000, 900];
f = figure('Position', windowcoords);

set(gca,'OuterPosition',[0.05 0.05 0.9 0.9]);
imagesc(g_plas_history(rE,:));
colorbar('eastoutside');

xlabel('time (s)');
ylabel('synapse no.');

savefig(f, 'figures/weights_raster_30Hz.fig');
print -depsc figures/fig_weights_raster_30Hz.eps

%close(f)