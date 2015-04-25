
windowcoords = [100, 50, 1000, 900];
f = figure('Position', windowcoords);

plot(inputFreqs, outputFreqs, ...
    'Color','black','Marker','.','MarkerSize',15.0,'LineStyle','-','LineWidth',1.5);

xlabel('mean input activity (Hz)');
ylabel('mean output activity (Hz)');

%title('Mean output activity (Hz)');

savefig(f, 'figures/iocurve_epsp3.fig');
print -depsc figures/fig_iocurve_epsp3.eps

%close(f)